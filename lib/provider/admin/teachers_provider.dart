import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/teachers_model.dart';
import 'package:universal_io/io.dart' as universal_io;

class TeachersProvider extends BaseApi with ChangeNotifier {
  TeachersModel? _teachersModel;
  TeachersModel? get teachersModel => _teachersModel;
  final List<Teacher> _teacher = [];
  List<Teacher> get teacher => _teacher;
  final AuthController authController;
  TeachersProvider({required this.authController});

  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.deleteTeacherPath(id);
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
        _teacher.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }

  Future<void> getTeachers() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.teachersPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _teachersModel = TeachersModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_teachersModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addTeacher(
      {required Map<String, dynamic> data,
      required Uint8List? fileBytes,
      String? filePath,
      String? fileName}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addTeacherPath;
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
        _teachersModel = TeachersModel.fromJson(responseData);
        final newTeacher = Teacher.fromJson(data);
        _teachersModel?.teachers?.add(newTeacher);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }

  Future<void> editTeacher({
    required int id,
    required Map<String, dynamic> data,
    required Uint8List? fileBytes,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editTeacherPath(id);

      // Jika ada fileBytes, gunakan MultipartRequest
      if (fileBytes != null && fileName != null) {
        final request = http.MultipartRequest(
            'POST', uri) // Ubah method ke POST jika server mengharapkan POST
          ..headers.addAll({
            'Authorization': 'Bearer $tokenUser',
            'Accept': 'application/json',
          });
        data.forEach((key, value) {
          debugPrint('Key: $key, Value: $value');
          if (value != null && value.toString().isNotEmpty) {
            request.fields[key] = value.toString();
          }
        });
        request.fields['_method'] = 'PUT';
        request.files.add(
          http.MultipartFile.fromBytes(
            'foto',
            fileBytes,
            filename: fileName,
            contentType: MediaType('image', fileName.split('.').last),
          ),
          
        );
        final response = await request.send();
        debugPrint('edit teacher dengan gambar');
        final responseBody = await response.stream.bytesToString();
        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: $responseBody');

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('Berhasil edit teacher dengan gambar');
          final responseData = json.decode(responseBody);
          _teachersModel = TeachersModel.fromJson(responseData);
          notifyListeners();
        } else {
          debugPrint('Gagal edit teacher: ${response.statusCode}');
        }
      } else {
        // Jika tidak ada file, gunakan JSON POST
        final response = await http.put(
          // Atau ubah ke http.put jika server mengharapkan PUT
          uri,
          headers: {
            'Authorization': 'Bearer $tokenUser',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        debugPrint('Response Status Code: ${response.statusCode}');
        final responseBody = response.body;
        debugPrint('Response Body: $responseBody');

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('Berhasil edit teacher tanpa gambar');
          final responseData = json.decode(responseBody);
          _teachersModel = TeachersModel.fromJson(responseData);
          notifyListeners();
        } else {
          debugPrint('Gagal edit teacher: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error edit teacher: $e');
    }
  }
}
