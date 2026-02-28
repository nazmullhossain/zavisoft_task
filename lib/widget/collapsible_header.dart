
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CollapsibleHeader extends StatelessWidget {
  const CollapsibleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160.0,
      // collapsedHeight: 70.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      stretch: true,


      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {

          final top = constraints.biggest.height;
          final isCollapsed = top < 120;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.lightBlue],
              ),
            ),
            child: SafeArea(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: isCollapsed ? 12 : 20,
                  bottom: isCollapsed ? 12 : 16,
                ),
                child: isCollapsed
                    ? _buildCollapsedHeader(context)  // ছোট অবস্থায়
                    : _buildExpandedHeader(context),  // বড় অবস্থায়
              ),
            ),
          );
        },
      ),
    );
  }

  // 🟢 বড় অবস্থায় (পুরো header)
  Widget _buildExpandedHeader(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // User Profile Section (বড়)
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null
                            ? '${user.firstName} ${user.lastName}'
                            : 'Guest User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'Not logged in',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Bar (শুধু বড় অবস্থায়)
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .searchProducts(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      if (provider.searchQuery.isNotEmpty) {
                        return IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            provider.clearSearch();
                            FocusScope.of(context).unfocus();
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildCollapsedHeader(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        return Row(
          children: [

            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(
                user?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // শুধু নাম (ইমেইল ছাড়া)
            Expanded(
              child: Text(
                user != null
                    ? '${user.firstName} ${user.lastName}'
                    : 'Guest User',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}