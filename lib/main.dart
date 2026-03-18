import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Đảm bảo anh đã copy file này sang TH4_Nhom7_ECommerce/lib/
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/main_screen.dart';

import 'providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyEcommerceApp(),
    ),
  );
}

class MyEcommerceApp extends StatelessWidget {
  const MyEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TH4 - ECommerce Nhóm 7',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent, primary: Colors.blueAccent),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      routes: {
        '/home': (context) => const MainScreen(),
      },
      home: const MainScreen(),
    );
  }
}
