import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/departments_model.dart';

class DepartmentsProvider extends BaseApi with ChangeNotifier {
  DepartmentsModel? _departmentsModel;
  DepartmentsModel? get departmentsModel => _departmentsModel;
  final List<Department> _listDepartment = [];
  List<Department>? get listDepartment => _listDepartment;
  final AuthController authController;
  DepartmentsProvider({required this.authController});
  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.deleteDepartmentPath(id);
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
        _listDepartment.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }
  Future<void> getDepartments() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.departmentsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _departmentsModel = DepartmentsModel.fromJson(responseData);
        _listDepartment
          ..clear()
          ..addAll(_departmentsModel?.department?.toList() ?? []);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_departmentsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addDepartment({
    required String nama,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addDepartmentPath;
      final requestBody = {"nama": nama};
      final request = http.Request('POST', uri)
        ..headers.addAll({
          ...super.getHeaders(tokenUser),
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode(requestBody);
      debugPrint('Request Body: ${jsonEncode(requestBody)}');
      final response = await request.send();
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(responseBody);

        // Validasi bahwa validatedData tersedia
        final newDepartment = Department.fromJson(responseData['nama']);
        _listDepartment.add(newDepartment);
        notifyListeners();
        debugPrint('Berhasil menambahkan department: $newDepartment');

        debugPrint('Response tidak mengandung validatedData.');
        throw Exception('ValidatedData is missing from response.');
      } else {
        debugPrint('Gagal menambahkan department: ${response.statusCode}');
        throw Exception('Failed to add department');
      }
    } catch (e) {
      debugPrint('Error addDepartment: $e');
    }
  }
  Future<void> editDepartment({
    required int id,
    required String data,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final requestBody = {"nama": data};
      final uri = super.editDepartmentPath(id);
      // Menyiapkan request dengan 'Content-Type' application/json
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody), // Kirim data sebagai JSON
      );

      // Mengecek respon dari server
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = response.body;
      debugPrint('Response Body: $responseBody');
      debugPrint('Data sebelum dikirim: ${jsonEncode(requestBody)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(responseBody);
        debugPrint('Berhasil edit data siswa');
        debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');
        _departmentsModel = DepartmentsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal edit data siswa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit data siswa: $e');
    }
  }
}
