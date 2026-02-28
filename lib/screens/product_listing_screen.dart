import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widget/collapsible_header.dart';
import '../widget/product_tabs.dart';


class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.fetchProducts();
    await provider.login('johnd', r'm38rmF$');
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      final savedPosition = provider.getScrollPositionForTab(_tabController.index);

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(savedPosition);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.fetchProducts();
  }

  void _saveCurrentScrollPosition() {
    if (_scrollController.hasClients) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.saveScrollPosition(
        _tabController.index,
        _scrollController.position.pixels,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CollapsibleHeader(),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                tabController: _tabController,
              ),
            ),
            SliverFillRemaining(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    _saveCurrentScrollPosition();
                  }
                  return false;
                },
                child: ProductTabs(
                  tabController: _tabController,
                  scrollController: _scrollController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  _StickyTabBarDelegate({required this.tabController});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: "Men's Clothing"),
          Tab(text: "Women's Clothing"),
          Tab(text: "Electronics"),
        ],
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        indicatorWeight: 3,
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}