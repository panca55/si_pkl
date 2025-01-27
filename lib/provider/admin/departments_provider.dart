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

  Future<void> getDepartments() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';

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
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';
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
}
