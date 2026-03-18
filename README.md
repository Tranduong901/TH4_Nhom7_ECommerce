# 🛍️ TH4 Nhóm 7 - Ứng Dụng E-Commerce Flutter

Một ứng dụng mua sắm trực tuyến hiện đại xây dựng bằng **Flutter** với các tính năng đầy đủ: duyệt sản phẩm, giỏ hàng, thanh toán và lịch sử đơn hàng.

---

## ✨ Tính Năng Chính

### 🏠 Trang Chủ (Home Screen)
- 📱 Danh sách sản phẩm với hình ảnh từ API
- 🎠 Banner carousel hiển thị quảng cáo
- 📂 Danh mục sản phẩm
- 🔄 Load thêm sản phẩm khi cuộn xuống
- 🛍️ Nút thêm vào giỏ hàng nhanh

### 🛒 Giỏ Hàng (Cart Screen)
- ✅ Chọn/bỏ chọn sản phẩm
- ➕➖ Tăng/giảm số lượng
- 🗑️ Xóa sản phẩm (có hoàn tác)
- 💰 Tính tổng tiền tự động
- 🎫 Chuyển đến thanh toán

### 💳 Thanh Toán (Checkout Screen)
- 📍 Nhập địa chỉ giao hàng
- 🏦 Chọn phương thức thanh toán:
  - 💵 Thanh toán khi nhận (COD)
  - 📱 Ví MoMo
- 📋 Xem lại danh sách sản phẩm
- ✅ Xác nhận đặt hàng

### 📦 Lịch Sử Đơn Mua (Orders Screen)
- 4 tab theo trạng thái đơn hàng:
  - 🟠 Chờ xác nhận
  - 🔵 Đang giao
  - 🟢 Đã giao
  - 🔴 Đã hủy
- 📊 Xem chi tiết từng đơn
- 🗓️ Ngày tạo và thông tin giao hàng

### 🧭 Điều Hướng (Main Screen)
- BottomNavigationBar với 2 tab:
  - 🏠 Trang Chủ
  - 📋 Đơn Mua
- Chuyển đổi mượt mà giữa các tính năng

---

## 🏗️ Cấu Trúc Dự Án

```
lib/
├── main.dart                 # Entry point
├── firebase_options.dart     # Firebase config
├── models/
│   ├── product.dart         # Model sản phẩm
│   ├── cart_item.dart       # Model mục giỏ hàng
│   └── order.dart           # Model đơn hàng ✨ MỚI
├── providers/
│   ├── product_provider.dart       # Quản lý danh sách sản phẩm
│   ├── cart_provider.dart          # Quản lý giỏ hàng
│   └── order_provider.dart         # Quản lý đơn hàng ✨ MỚI
├── screens/
│   ├── main_screen.dart            # Trang chính ✨ MỚI
│   ├── home_screen.dart            # Trang chủ
│   ├── cart_screen.dart            # Giỏ hàng
│   ├── checkout_screen.dart        # Thanh toán 🔄 CẬP NHẬT
│   ├── orders_screen.dart          # Lịch sử đơn 🔄 CẬP NHẬT
│   └── product_detail_screen.dart  # Chi tiết sản phẩm
├── services/
│   ├── api_service.dart            # Gọi API sản phẩm
│   ├── firestore_service.dart      # Firebase Firestore
│   ├── cloudinary_service.dart     # Cloudinary images
│   └── local_storage_service.dart  # Lưu trữ địa phương
└── widgets/
    └── product_card.dart           # Widget thẻ sản phẩm
```

---

## 🚀 Cách Bắt Đầu

### Yêu Cầu
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code
- Kết nối Internet (để tải sản phẩm từ API)

### Cài Đặt

1. **Clone dự án** (nếu từ Git)
```bash
git clone https://github.com/TH4-Nhom7/ecommerce.git
cd TH4_Nhom7_ECommerce
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
flutter run
```

### Cấu Hình (Nếu Cần)
- **Firebase**: Sửa `lib/firebase_options.dart` 
- **API**: Kiểm tra `lib/services/api_service.dart`
- **Cloudinary**: Cập nhật token trong `lib/services/cloudinary_service.dart`

---

## 📱 Hướng Dẫn Sử Dụng

### 📖 Quy Trình Mua Hàng

```
1. Trang Chủ (HomeScreen)
   ├─ Xem danh sách sản phẩm
   ├─ Nhấn vào sản phẩm xem chi tiết
   └─ Nhấn "+ THÊM VÀO GIỎ"

2. Giỏ Hàng (CartScreen)
   ├─ Xem các mục đã thêm
   ├─ Chọn mục muốn mua (✓)
   ├─ Tăng/giảm số lượng
   └─ Nhấn "MUA HÀNG"

3. Thanh Toán (CheckoutScreen)
   ├─ Nhập địa chỉ giao hàng
   ├─ Chọn COD hoặc MOMO
   └─ Nhấn "ĐẶT HÀNG"

4. Xác Nhận (Dialog)
   └─ Nhấn "VỀ TRANG CHỦ"

5. Xem Đơn Hàng (OrdersScreen)
   ├─ Nhấn tab "Đơn Mua"
   ├─ Chọn tab trạng thái
   └─ Xem chi tiết từng đơn
```

### 💡 Mẹo Nhanh
- **Tìm sản phẩm**: Sử dụng thanh tìm kiếm ở Trang Chủ
- **Hoàn tác xóa**: Nhấn "Hoàn tác" trong SnackBar
- **Quay lại Trang Chủ**: Nhấn tab "Trang Chủ" ở BottomNavigationBar
- **Xem tất cả đơn**: Nhấn tab "Đơn Mua"

---

## 🛠️ Công Nghệ & Thư Viện

| Thư Viện | Mục Đích |
|----------|---------|
| **flutter** | Framework chính |
| **provider** | Quản lý trạng thái |
| **firebase_core** | Backend Firebase |
| **cloud_firestore** | Cơ sở dữ liệu Firestore |
| **carousel_slider** | Slider banner |
| **cached_network_image** | Tải ảnh được cache |
| **badges** | Huy hiệu giỏ hàng |
| **dio** | HTTP client |
| **shared_preferences** | Lưu local đơn giản |

---

## 📊 Kiến Trúc Ứng Dụng

```
Provider Pattern (State Management)
├── ProductProvider
│   ├── fetchProducts() - Lấy danh sách từ API
│   └── categories - Danh sách danh mục
├── CartProvider
│   ├── addToCart() - Thêm mục
│   ├── removeItem() - Xóa mục
│   ├── updateQuantity() - Thay đổi số lượng
│   └── clearSelectedItems() - Xóa mục đã chọn
└── OrderProvider ✨ MỚI
    ├── addOrder() - Lưu đơn hàng mới
    ├── getOrdersByStatus() - Lọc theo trạng thái
    ├── updateOrderStatus() - Cập nhật trạng thái
    └── cancelOrder() - Hủy đơn hàng
```

---

## 📝 Mô Tả Model

### 📦 Lớp Order (Model/order.dart)
```dart
Order
├── id: String              // Mã định danh duy nhất
├── items: List<CartItem>   // Danh sách sản phẩm
├── shippingAddress: String // Địa chỉ giao hàng
├── paymentMethod: String   // 'COD' hoặc 'MOMO'
├── status: String          // Trạng thái đơn
├── createdAt: DateTime     // Thời gian tạo
└── totalAmount: double     // Tổng tiền
```

### 🔄 Quy Trình Dữ Liệu

```
HomeScreen → thêm sản phẩm → CartProvider (thêm CartItem)
CartScreen → chọn items → CheckoutScreen (nhập thông tin)
CheckoutScreen → ĐẶT HÀNG → Order.create()
Order → OrderProvider.addOrder() → CartProvider.clearSelectedItems()
OrdersScreen → hiển thị danh sách theo status
```

---

## ✅ Danh Sách Tính Năng Hoàn Thành

**Core Features:**
- [x] Trang chủ với danh sách sản phẩm
- [x] Chi tiết sản phẩm
- [x] Giỏ hàng với quản lý số lượng
- [x] Lưu giỏ hàng (local storage)
- [x] Thanh toán với thông tin giao hàng
- [x] Lịch sử đơn hàng

**Recent Updates (v1.1.0):**
- [x] MainScreen với BottomNavigationBar
- [x] Lớp Order và OrderProvider
- [x] Checkout screen cập nhật (TextField + RadioListTile)
- [x] Orders screen với 4 tab theo trạng thái
- [x] Xác thực địa chỉ bắt buộc
- [x] Dialog xác nhận đặt hàng thành công

---

## 🐛 Troubleshooting

### ❌ "Không thấy tab Đơn Mua"
**Giải pháp**: Kiểm tra `lib/main.dart` có `home: const MainScreen()` không
```dart
// ✅ Đúng
home: const MainScreen(),

// ❌ Sai
home: const HomeScreen(),
```

### ❌ "Đơn hàng không lưu được"
**Giải pháp**: Đảm bảo OrderProvider được thêm vào MultiProvider
```dart
ChangeNotifierProvider(create: (_) => OrderProvider()),
```

### ❌ "Ứng dụng chậm khi tải sản phẩm"
**Giải pháp**: 
- Kiểm tra kết nối mạng
- Xóa cache: `flutter clean && flutter pub get`
- Chạy lại: `flutter run`

---

## 📚 Tài Liệu Thêm

Xem chi tiết tại:
- 📄 [HUONG_DAN_CHECKOUT_ORDER.md](./HUONG_DAN_CHECKOUT_ORDER.md) - Hướng dẫn Checkout & Orders
- 📄 [CHECKOUT_ORDERS_IMPLEMENTATION.md](./CHECKOUT_ORDERS_IMPLEMENTATION.md) - Tài liệu kỹ thuật

---

## 👥 Tác Giả

**TH4 - Nhóm 7**
- Phát triển: Flutter & Dart
- API & Database: Firebase + REST API
- UI/UX: Material Design 3

---

## 📄 Giấy Phép

Dự án này không có giấy phép cụ thể. Dùng cho mục đích học tập.

---

## 🎯 Kế Hoạch Phát Triển

### v1.2.0 (Sắp Tới)
- [ ] Tích hợp thanh toán thực tế (Stripe, MoMo API)
- [ ] Lưu trữ đơn hàng lên Firebase
- [ ] Tracking đơn hàng real-time
- [ ] Đánh giá sản phẩm & bình luận
- [ ] Wishlist (danh sách yêu thích)
- [ ] Khuyến mãi & mã giảm giá

### v1.3.0
- [ ] Tài khoản người dùng & đăng nhập
- [ ] Địa chỉ giao hàng được lưu
- [ ] Lịch sử mua hàng
- [ ] Thông báo đơn hàng
- [ ] Chat support

---

**Phiên bản hiện tại**: v1.1.0 (Checkout & Orders)  
**Ngày cập nhật**: 18/03/2026  
**Trạng thái**: ✅ Siêu ổn định
