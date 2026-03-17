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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      if (!productProvider.isLoading && productProvider.hasMore) {
        productProvider.fetchProducts(refresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return RefreshIndicator(
            onRefresh: () => productProvider.fetchProducts(refresh: true),
            color: Colors.blueAccent,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 120,
                  backgroundColor: Colors.blueAccent,
                  title: const Text('TH4 - NHÓM 7 MALL', 
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
                  actions: [
                    Consumer<CartProvider>(
                      builder: (context, cart, child) => Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                        child: badges.Badge(
                          badgeStyle: const badges.BadgeStyle(badgeColor: Colors.white),
                          badgeContent: Text('${cart.cartCount}', 
                            style: const TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          child: IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 30),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
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
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Bạn đang tìm kiếm gì hôm nay?',
                            prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
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
                      options: CarouselOptions(autoPlay: true, aspectRatio: 2.2, enlargeCenterPage: true, viewportFraction: 1.0),
                      items: productProvider.banners.map((url) => 
                        ClipRRect(borderRadius: BorderRadius.circular(15), 
                          child: Image.network(url, fit: BoxFit.cover, width: double.infinity))).toList(),
                    ),
                  ),
                ),

                // Categories
                if (productProvider.categories.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Danh Mục Nổi Bật', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(onPressed: (){}, child: const Text('Xem thêm', style: TextStyle(color: Colors.blueAccent))),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: productProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = productProvider.categories[index];
                          return Container(
                            width: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue[50],
                                  child: const Icon(Icons.category, color: Colors.blueAccent),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],

                // Grid Title
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Gợi Ý Hôm Nay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ),
                ),

                // Product Grid
                if (productProvider.products.isEmpty && productProvider.isLoading)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)))
                else if (productProvider.products.isEmpty && !productProvider.isLoading)
                  const SliverFillRemaining(child: Center(child: Text("Không có sản phẩm nào!")))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => ProductCard(product: productProvider.products[i]),
                        childCount: productProvider.products.length,
                      ),
                    ),
                  ),
                
                // Loading Indicator at bottom (Paginating)
                if (productProvider.isLoading && productProvider.products.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
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

