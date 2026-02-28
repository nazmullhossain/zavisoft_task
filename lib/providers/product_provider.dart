
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:havisoft/utils/api_helper.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _mensProducts = [];
  List<Product> _womensProducts = [];
  List<Product> _electronicsProducts = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;


  final Map<int, double> _tabScrollPositions = {
    0: 0.0,
    1: 0.0,
    2: 0.0,
  };

  List<Product> get allProducts => _allProducts;
  List<Product> get mensProducts => _mensProducts;
  List<Product> get womensProducts => _womensProducts;
  List<Product> get electronicsProducts => _electronicsProducts;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double getScrollPositionForTab(int tabIndex) {
    return _tabScrollPositions[tabIndex] ?? 0.0;
  }

  void saveScrollPosition(int tabIndex, double position) {
    _tabScrollPositions[tabIndex] = position;
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiHelper.baseUrl}/products'),
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
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = 'Network error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiHelper.baseUrl}/users/$userId'),
      );

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(json.decode(response.body));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiHelper.baseUrl}/auth/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {

        await fetchUser(1);
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
  }
}