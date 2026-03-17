import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isExpanded = false;

  void _showAddToCartSheet() {
    String selectedSize = 'M';
    String selectedColor = 'Đen';
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // For custom rounded corners
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => 
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image & Pricing
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)
                              ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: widget.product.image, 
                                width: 100, 
                                height: 100, 
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 100, height: 60), // Spacer for positioning
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${widget.product.price}', style: const TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text('Kho: 99+', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: Colors.grey,)
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        const SizedBox(height: 16),
                        const Text('Màu Sắc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: ['Đen', 'Trắng', 'Đỏ', 'Xanh'].map((c) => _buildChoiceChip(
                            label: c,
                            selected: selectedColor == c,
                            onSelected: () => setSheetState(() => selectedColor = c),
                          )).toList(),
                        ),
                        
                        const SizedBox(height: 24),
                        const Text('Kích Cỡ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: ['S', 'M', 'L', 'XL'].map((s) => _buildChoiceChip(
                            label: s,
                            selected: selectedSize == s,
                            onSelected: () => setSheetState(() => selectedSize = s),
                          )).toList(),
                        ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                    onPressed: () => setSheetState(() => quantity > 1 ? quantity-- : null), 
                                    icon: const Icon(Icons.remove, size: 20, color: Colors.grey)
                                  ),
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.grey[300]!))),
                                    child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                    onPressed: () => setSheetState(() => quantity++), 
                                    icon: const Icon(Icons.add, size: 20, color: Colors.grey)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                     ],
                  )
                )
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().addToCart(widget.product, selectedSize, selectedColor, quantity);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm sản phẩm vào giỏ!'), backgroundColor: Colors.green));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, 
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: const Text('XÁC NHẬN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildChoiceChip({required String label, required bool selected, required VoidCallback onSelected}) {
     return GestureDetector(
       onTap: onSelected,
       child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
             color: selected ? Colors.blue[50] : Colors.grey[100],
             border: Border.all(color: selected ? Colors.blueAccent : Colors.transparent),
             borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: TextStyle(
             color: selected ? Colors.blueAccent : Colors.black87,
             fontWeight: selected ? FontWeight.bold : FontWeight.normal
          )),
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    String originalPrice = (widget.product.price * 1.5).toStringAsFixed(2);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: Consumer<CartProvider>(
                builder: (context, cart, child) => badges.Badge(
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.blueAccent),
                  badgeContent: Text('${cart.cartCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Hero
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 80, bottom: 20),
              child: Hero(
                tag: 'product_${widget.product.id}',
                child: CachedNetworkImage(imageUrl: widget.product.image, height: 350, width: double.infinity, fit: BoxFit.contain),
              ),
            ),
            
            // Pricings and Titles
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       Text('\$${widget.product.price}', style: const TextStyle(color: Colors.red, fontSize: 26, fontWeight: FontWeight.bold)),
                       const SizedBox(width: 8),
                       Text('\$$originalPrice', style: const TextStyle(color: Colors.grey, fontSize: 16, decoration: TextDecoration.lineThrough)),
                       const SizedBox(width: 8),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                         decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                         child: const Text('GIẢM 33%', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))
                       )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                        child: const Text('Mall', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.product.title, 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${widget.product.rating.rate}', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 12, color: Colors.grey[400]),
                      const SizedBox(width: 8),
                      Text('Đã bán ${widget.product.rating.count}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            // Variables Sheet Trigger
            GestureDetector(
              onTap: _showAddToCartSheet,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: const Row(
                  children: [
                    Text('Chọn Phân Loại:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    SizedBox(width: 16),
                    Expanded(child: Text('Màu sắc, Kích cỡ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            // Description
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CHI TIẾT MÔ TẢ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.description, 
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                    maxLines: _isExpanded ? null : 4,
                    overflow: _isExpanded ? null : TextOverflow.fade,
                  ),
                  if (widget.product.description.length > 100)
                    Center(
                      child: TextButton(
                        onPressed: () => setState(() => _isExpanded = !_isExpanded),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_isExpanded ? 'Thu gọn' : 'Xem thêm', style: const TextStyle(color: Colors.blueAccent)),
                            Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.blueAccent)
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   Column(
                     mainAxisSize: MainAxisSize.min,
                     children: const [Icon(Icons.chat_outlined, color: Colors.blueAccent), Text('Chat ngay', style: TextStyle(fontSize: 10, color: Colors.blueAccent))],
                   ),
                   Container(width: 1, height: 30, color: Colors.grey[300]),
                   InkWell(
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Consumer<CartProvider>(
                           builder: (context, cart, child) => badges.Badge(
                              badgeStyle: const badges.BadgeStyle(badgeColor: Colors.blueAccent, padding: EdgeInsets.all(3)),
                              badgeContent: Text('${cart.cartCount}', style: const TextStyle(color: Colors.white, fontSize: 8)),
                              child: const Icon(Icons.add_shopping_cart, color: Colors.black54),
                           ),
                         ),
                         const Text('Thêm vào', style: TextStyle(fontSize: 10, color: Colors.black54))
                       ],
                     ),
                   ),
                ],
              )
            ),
            Expanded(
              child: GestureDetector(
                onTap: _showAddToCartSheet,
                child: Container(
                  height: 56,
                  color: Colors.blue[50],
                  alignment: Alignment.center,
                  child: const Text('THÊM VÀO GIỎ MUA', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              )
            ),
            Expanded(
              child: GestureDetector(
                onTap: _showAddToCartSheet,
                child: Container(
                  height: 56,
                  color: Colors.blueAccent,
                  alignment: Alignment.center,
                  child: const Text('MUA NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}
