import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Đơn Mua Của Tôi',
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.normal)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blueAccent),
          elevation: 0,
          bottom: const TabBar(
              isScrollable: true,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blueAccent,
              tabs: [
                Tab(text: 'Chờ xác nhận'),
                Tab(text: 'Đang giao'),
                Tab(text: 'Đã giao'),
                Tab(text: 'Đã hủy'),
              ]),
        ),
        body: const TabBarView(
          children: [
            _OrdersList(status: 'Chờ xác nhận', icon: Icons.receipt_long),
            _OrdersList(
                status: 'Đang giao', icon: Icons.local_shipping_outlined),
            _OrdersList(status: 'Đã giao', icon: Icons.check_circle_outline),
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
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.getOrdersByStatus(status);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Chưa có đơn hàng nào $status',
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(order: order);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  Color _getStatusColorValue(String status) {
    switch (status) {
      case 'Chờ xác nhận':
        return Colors.orange;
      case 'Đang giao':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColorValue(order.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _getStatusColorValue(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order Items Preview
            if (firstItem != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!)),
                    child: CachedNetworkImage(
                      imageUrl: firstItem.product.image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${firstItem.color}, ${firstItem.size} x${firstItem.quantity}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        if (order.items.length > 1)
                          Text(
                            '...và ${order.items.length - 1} sản phẩm khác',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 11),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Order Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giao đến:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.shippingAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Hình thức:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.paymentMethod == 'COD'
                          ? 'Thanh toán khi nhận'
                          : 'Ví MoMo',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order Date
            Text(
              'Ngày đặt: ${_formatDate(order.createdAt)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
