import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

class CloudinaryService {
  final String cloudName = "dyv7ykubp";
  final String apiKey = "943278229922559";
  final String uploadPreset = "smart_note_preset";

  Future<String?> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();

    // 1. Chọn ảnh từ thư viện
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image == null) return null;

    // 2. Chuẩn bị request upload lên Cloudinary
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url);

    request.fields['upload_preset'] = uploadPreset;
    request.fields['api_key'] = apiKey;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
      ));
    }

    // 3. Thực hiện gửi và lấy URL trả về
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return jsonMap['secure_url']; // Link ảnh dùng để lưu vào Database
      } else {
        debugPrint("Cloudinary Upload Error: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
      return null;
    }
  }
}
