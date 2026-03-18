import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _productCategories = const [
    {'name': 'Thời trang', 'icon': Icons.checkroom, 'color': Color(0xFFFF6B6B)},
    {
      'name': 'Điện thoại',
      'icon': Icons.smartphone,
      'color': Color(0xFF4ECDC4)
    },
    {'name': 'Mỹ phẩm', 'icon': Icons.spa, 'color': Color(0xFFFFA94D)},
    {'name': 'Đồ gia dụng', 'icon': Icons.kitchen, 'color': Color(0xFF74C0FC)},
    {'name': 'Phụ kiện', 'icon': Icons.watch, 'color': Color(0xFFC7CEEA)},
    {'name': 'Giày dép', 'icon': Icons.hiking, 'color': Color(0xFFB197FC)},
    {'name': 'Đồng hồ', 'icon': Icons.schedule, 'color': Color(0xFF69DB7C)},
    {'name': 'Đồ điện tử', 'icon': Icons.devices, 'color': Color(0xFF91A7FF)},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      if (!productProvider.isLoading && productProvider.hasMore) {
        productProvider.fetchProducts(refresh: false);
      }
    }
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                (category['color'] as Color).withValues(alpha: 0.15),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              category['name'] as String,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return RefreshIndicator(
            onRefresh: () => productProvider.fetchProducts(refresh: true),
            color: colorScheme.primary,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 120,
                  backgroundColor: colorScheme.primary,
                  title: Text('TH4 - NHÓM 7 MALL',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: colorScheme.onPrimary)),
                  actions: [
                    Consumer<CartProvider>(
                      builder: (context, cart, child) => Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                              badgeColor: colorScheme.onPrimary),
                          badgeContent: Text('${cart.cartCount}',
                              style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          child: IconButton(
                            icon: Icon(Icons.shopping_bag_outlined,
                                color: colorScheme.onPrimary, size: 30),
                            onPressed: () =>
                                Navigator.push(context, CartScreen.route()),
                          ),
                        ),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Bạn đang tìm kiếm gì hôm nay?',
                            prefixIcon:
                                Icon(Icons.search, color: colorScheme.primary),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.2,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0),
                      items: productProvider.banners
                          .map((url) => ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(url,
                                  fit: BoxFit.cover, width: double.infinity)))
                          .toList(),
                    ),
                  ),
                ),

                // Categories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Danh mục Sản phẩm',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                            onPressed: () {},
                            child: Text('Xem thêm',
                                style: TextStyle(color: colorScheme.primary))),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _productCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) =>
                          _buildCategoryCard(_productCategories[index]),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Grid Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text('Gợi Ý Hôm Nay',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary)),
                  ),
                ),

                // Product Grid
                if (productProvider.products.isEmpty &&
                    productProvider.isLoading)
                  SliverFillRemaining(
                      child: Center(
                          child: CircularProgressIndicator(
                              color: colorScheme.primary)))
                else if (productProvider.products.isEmpty &&
                    !productProvider.isLoading)
                  const SliverFillRemaining(
                      child: Center(child: Text("Không có sản phẩm nào!")))
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) =>
                            ProductCard(product: productProvider.products[i]),
                        childCount: productProvider.products.length,
                      ),
                    ),
                  ),

                // Loading Indicator at bottom (Paginating)
                if (productProvider.isLoading &&
                    productProvider.products.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: colorScheme.primary)),
                    ),
                  ),

                // Spacing
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }
}
