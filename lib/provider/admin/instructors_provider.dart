import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/instructors_model.dart';

class InstructorsProvider extends BaseApi with ChangeNotifier {
  InstructorsModel? _instructorsModel;
  InstructorsModel? get instructorsModel => _instructorsModel;
  final List<Instructor> _instructor = [];
  List<Instructor> get instructoror => _instructor;
  final AuthController authController;
  InstructorsProvider({required this.authController});

  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editInstrukturPath(id);
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
        _instructor.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }

  Future<void> getInstructors() async {
    final tokenUser = authController.authToken;
    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.instructorsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _instructorsModel = InstructorsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_instructorsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addInstruktur(
      {required Map<String, dynamic> data,
      required Uint8List? fileBytes,
      String? filePath,
      String? fileName}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addInstrukturPath;

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
        debugPrint('Berhasil menambah data instruktur');
        final responseData = json.decode(responseBody);
        _instructorsModel = InstructorsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal menambah data instruktur: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menambah data instruktur: $e');
    }
  }

  Future<void> editInstructor({
    required int id,
    required Map<String, dynamic> data,
    required Uint8List? fileBytes,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editInstrukturPath(id);

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
        final responseData = json.decode(responseBody);
        debugPrint('Berhasil edit data instruktur');
        debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');
        _instructorsModel = InstructorsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal edit data instruktur: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit data instruktur: $e');
    }
  }
}
