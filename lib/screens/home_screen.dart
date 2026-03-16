import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _pageSize = 8;

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );

  final List<String> _bannerImages = const [
    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
  ];

  final List<_CategoryItem> _categories = const [
    _CategoryItem(icon: Icons.checkroom_outlined, title: 'Thời trang'),
    _CategoryItem(icon: Icons.phone_android_outlined, title: 'Điện thoại'),
    _CategoryItem(icon: Icons.spa_outlined, title: 'Mỹ phẩm'),
    _CategoryItem(icon: Icons.kitchen_outlined, title: 'Đồ gia dụng'),
    _CategoryItem(icon: Icons.watch_outlined, title: 'Phụ kiện'),
    _CategoryItem(icon: Icons.sports_esports_outlined, title: 'Đồ chơi'),
    _CategoryItem(icon: Icons.chair_outlined, title: 'Nội thất'),
    _CategoryItem(icon: Icons.menu_book_outlined, title: 'Sách'),
  ];

  List<Product> _allProducts = [];
  List<Product> _visibleProducts = [];
  String _searchQuery = '';

  bool _isInitialLoading = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  int _currentPage = 1;
  int _bannerIndex = 0;
  double _scrollOffset = 0;

  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _startBannerAutoPlay();
    _loadInitialProducts();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialProducts() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final products = await _apiService.fetchProducts();
      _allProducts = products;
      _applyFiltersAndResetPagination();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) {
      return;
    }

    setState(() {
      _isRefreshing = true;
    });

    try {
      final products = await _apiService.fetchProducts();
      _allProducts = products;
      _applyFiltersAndResetPagination();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final offset = _scrollController.offset;
    if ((offset - _scrollOffset).abs() > 1) {
      setState(() {
        _scrollOffset = offset;
      });
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 260) {
      _loadMoreProducts();
    }
  }

  void _startBannerAutoPlay() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_bannerController.hasClients) {
        return;
      }
      final nextPage = (_bannerIndex + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  List<Product> get _filteredProducts {
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) {
      return _allProducts;
    }

    return _allProducts.where((product) {
      return product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  void _applyFiltersAndResetPagination() {
    _currentPage = 1;
    final filtered = _filteredProducts;
    final count = filtered.length < _pageSize ? filtered.length : _pageSize;
    _visibleProducts = filtered.take(count).toList();
    _hasMoreData = _visibleProducts.length < filtered.length;
    setState(() {});
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreData || _isInitialLoading) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final filtered = _filteredProducts;
    final nextPage = _currentPage + 1;
    final nextCount = nextPage * _pageSize;
    final takeCount = nextCount < filtered.length ? nextCount : filtered.length;

    setState(() {
      _currentPage = nextPage;
      _visibleProducts = filtered.take(takeCount).toList();
      _hasMoreData = _visibleProducts.length < filtered.length;
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            if (_isInitialLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              SliverToBoxAdapter(child: _buildBannerSection(context)),
              SliverToBoxAdapter(child: _buildCategorySection(context)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
                  child: Text(
                    'Gợi ý hôm nay',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
              ),
              if (_visibleProducts.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Không tìm thấy sản phẩm phù hợp.'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  sliver: SliverGrid.builder(
                    itemCount: _visibleProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.58,
                        ),
                    itemBuilder: (context, index) {
                      final product = _visibleProducts[index];
                      return _ProductCard(product: product, index: index);
                    },
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Center(
                    child: _isLoadingMore
                        ? const CircularProgressIndicator()
                        : (!_hasMoreData && _visibleProducts.isNotEmpty)
                        ? const Text('Bạn đã xem hết gợi ý hôm nay.')
                        : null,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _bannerImages.length,
              onPageChanged: (value) {
                setState(() {
                  _bannerIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _bannerImages[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child;
                            }
                            return Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, error, stackTrace) => Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.35),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 12,
                          bottom: 10,
                          child: Text(
                            'Khuyến mãi sốc hôm nay',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerImages.length, (index) {
              final bool isActive = _bannerIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh mục nổi bật',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 170,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    _searchController.text = category.title;
                    setState(() {
                      _searchQuery = category.title;
                    });
                    _applyFiltersAndResetPagination();
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          size: 26,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool isScrolled = _scrollOffset > 12;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 96,
      elevation: isScrolled ? 2 : 0,
      backgroundColor: isScrolled
          ? colors.primaryContainer
          : Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'Mua sắm mỗi ngày',
        style: TextStyle(
          color: isScrolled ? colors.onPrimaryContainer : colors.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: const [_CartBadgeButton()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: SearchBar(
            controller: _searchController,
            hintText: 'Tìm kiếm sản phẩm hoặc danh mục',
            leading: const Icon(Icons.search_rounded),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surface,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _applyFiltersAndResetPagination();
            },
            trailing: [
              if (_searchQuery.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _applyFiltersAndResetPagination();
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.index});

  final Product product;
  final int index;

  static const List<String> _tags = ['Mall', 'Yêu thích', 'Giảm 50%'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final String tag = _tags[index % _tags.length];
    final int sold = (product.id * 321) % 2500 + 100;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: ColoredBox(
                          color: Colors.white,
                          child: Image.network(
                            product.thumbnail,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return child;
                              }
                              return Container(
                                color: colors.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (_, error, stackTrace) =>
                                const Center(
                                  child: Icon(Icons.broken_image_outlined),
                                ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                _formatPrice(product.price),
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Đã bán ${_formatSold(sold)}',
                style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  String _formatSold(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }
}

class _CartBadgeButton extends StatelessWidget {
  const _CartBadgeButton();

  @override
  Widget build(BuildContext context) {
    final int totalTypes = context.select<CartProvider, int>(
      (provider) => provider.items.length,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Giỏ hàng',
          ),
          if (totalTypes > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$totalTypes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem({required this.icon, required this.title});

  final IconData icon;
  final String title;
}
