import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/siswa/profile_model.dart';
import 'package:universal_io/io.dart' as universal_io;

class ProfileProvider extends BaseApi with ChangeNotifier {
  final List<ProfileModel> _siswa = [];
  List<ProfileModel> get siswa => _siswa;
  ProfileModel? _currentSiswa;
  ProfileModel? get currentSiswa => _currentSiswa;
  final AuthController authController;

  ProfileProvider({required this.authController});
  void clearProfileData() {
    _siswa.clear();
    _currentSiswa = null;
    notifyListeners();
  }

  Future<void> getProfileSiswa() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.profileSiswaPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentSiswa = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }

  Future<void> getCurrentUser() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.siswaPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentSiswa = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }

  Future<void> createProfile(
      {required Map<String, dynamic> data,
      required Uint8List? fileBytes,
      String? filePath,
      String? fileName}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addProfileStudentPath;
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          ...super.getHeaders(tokenUser),
        });
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      if (fileBytes != null && fileName != null) {
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto',
              fileBytes,
              filename: fileName,
              contentType: MediaType('image', fileName.split('.').last),
            ),
          );
        } else if (universal_io.Platform.isAndroid ||
            universal_io.Platform.isIOS) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto',
              filePath!,
              filename: fileName,
              contentType: MediaType('image', fileName.split('.').last),
            ),
          );
        }
      }

      debugPrint('Request Body: ${jsonEncode(data)}');
      final response = await request.send();
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil submit logbook');
        final responseData = json.decode(responseBody);
        _currentSiswa = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }

  Future<void> updateStudentProfile({
    required int id,
    required Map<String, dynamic> data,
    required Uint8List? fileBytes,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editStudentProfilePath(id);

      final request = http.MultipartRequest('POST', uri)
        ..fields['_method'] =
            'PUT' // trik jika backend tidak support PUT multipart
        ..headers.addAll({
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
        });

      // Kirim semua field, kalau null jadikan string kosong
      data.forEach((key, value) {
        request.fields[key] = value?.toString() ?? "";
        debugPrint('Adding field: $key = ${request.fields[key]}');
      });

      // Tambah file jika ada
      if (fileBytes != null && fileName != null) {
        final allowedExtensions = ['jpg', 'jpeg', 'png'];
        final fileExtension = fileName.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(fileExtension)) {
          throw Exception(
              'Format gambar tidak didukung. Gunakan JPG, JPEG, atau PNG.');
        }

        if (fileBytes.length > 2 * 1024 * 1024) {
          throw Exception('Ukuran gambar terlalu besar. Maksimal 2MB.');
        }

        request.files.add(
          http.MultipartFile.fromBytes(
            'foto',
            fileBytes,
            filename: fileName,
            contentType: MediaType('image', fileExtension),
          ),
        );
      }

      debugPrint('Update Profile Request Data: $data');
      debugPrint('File included: ${fileBytes != null}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(responseBody);

        if (responseData['profile'] != null) {
          _currentSiswa = ProfileModel.fromJson(responseData['profile']);
        }

        debugPrint('Berhasil update profile siswa');
        notifyListeners();
      } else {
        final responseData = json.decode(responseBody);
        throw Exception(responseData['message'] ?? 'Gagal update profile');
      }
    } catch (e) {
      debugPrint('Error update profile: $e');
      rethrow;
    }
  }

}
