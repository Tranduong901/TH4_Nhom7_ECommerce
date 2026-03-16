import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final List<CartItem> items = cartProvider.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: items.isEmpty
          ? const Center(child: Text('Giỏ hàng đang trống.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey('cart-item-${item.product.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    cartProvider.removeItem(item.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã xóa ${item.product.title} khỏi giỏ hàng',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: item.isSelected,
                            onChanged: (value) {
                              cartProvider.toggleItemSelection(
                                item.product,
                                value ?? false,
                              );
                            },
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ColoredBox(
                              color: Colors.white,
                              child: Image.network(
                                item.product.thumbnail,
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                                errorBuilder: (_, error, stackTrace) =>
                                    const SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: Icon(Icons.broken_image_outlined),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${item.product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cartProvider.decrementQuantity(
                                          item.product,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      onPressed: () {
                                        cartProvider.incrementQuantity(
                                          item.product,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _CartBottomBar(itemsExist: items.isNotEmpty),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({required this.itemsExist});

  final bool itemsExist;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final bool canCheckout = cartProvider.hasSelectedItems;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Checkbox(
                  tristate: true,
                  value: cartProvider.selectAllValue,
                  onChanged: itemsExist
                      ? (value) {
                          cartProvider.toggleAll(value ?? false);
                        }
                      : null,
                ),
                const Text('Chọn tất cả'),
                const Spacer(),
                Text(
                  'Tổng: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canCheckout
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              selectedItems: List<CartItem>.from(
                                cartProvider.selectedItems,
                              ),
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Thanh toán'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
