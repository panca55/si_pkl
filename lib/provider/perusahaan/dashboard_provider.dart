import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/perusahaan/dashboard_model.dart';

class DashboardProvider extends BaseApi with ChangeNotifier {
  DashboardModel? _dashboardModel;
  DashboardModel? get dashboardModel => _dashboardModel;
  final AuthController authController;
  DashboardProvider({required this.authController});

  Future<void> getDashboardData() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '53|dCDZlC9eycak7o5HRqzOBnIaBXuLAx5eJyHJwfSPec286224';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.dashboardPerusahaanPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _dashboardModel = DashboardModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_dashboardModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> submitInstruktur({
    required int studentId,
    required int instructorId,
  }) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '53|dCDZlC9eycak7o5HRqzOBnIaBXuLAx5eJyHJwfSPec286224';
    try {
      final uri = super.postSubmitInstrukturPath;
      final requestBody = {
        'student_id': studentId,
        'instructor_id': instructorId,
      };
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
        debugPrint('Berhasil submit logbook');
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
}
