import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Giỏ hàng', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        elevation: 0,
        centerTitle: true,
        actions: [
           TextButton(
             onPressed: () {}, 
             child: const Text('Sửa', style: TextStyle(color: Colors.black54))
           )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
             return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Giỏ hàng của bạn còn trống', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                     onPressed: () => Navigator.pop(context),
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                     child: const Text('MUA SẮM NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: cartProvider.items.length,
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
            itemBuilder: (ctx, i) {
              final item = cartProvider.items[i];
              return Dismissible(
                key: Key('${item.product.id}_${item.size}_${item.color}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.delete, color: Colors.white),
                       Text('Xóa', style: TextStyle(color: Colors.white, fontSize: 12))
                    ],
                  ),
                ),
                onDismissed: (direction) => cartProvider.removeItem(i),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: item.isSelected,
                          activeColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (_) => cartProvider.toggleItemSelection(i),
                        ),
                        Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(4)),
                           child: CachedNetworkImage(imageUrl: item.product.image, width: 80, height: 80, fit: BoxFit.contain)
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(2)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Phân loại: ${item.color}, ${item.size}', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                    const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${item.product.price}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                                  Container(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
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
                                                   content: const Text('Bạn có chắc muốn bỏ sản phẩm này khỏi giỏ hàng?'),
                                                   actions: [
                                                     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('KHÔNG', style: TextStyle(color: Colors.grey))),
                                                     TextButton(onPressed: () {
                                                       Navigator.pop(ctx);
                                                       cartProvider.removeItem(i);
                                                     }, child: const Text('CÓ', style: TextStyle(color: Colors.blueAccent))),
                                                   ]
                                                 )
                                               );
                                            } else {
                                               cartProvider.updateQuantity(i, -1);
                                            }
                                          },
                                          child: Container(width: 28, height: 28, alignment: Alignment.center, child: Icon(Icons.remove, size: 16, color: item.quantity == 1 ? Colors.grey : Colors.black87)),
                                        ),
                                        Container(width: 1, height: 28, color: Colors.grey[300]),
                                        Container(width: 35, height: 28, alignment: Alignment.center, child: Text('${item.quantity}', style: const TextStyle(fontSize: 14))),
                                        Container(width: 1, height: 28, color: Colors.grey[300]),
                                        InkWell(
                                          onTap: () => cartProvider.updateQuantity(i, 1),
                                          child: Container(width: 28, height: 28, alignment: Alignment.center, child: const Icon(Icons.add, size: 16, color: Colors.black87)),
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
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) => Container(
        height: 60,
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
        child: Row(
          children: [
            Row(
              children: [
                Checkbox(
                  value: cart.isSelectAll,
                  activeColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (v) => cart.toggleSelectAll(v ?? false),
                ),
                const Text('Tất cả', style: TextStyle(fontSize: 14)),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Tổng thanh toán', style: TextStyle(fontSize: 12, color: Colors.black87)),
                Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: cart.totalAmount > 0 ? () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
              } : null,
              child: Container(
                 height: 60,
                 padding: const EdgeInsets.symmetric(horizontal: 24),
                 color: cart.totalAmount > 0 ? Colors.blueAccent : Colors.grey[400],
                 alignment: Alignment.center,
                 child: Text('Mua Hàng (${cart.items.where((i)=>i.isSelected).length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
