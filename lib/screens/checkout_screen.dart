import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import 'home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'COD';

  void _submitOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text('Đặt hàng thành công!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        content: const Text('Đơn hàng của bạn đã được ghi nhận và đang chờ xử lý.', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<CartProvider>().clearSelectedItems();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('VỀ TRANG CHỦ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final selectedItems = cart.items.where((i) => i.isSelected).toList();
    
    if (selectedItems.isEmpty) {
        return Scaffold(
           appBar: AppBar(title: const Text('Thanh toán')),
           body: const Center(child: Text('Không có sản phẩm để thanh toán')),
        );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Thanh Toán', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Địa chỉ nhận hàng
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Địa chỉ nhận hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Nguyễn Văn A (+84) 987 654 321\n123 Đường Điện Biên Phủ, Phường 15, Quận Bình Thạnh, TP. Hồ Chí Minh', style: TextStyle(color: Colors.black87, height: 1.5)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            
            // Danh sách sản phẩm mua
            Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Column(
                children: [
                   const Padding(
                     padding: EdgeInsets.all(16.0),
                     child: Row(
                       children: [
                         Icon(Icons.store, size: 20),
                         SizedBox(width: 8),
                         Text('TH4 - NHÓM 7 MALL', style: TextStyle(fontWeight: FontWeight.bold)),
                       ],
                     ),
                   ),
                   const Divider(height: 1),
                   ...selectedItems.map((item) => Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!)),
                           child: CachedNetworkImage(imageUrl: item.product.image, width: 70, height: 70, fit: BoxFit.contain)
                         ),
                         const SizedBox(width: 12),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                               const SizedBox(height: 4),
                               Text('Phân loại: ${item.color}, ${item.size}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                               const SizedBox(height: 8),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text('\$${item.product.price}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                   Text('x${item.quantity}', style: TextStyle(color: Colors.grey[800])),
                                 ],
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   )).toList(),
                   
                   const Divider(height: 1),
                   Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('Tổng số tiền (${selectedItems.length} sản phẩm):'),
                         Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                       ],
                     ),
                   )
                ],
              )
            ),

            // Phương thức thanh toán
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 80),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Row(children: [Icon(Icons.money, color: Colors.green), SizedBox(width: 10), Text('Thanh toán khi nhận hàng (COD)')]),
                    value: 'COD',
                    groupValue: _paymentMethod,
                    activeColor: Colors.blueAccent,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                  RadioListTile<String>(
                    title: const Row(children: [Icon(Icons.account_balance_wallet, color: Colors.pink), SizedBox(width: 10), Text('Ví MoMo')]),
                    value: 'MOMO',
                    groupValue: _paymentMethod,
                    activeColor: Colors.blueAccent,
                    onChanged: (value) => setState(() => _paymentMethod = value!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Tổng thanh toán', style: TextStyle(fontSize: 13, color: Colors.black87)),
                  Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: _submitOrder,
              child: Container(
                 height: 70,
                 padding: const EdgeInsets.symmetric(horizontal: 40),
                 color: Colors.blueAccent,
                 alignment: Alignment.center,
                 child: const Text('ĐẶT HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
