import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  /// Provides a consistent page transition for opening the cart.
  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CartScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
            Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));
        final fade = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
        return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: fade, child: child));
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List _visibleItems = [];
  late CartProvider _provider;

  @override
  void initState() {
    super.initState();
    // provider is initialized in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<CartProvider>(context);
    if (!mounted) return;
    if (_visibleItems.isEmpty) {
      _provider = provider;
      _visibleItems = List.from(provider.items);
      provider.addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    if (!mounted) return;
    setState(() {
      _visibleItems = List.from(_provider.items);
    });
  }

  @override
  void dispose() {
    try {
      _provider.removeListener(_onProviderChanged);
    } catch (_) {}
    super.dispose();
  }

  Widget _buildItemWidget(
      BuildContext context, int index, Animation<double>? animation) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (index >= cartProvider.items.length || index >= _visibleItems.length) {
      return const SizedBox.shrink();
    }
    final item = _visibleItems[index];
    final child = Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: item.isSelected,
              activeColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onChanged: (_) => cartProvider.toggleItemSelection(index),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                  imageUrl: item.product.image,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Phân loại: ${item.color}, ${item.size}',
                            style: Theme.of(context).textTheme.bodySmall),
                        const Icon(Icons.arrow_drop_down, size: 16)
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${item.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (item.quantity == 1) {
                                  // Confirm deletion
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            title: const Text('Xác nhận'),
                                            content: const Text(
                                                'Bạn có chắc muốn bỏ sản phẩm này khỏi giỏ hàng?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx),
                                                  child: Text('KHÔNG',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface))),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(ctx);
                                                    _removeItemAt(index);
                                                  },
                                                  child: Text('CÓ',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary))),
                                            ],
                                          ));
                                } else {
                                  cartProvider.updateQuantity(index, -1);
                                }
                              },
                              child: Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.remove,
                                      size: 18,
                                      color: item.quantity == 1
                                          ? Theme.of(context).disabledColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                            ),
                            Container(
                                width: 1,
                                height: 36,
                                color: Theme.of(context).colorScheme.outline),
                            Container(
                                width: 44,
                                height: 36,
                                alignment: Alignment.center,
                                child: Text('${item.quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                            Container(
                                width: 1,
                                height: 36,
                                color: Theme.of(context).colorScheme.outline),
                            InkWell(
                              onTap: () =>
                                  cartProvider.updateQuantity(index, 1),
                              child: Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.add,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (animation != null) {
      return SizeTransition(sizeFactor: animation, child: child);
    }
    return child;
  }

  Widget _buildRemovedItemWidget(
      BuildContext context, dynamic item, Animation<double>? animation) {
    final child = Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // static placeholder for removed item during animation
            Container(width: 24, height: 24),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                  imageUrl: item.product.image,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text('\$${item.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (animation != null) {
      return SizeTransition(sizeFactor: animation, child: child);
    }
    return child;
  }

  void _removeItemAt(int index) {
    if (index < 0 || index >= _visibleItems.length) return;
    final removed = _visibleItems.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildRemovedItemWidget(context, removed, animation),
      duration: const Duration(milliseconds: 300),
    );
    // update provider after local removal
    _provider.removeItemAt(index);

    // Hide any current SnackBar (animates out) before showing the new one so
    // the message will auto-dismiss after a short duration.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Đã xóa "${removed.product.title}"'),
      action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            // Hide the snackbar immediately when user taps Undo, then reinsert.
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // reinsert locally and in provider
            _visibleItems.insert(index, removed);
            _listKey.currentState?.insertItem(index);
            _provider.insertItemAt(index, removed);
          }),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // use Material 3 surface token for scaffold background
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Giỏ hàng',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: colorScheme.onPrimaryContainer)),
        // use primaryContainer for prominent app bar in MD3 and proper onPrimaryContainer for contrast
        backgroundColor: colorScheme.primaryContainer,
        iconTheme: IconThemeData(color: colorScheme.onPrimaryContainer),
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBody() {
    if (_provider.isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary));
    }
    if (_visibleItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart_outlined,
                size: 80,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.28)),
            const SizedBox(height: 16),
            Text('Giỏ hàng của bạn còn trống',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
              child: Text('MUA SẮM NGAY',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }

    final cartProvider = context.watch<CartProvider>();

    return AnimatedList(
      key: _listKey,
      initialItemCount: cartProvider.items.length,
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index, animation) {
        if (index >= cartProvider.items.length ||
            index >= _visibleItems.length) {
          return const SizedBox.shrink();
        }
        final item = _visibleItems[index];
        return Dismissible(
          key: Key('${item.product.id}_${item.size}_${item.color}'),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Xác nhận'),
                content: Text(
                    'Bạn có chắc muốn xóa "${item.product.title}" khỏi giỏ hàng?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('KHÔNG')),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('CÓ')),
                ],
              ),
            );
            if (confirmed == true) {
              // perform animated removal and return false to prevent Dismissible from auto-removing
              _removeItemAt(index);
            }
            return false;
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Theme.of(context).colorScheme.error,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.onError),
                const SizedBox(height: 4),
                Text('Xóa',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 12))
              ],
            ),
          ),
          child: _buildItemWidget(context, index, animation),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) => Container(
        height: 78,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: cart.isSelectAll,
                    activeColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    checkColor: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    onChanged: (v) => cart.toggleSelectAll(v ?? false),
                  ),
                  Text('Tất cả',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Tổng thanh toán',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                  Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: cart.totalAmount > 0
                    ? () {
                        final selectedItems = cart.items
                            .where((item) => item.isSelected)
                            .map(
                              (item) => CartItem(
                                product: item.product,
                                quantity: item.quantity,
                                size: item.size,
                                color: item.color,
                                isSelected: item.isSelected,
                                addedAt: item.addedAt,
                              ),
                            )
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CheckoutScreen(selectedItems: selectedItems),
                          ),
                        );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: Text(
                    'Mua Hàng (${cart.items.where((i) => i.isSelected).length})',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
