import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Đơn Mua Của Tôi', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blueAccent),
          elevation: 0,
          bottom: const TabBar(
             isScrollable: true,
             labelColor: Colors.blueAccent,
             unselectedLabelColor: Colors.black54,
             indicatorColor: Colors.blueAccent,
             tabs: [
               Tab(text: 'Chờ thanh toán'),
               Tab(text: 'Đang giao'),
               Tab(text: 'Hoàn thành'),
               Tab(text: 'Đã hủy'),
             ]
          ),
        ),
        body: const TabBarView(
          children: [
            _OrdersList(status: 'Chờ thanh toán', icon: Icons.receipt_long),
            _OrdersList(status: 'Đang giao', icon: Icons.local_shipping_outlined),
            _OrdersList(status: 'Hoàn thành', icon: Icons.check_circle_outline),
            _OrdersList(status: 'Đã hủy', icon: Icons.cancel_outlined),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final String status;
  final IconData icon;

  const _OrdersList({required this.status, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Chưa có đơn hàng nào $status', style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
