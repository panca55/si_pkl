import 'dart:convert';
import 'dart:io' as universal_io;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/instruktur/profile_model.dart';

class ProfileInstrukturProvider extends BaseApi with ChangeNotifier {
  ProfileModel? _currentInstruktur;
  ProfileModel? get currentInstruktur => _currentInstruktur;
  final AuthController authController;

  ProfileInstrukturProvider({required this.authController});

  Future<void> getProfileguru() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.instrukturProfilePath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentInstruktur = ProfileModel.fromJson(responseData);
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
      final uri = super.addProfileInstrukturPath;
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
        _currentInstruktur = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
  Future<void> editProfileInstruktur({
    required int id,
    required Map<String, dynamic> data,
    Uint8List? fileBytes,
    String? filePath,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      debugPrint('Editing teacher profile with ID: $id');
      final uri = super.editCorporateProfilePath(id);
      debugPrint('Edit URI: $uri');

      http.Response response;

      if (fileBytes != null && fileName != null) {
        // --- Gunakan MultipartRequest kalau ada file ---
        debugPrint('Menggunakan MultipartRequest (dengan foto)');

        final request = http.MultipartRequest('PUT', uri)
          ..headers.addAll({
            'Authorization': 'Bearer $tokenUser',
            'Accept': 'application/json',
          });

        // Tambah fields
        data.forEach((key, value) {
          if (value != null && value.toString().trim().isNotEmpty) {
            request.fields[key] = value.toString().trim();
            debugPrint('Adding field: $key = ${value.toString().trim()}');
          } else {
            debugPrint('Skipping empty field: $key = $value');
          }
        });

        // Tambah file
        final allowedExtensions = ['jpg', 'jpeg', 'png'];
        final fileExtension = fileName.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(fileExtension)) {
          throw Exception('Format gambar tidak didukung');
        }
        if (fileBytes.length > 2 * 1024 * 1024) {
          throw Exception('Ukuran gambar terlalu besar, maksimal 2MB');
        }

        request.files.add(
          http.MultipartFile.fromBytes(
            'foto',
            fileBytes,
            filename: fileName,
            contentType: MediaType('image', fileExtension),
          ),
        );

        final streamedResponse = await request.send();
        final responseBody = await streamedResponse.stream.bytesToString();
        response = http.Response(responseBody, streamedResponse.statusCode);
      } else {
        // --- Gunakan JSON biasa kalau tanpa file ---
        debugPrint('Menggunakan http.put (tanpa foto)');
        response = await http.put(
          uri,
          headers: {
            'Authorization': 'Bearer $tokenUser',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );
      }

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        _currentInstruktur = ProfileModel.fromJson(
            responseData['data'] ?? responseData);
        debugPrint('Berhasil edit profile guru');
        notifyListeners();
      } else {
        throw Exception('Gagal update profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit profile guru: $e');
      rethrow;
    }
  }
}