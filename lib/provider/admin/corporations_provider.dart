import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/corporations_model.dart';

class CorporationsProvider extends BaseApi with ChangeNotifier {
  CorporationsModel? _corporationsModel;
  CorporationsModel? get corporationsModel => _corporationsModel;
  final List<Corporations> _corporation = [];
  List<Corporations> get corporation => _corporation;
  final AuthController authController;
  CorporationsProvider({required this.authController});

  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.deleteCorporatePath(id);
      // Menyiapkan request dengan 'Content-Type' application/json
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // Mengecek respon dari server
      debugPrint('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil menghapus data user:');
        _corporation.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }

  Future<void> getCorporations() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.corporationsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _corporationsModel = CorporationsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_corporationsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addCorporate(
      {required Map<String, dynamic> data,
      required Uint8List? fileBytes,
      String? filePath,
      String? fileName}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addCorporatePath;

      // Mengecek jika fileBytes ada dan bukan null
      if (fileBytes != null) {
        // Mengecek apakah file adalah gambar dengan ekstensi yang diterima
        final allowedExtensions = ['jpg', 'jpeg', 'png'];
        final fileExtension = fileName?.split('.').last.toLowerCase();

        if (fileExtension != null &&
            !allowedExtensions.contains(fileExtension)) {
          debugPrint('Format gambar tidak didukung');
          throw Exception('Format gambar tidak didukung');
        }

        // Membatasi ukuran file jika lebih dari 2MB
        if (fileBytes.length > 2 * 1024 * 1024) {
          debugPrint('Ukuran gambar terlalu besar, maksimal 2MB');
          throw Exception('Ukuran gambar terlalu besar, maksimal 2MB');
        }

        // Mengonversi foto menjadi base64
        String base64Image = base64Encode(fileBytes);
        data['foto'] = base64Image;
      }

      // Menyiapkan request dengan 'Content-Type' application/json
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data), // Kirim data sebagai JSON
      );

      // Mengecek respon dari server
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = response.body;
      debugPrint('Response Body: $responseBody');
      debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil menambah data corporate');
        final responseData = json.decode(responseBody);
        Corporations newCorp =
            Corporations.fromJson(responseData['corporations']);
        _corporation.add(newCorp);
        notifyListeners();
      } else {
        debugPrint('Gagal menambah data corporate: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menambah data corporate: $e');
    }
  }

  Future<void> editCorporate({
    required int id,
    required Map<String, dynamic> data,
    required Uint8List? fileBytes,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editCorporatePath(id);

      if (fileBytes != null) {
        // validations
        final allowedExtensions = ['jpg', 'jpeg', 'png'];
        final fileExtension = fileName?.split('.').last.toLowerCase();

        if (fileExtension != null &&
            !allowedExtensions.contains(fileExtension)) {
          debugPrint('Format gambar tidak didukung');
          throw Exception('Format gambar tidak didukung');
        }

        if (fileBytes.length > 2 * 1024 * 1024) {
          debugPrint('Ukuran gambar terlalu besar, maksimal 2MB');
          throw Exception('Ukuran gambar terlalu besar, maksimal 2MB');
        }

        var request = http.MultipartRequest('POST', uri);
        request.headers.addAll({
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
        });
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        request.fields['_method'] = 'PUT';
        request.files.add(await http.MultipartFile.fromBytes('foto', fileBytes,
            filename: fileName));
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        final responseBody = response.body;
        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: $responseBody');
        debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = json.decode(responseBody);
          Corporations updatedCorp =
              Corporations.fromJson(responseData['corporations']);
          int index = _corporation.indexWhere((c) => c.id == id);
          if (index != -1) {
            _corporation[index] = updatedCorp;
          }
          notifyListeners();
          debugPrint('Berhasil edit data corporate');
        } else {
          debugPrint('Gagal edit data corporate: ${response.statusCode}');
        }
      } else {
        data['_method'] = 'PUT';
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $tokenUser',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );
        final responseBody = response.body;
        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: $responseBody');
        debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = json.decode(responseBody);
          Corporations updatedCorp =
              Corporations.fromJson(responseData['corporations']);
          int index = _corporation.indexWhere((c) => c.id == id);
          if (index != -1) {
            _corporation[index] = updatedCorp;
          }
          notifyListeners();
          debugPrint('Berhasil edit data corporate');
        } else {
          debugPrint('Gagal edit data corporate: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error edit data corporate: $e');
    }
  }
}
