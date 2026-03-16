import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: 'product-image-${product.id}',
                          child: ColoredBox(
                            color: Colors.white,
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.contain,
                              errorBuilder: (_, error, stackTrace) =>
                                  const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Chip(label: Text(product.category)),
                    const SizedBox(height: 16),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openAddToCartSheet(context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Thêm vào giỏ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddToCartSheet(BuildContext context) {
    const List<String> sizes = ['S', 'M', 'L', 'XL'];
    const List<String> colors = ['Đen', 'Trắng', 'Xanh'];

    String selectedSize = sizes.first;
    String selectedColor = colors.first;
    int quantity = 1;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tùy chọn sản phẩm',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Kích cỡ',
                      border: OutlineInputBorder(),
                    ),
                    items: sizes
                        .map(
                          (size) => DropdownMenuItem<String>(
                            value: size,
                            child: Text(size),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setSheetState(() {
                        selectedSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedColor,
                    decoration: const InputDecoration(
                      labelText: 'Màu',
                      border: OutlineInputBorder(),
                    ),
                    items: colors
                        .map(
                          (color) => DropdownMenuItem<String>(
                            value: color,
                            child: Text(color),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setSheetState(() {
                        selectedColor = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Số lượng'),
                      const Spacer(),
                      IconButton(
                        onPressed: quantity > 1
                            ? () {
                                setSheetState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {
                          setSheetState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final cartProvider = context.read<CartProvider>();
                        for (int i = 0; i < quantity; i++) {
                          cartProvider.addItem(product);
                        }

                        Navigator.of(sheetContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã thêm $quantity sản phẩm (Kích cỡ $selectedSize, Màu $selectedColor) vào giỏ.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
