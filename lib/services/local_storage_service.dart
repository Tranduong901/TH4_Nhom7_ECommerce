import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class LocalStorageService {
  static const String cartKey = 'CART_DATA';

  Future<void> saveCart(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonItems = cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(cartKey, jsonItems);
  }

  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonItems = prefs.getStringList(cartKey);
    
    if (jsonItems == null) {
      return [];
    }

    return jsonItems.map((jsonStr) => CartItem.fromJson(jsonDecode(jsonStr))).toList();
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }
}
