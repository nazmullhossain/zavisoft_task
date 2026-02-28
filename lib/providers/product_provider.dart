import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _mensProducts = [];
  List<Product> _womensProducts = [];
  List<Product> _electronicsProducts = [];
  List<Product> _searchResults = [];
  String _searchQuery = '';
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  final Map<int, double> _tabScrollPositions = {
    0: 0.0,
    1: 0.0,
    2: 0.0,
  };

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get mensProducts => _mensProducts;
  List<Product> get womensProducts => _womensProducts;
  List<Product> get electronicsProducts => _electronicsProducts;
  List<Product> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Scroll position methods
  double getScrollPositionForTab(int tabIndex) {
    return _tabScrollPositions[tabIndex] ?? 0.0;
  }

  void saveScrollPosition(int tabIndex, double position) {
    _tabScrollPositions[tabIndex] = position;
  }

  // Products fetch
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _allProducts = data.map((json) => Product.fromJson(json)).toList();

        _mensProducts = _allProducts
            .where((p) => p.category == "men's clothing")
            .toList();
        _womensProducts = _allProducts
            .where((p) => p.category == "women's clothing")
            .toList();
        _electronicsProducts = _allProducts
            .where((p) => p.category == "electronics")
            .toList();

        debugPrint('Products loaded: ${_allProducts.length}');
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = 'Network error: $e';
      debugPrint('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔍 লোকাল সার্চ ফাংশন
  void searchProducts(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
    } else {
      // সব প্রোডাক্ট থেকে সার্চ করুন (case insensitive)
      _searchResults = _allProducts.where((product) {
        final titleLower = product.title.toLowerCase();
        final categoryLower = product.category.toLowerCase();
        final descriptionLower = product.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            categoryLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
    }

    debugPrint('Search results for "$query": ${_searchResults.length} products found');
    notifyListeners();
  }

  // সার্চ ক্লিয়ার ফাংশন
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  // User fetch
  Future<void> fetchUser(int userId) async {
    try {
      debugPrint('Fetching user with ID: $userId');
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/users/$userId'),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        debugPrint('User data received');

        _currentUser = User.fromJson(jsonData);
        debugPrint('User parsed: ${_currentUser?.firstName} ${_currentUser?.lastName}');

        notifyListeners();
      } else {
        debugPrint('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
  }

  // Login
  Future<void> login(String username, String password) async {
    try {
      debugPrint('Attempting login with username: $username');

      final response = await http.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        String token = data['token'];
        debugPrint('Login successful! Token: $token');

        await fetchUser(1);
      } else {
        debugPrint('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
  }
}