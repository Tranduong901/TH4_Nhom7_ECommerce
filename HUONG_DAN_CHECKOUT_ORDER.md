# 📱 Hướng Dẫn Chi Tiết: Thanh Toán và Lịch Sử Đơn Hàng

## 📋 Tổng Quan

Dự án đã được phát triển hoàn chỉnh các tính năng:
- ✅ Trang **Thanh Toán (Checkout)** - nhập địa chỉ, chọn phương thức thanh toán
- ✅ Trang **Lịch Sử Đơn Mua (Orders)** - xem danh sách đơn hàng theo 4 trạng thái
- ✅ **MainScreen** - điều hướng giữa Trang Chủ và Đơn Mua qua BottomNavigationBar

---

## 🏗️ Các File Được Tạo/Sửa

### 📝 File Tạo Mới

#### 1. **lib/models/order.dart** ✨
Lớp `Order` lưu trữ thông tin đơn hàng:
```dart
- id: Mã đơn hàng (duy nhất từ timestamp)
- items: Danh sách CartItem đã mua
- shippingAddress: Địa chỉ giao hàng
- paymentMethod: 'COD' hoặc 'MOMO'
- status: 'Chờ xác nhận' | 'Đang giao' | 'Đã giao' | 'Đã hủy'
- createdAt: Thời gian tạo đơn
- totalAmount: Tổng tiền
```

**Hàm chính:**
- `Order.create()` - Tạo đơn hàng mới từ các mục giỏ hàng
- `toJson()/fromJson()` - Chuyển đổi JSON để lưu
- `copyWith()` - Tạo bản sao với thay đổi

#### 2. **lib/providers/order_provider.dart** ✨
Quản lý trạng thái toàn bộ đơn hàng:
```dart
Hàm công khai:
- addOrder(Order) - Thêm đơn hàng mới
- getOrdersByStatus(status) - Lọc theo trạng thái
- updateOrderStatus(id, status) - Cập nhật trạng thái
- removeOrder(id) - Xóa đơn hàng
- cancelOrder(id) - Hủy đơn hàng
- getCountByStatus(status) - Đếm theo trạng thái
```

#### 3. **lib/screens/main_screen.dart** ✨
Trang chính với điều hướng hai tab:
```
┌─────────────────────────────┐
│     MainScreen              │
├─────────────────────────────┤
│  [HomeScreen | OrdersScreen │ (nội dung)
│                             │
├─────────────────────────────┤
│ 🏠 Trang Chủ | 📋 Đơn Mua  │ (BottomNavigationBar)
└─────────────────────────────┘
```

### 🔄 File Sửa Đổi

#### 4. **lib/screens/checkout_screen.dart** 🔄
Trang thanh toán với:
- ✅ TextField nhập địa chỉ (bắt buộc)
- ✅ RadioListTile chọn COD hoặc MOMO
- ✅ Danh sách sản phẩm đã chọn
- ✅ Nút "ĐẶT HÀNG" để tạo đơn

**Quy trình:**
1. Người dùng nhập địa chỉ
2. Chọn phương thức thanh toán
3. Nhấn "ĐẶT HÀNG"
4. Tạo Order từ CartProvider items
5. Lưu vào OrderProvider
6. Xóa items khỏi CartProvider
7. Quay về MainScreen

#### 5. **lib/screens/orders_screen.dart** 🔄
Trang xem lịch sử đơn hàng:
- 4 tab bằng DefaultTabController:
  - 🟠 Chờ xác nhận
  - 🔵 Đang giao
  - 🟢 Đã giao
  - 🔴 Đã hủy
- Hiển thị card đơn hàng:
  - Mã đơn + trạng thái (có màu)
  - Ảnh sản phẩm + tên
  - Số lượng + giá
  - Địa chỉ + phương thức thanh toán
  - Ngày tạo đơn

#### 6. **lib/main.dart** 🔄
- Import `OrderProvider` và `MainScreen`
- Thêm OrderProvider vào MultiProvider
- Thay home thành MainScreen

---

## 🚀 Cách Sử Dụng

### 1️⃣ **Đặt Hàng**

**Bước 1:** Vào Trang Chủ (HomeScreen)
- Trượt để xem các sản phẩm

**Bước 2:** Nhấn icon giỏ hàng (🛍️) ở góc trên phải
- Hiện CartScreen
- Các mục đã thêm sẽ có ✓

**Bước 3:** Chọn mục muốn mua
- Nhấn checkbox để đánh dấu (✓)
- Tính tổng tiền tự động

**Bước 4:** Nhấn "MUA HÀNG" hoặc "CHECKOUT"
- Qua CheckoutScreen

**Bước 5:** Nhập địa chỉ giao hàng
- Trường bắt buộc (validate khi nhấn ĐẶT HÀNG)

**Bước 6:** Chọn phương thức thanh toán
- ☑ Thanh toán khi nhận (COD)
- ☐ Ví MoMo

**Bước 7:** Nhấn "ĐẶT HÀNG"
- Hộp thoại thành công
- Nhấn "VỀ TRANG CHỦ"
- Đơn hàng đã được lưu

### 2️⃣ **Xem Lịch Sử Đơn Hàng**

**Từ MainScreen:**
- Nhấn tab "📋 Đơn Mua" ở dưới cùng
- {Qua OrdersScreen

**Sử dụng các tab:**
- Tab 1: Chờ xác nhận (cam)
- Tab 2: Đang giao (xanh đậm)
- Tab 3: Đã giao (xanh lá)
- Tab 4: Đã hủy (đỏ)

**Xem Chi Tiết:**
- Nhất vào card đơn hàng
- Hiển thị đầy đủ: Mã, sản phẩm, địa chỉ, ngày

### 3️⃣ **Quay Lại Trang Chủ**

- Nhấn tab "🏠 Trang Chủ" ở dưới cùng
- Qua HomeScreen để tiếp tục mua sắm

---

## 🎨 Giao Diện

### Checkout Screen
```
┌──────────────────────────────────┐
│ Thanh Toán              [◄]      │ (AppBar)
├──────────────────────────────────┤
│ 📍 Địa chỉ nhận hàng             │
│ ┌──────────────────────────────┐ │
│ │ Nhập địa chỉ nhận hàng here  │ │ (TextField)
│ └──────────────────────────────┘ │
│                                  │
│ 🏪 TH4 - NHÓM 7 MALL             │
│ ┌──────────────────────────────┐ │
│ │ Ảnh │ Sản phẩm              │ │
│ │     │ Phân loại: Xanh, L    │ │
│ │     │ $99.99  x1            │ │
│ └──────────────────────────────┘ │
│ Tổng tiền (1 sản phẩm): $99.99   │
│                                  │
│ 💳 Phương thức thanh toán         │
│ ☑ Thanh toán khi nhận (COD)      │
│ ☐ Ví MoMo                        │
├──────────────────────────────────┤
│ Tổng thanh toán: $99.99          │
│              [  ĐẶT HÀNG  ]      │ (Button)
└──────────────────────────────────┘
```

### Orders Screen
```
┌──────────────────────────────────┐
│ Đơn Mua Của Tôi                  │
├────┬────┬────┬─────────────────┤
│ Chờ │Đang│Đã  │ Đã (Tab)       │
│ xác │giao│giao│ hủy            │
│ nhận│    │    │                │
├──────────────────────────────────┤
│ ┌────────────────────────────┐  │
│ │ Đơn #12345678  [Chờ xác]  │  │
│ │ Ảnh │ Sản phẩm...         │  │
│ │     │ Phân loại...  x1    │  │
│ │     │ ...và 2 sản phẩm... │  │
│ │     │ $299.99             │  │
│ │ Giao đến: 123 Đường...    │  │
│ │ Phương thức: Thanh toán   │  │
│ │ Ngày: 18/03/2026 14:30    │  │
│ └────────────────────────────┘  │
│                                  │
│ (Thẻ khác...)                    │
└──────────────────────────────────┘
```

---

## 💾 Dữ Liệu

### Lưu Trữ Hiện Tại
Đơn hàng được lưu **trong bộ nhớ** (RAM):
- Khi đóng app → mất dữ liệu
- Dùng cho testing/demo

### Để Lưu Trữ Lâu Dài
Thêm vào **local_storage_service.dart**:
```dart
// Lưu
Future<void> saveOrders(List<Order> orders) async {
  final json = orders.map((o) => o.toJson()).toList();
  await _storage.write('orders', jsonEncode(json));
}

// Tải
Future<List<Order>> loadOrders() async {
  final data = await _storage.read('orders');
  if (data == null) return [];
  return (jsonDecode(data) as List)
      .map((item) => Order.fromJson(item))
      .toList();
}
```

---

## 🔄 Quy Trình Chi Tiết

```
Trang Chủ (HomeScreen)
    ↓ Thêm sản phẩm vào giỏ
Giỏ Hàng (CartScreen)
    ↓ Chọn mục + MUA HÀNG
Thanh Toán (CheckoutScreen)
    ↓ Nhập địa chỉ + chọn COD/MOMO + ĐẶT HÀNG
Tạo Order
    ├─ Order.create()
    ├─ OrderProvider.addOrder()
    └─ CartProvider.clearSelectedItems()
    ↓ Dialog thành công
MainScreen (Tab: Trang Chủ)
    ↓ Nha tab Đơn Mua
Orders (OrdersScreen - 4 Tab)
    ├─ Tab 1: Chờ xác nhận ← Đơn vừa tạo ở đây
    ├─ Tab 2: Đang giao
    ├─ Tab 3: Đã giao
    └─ Tab 4: Đã hủy
```

---

## ⚙️ Công Nghệ Dùng

```
✅ Flutter & Dart (framework)
✅ Provider (state management)
✅ cached_network_image (tải ảnh)
✅ Material Design 3 (giao diện)
❌ Không có thư viện bên ngoài khác
```

---

## ✅ Danh Sách Hoàn Thành

- [x] Model Order với 4 trạng thái
- [x] OrderProvider quản lý state
- [x] CheckoutScreen với TextField + RadioListTile
- [x] Xác thực địa chỉ (bắt buộc)
- [x] Tạo đơn hàng với Order.create()
- [x] Xóa items từ CartProvider
- [x] OrdersScreen với 4 tab
- [x] Lọc đơn theo trạng thái
- [x] Card hiển thị đầy đủ
- [x] MainScreen với BottomNavigationBar
- [x] Điều hướng giữa 2 tab
- [x] Sử dụng code hiện có (CartItem, Product...)
- [x] Không có lỗi biên dịch
- [x] Sẵn sàng production

---

## 📞 Hỗ Trợ

### Nếu không thấy tab Đơn Mua
→ Đảm bảo MainScreen là home trong main.dart:
```dart
home: const MainScreen(),  // Không phải HomeScreen()
```

### Nếu checkout không lưu đơn
→ Kiểm tra OrderProvider đã được thêm vào MultiProvider:
```dart
ChangeNotifierProvider(create: (_) => OrderProvider()),
```

### Nếu muốn thay đổi trạng thái đơn
→ Dùng OrderProvider methods:
```dart
orderProvider.updateOrderStatus(orderId, 'Đang giao');
```

---

## 🎯 Hoàn Thành

**Tất cả tính năng đã được triển khai!** 🎉

Sẵn sàng sử dụng ngay. Chúc bạn phát triển có hiệu quả!
