import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';

class ProductTabs extends StatelessWidget {
  final TabController tabController;
  final ScrollController scrollController;

  const ProductTabs({
    super.key,
    required this.tabController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          if (tabController.index < tabController.length - 1) {
            tabController.animateTo(tabController.index + 1);
          }
        } else if (details.primaryVelocity! > 0) {
          if (tabController.index > 0) {
            tabController.animateTo(tabController.index - 1);
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          _ProductList(category: "men's clothing"),
          _ProductList(category: "women's clothing"),
          _ProductList(category: "electronics"),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final String category;

  const _ProductList({required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // যদি সার্চ কুয়েরি থাকে, তাহলে সার্চ রেজাল্ট দেখান
        if (provider.searchQuery.isNotEmpty) {
          return _buildSearchResults(provider);
        }

        // নইলে নরমাল ক্যাটাগরি ভিত্তিক প্রোডাক্ট দেখান
        if (provider.isLoading && provider.allProducts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${provider.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<Product> products;
        switch (category) {
          case "men's clothing":
            products = provider.mensProducts;
            break;
          case "women's clothing":
            products = provider.womensProducts;
            break;
          case "electronics":
            products = provider.electronicsProducts;
            break;
          default:
            products = [];
        }

        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: products.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _ProductCard(product: products[index]);
          },
        );
      },
    );
  }

  // 🔍 সার্চ রেজাল্ট দেখানোর জন্য আলাদা উইজেট
  Widget _buildSearchResults(ProductProvider provider) {
    if (provider.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found for "${provider.searchQuery}"',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: provider.searchResults.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _ProductCard(product: provider.searchResults[index]);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                            Text(
                              product.rating.rate.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}