import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/students_model.dart';
import 'package:universal_io/io.dart' as universal_io;

class StudentsProvider extends BaseApi with ChangeNotifier {
  StudentsModel? _studentsModel;
  StudentsModel? get studentsModel => _studentsModel;
  final List<Student> _students = [];
  List<Student> get students => _students;
  final AuthController authController;
  StudentsProvider({required this.authController});

  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editStudentPath(id);
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
        _students.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }
  Future<void> getStudents() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.studentsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _studentsModel = StudentsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_studentsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addStudent(
      {required Map<String, dynamic> data,
      required Uint8List? fileBytes,
      String? filePath,
      String? fileName}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addStudentPath;
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
        _studentsModel = StudentsModel.fromJson(responseData);
        final newTeacher = Student.fromJson(data);
        _studentsModel?.student?.add(newTeacher);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }

  Future<void> editStudent({
    required int id,
    required Map<String, dynamic> data,
    required Uint8List? fileBytes,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editStudentPath(id);

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
        debugPrint('Berhasil edit data siswa');
        debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');
        _studentsModel = StudentsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal edit data siswa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit data siswa: $e');
    }
  }
}
