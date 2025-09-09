import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/assessment/assessments_show_model.dart';

class AssessmentShowProvider extends BaseApi with ChangeNotifier {
  AssessmentsShowModel? _assessmentsShowModel;
  AssessmentsShowModel? get assessmentsModel => _assessmentsShowModel;
  final AuthController authController;
  AssessmentShowProvider({required this.authController});

  Future<void> getShowAssessments(int id) async {
    final tokenUser = authController.authToken;
    // const tokenUser = '340|PtK7ZVsJUxGaO9i0e96koACk8m07CqZ1eMm4aqg496e10889';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
    try {
      http.Response response = await http.get(
        super.assessmentShowPath(id),
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        final assessment = AssessmentsShowModel.fromJson(responseData);
        _assessmentsShowModel = assessment;
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
}
