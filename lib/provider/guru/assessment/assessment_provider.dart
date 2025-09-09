import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/assessment/assessments_model.dart';

class AssessmentProvider extends BaseApi with ChangeNotifier {
  AssessmentsModel? _assessmentsModel;
  AssessmentsModel? get assessmentsModel => _assessmentsModel;
  final List<Assessment> _assessmentsList = [];
  List<Assessment> get assessmentList => _assessmentsList;
  final AuthController authController;
  AssessmentProvider({required this.authController});

  Future<void> getAssessments() async {
    // final tokenUser = authController.authToken;
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
    try {
      http.Response response = await http.get(
        super.assessmentPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        final assessment = AssessmentsModel.fromJson(responseData);
        _assessmentsModel = assessment;
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  
  Future<void> submitAssessment(
      {required int internshipId,
      required String nama,
      required int softskill,
      required int norma,
      required int teknis,
      required int pemahaman,
      String? catatan,
      required int score,
      String? deskripsiSoftskill,
      String? deskripsiNorma,
      String? deskripsiTeknis,
      String? deskripsiPemahaman,
      String? deskripsiCatatan,
      }) async {
    final tokenUser = authController.authToken;
    // const tokenUser = '340|PtK7ZVsJUxGaO9i0e96koACk8m07CqZ1eMm4aqg496e10889';
    try {
      final uri = super.postAssessmentPath(internshipId);
      final requestBody = {
        'internship_id': internshipId,
        'nama': nama,
        'softskill': softskill,
        'norma': norma,
        'teknis': teknis,
        'pemahaman': pemahaman,
        'catatan': catatan,
        'score': score,
        'deskripsi_softskill': deskripsiSoftskill,
        'deskripsi_norma': deskripsiNorma,
        'deskripsi_teknis': deskripsiTeknis,
        'deskripsi_pemahaman': deskripsiPemahaman,
        'deskripsi_catatan': deskripsiCatatan,
      }..removeWhere((key, value) => value == null);
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
        final newAssessment = Assessment(internshipId: internshipId, nama: nama, norma: norma, softSkill: softskill, teknis: teknis, pemahaman: pemahaman, catatan: catatan, score: score, deskripsiNorma: deskripsiNorma, deskripsiCatatan: deskripsiCatatan, deskripsiPemahaman: deskripsiPemahaman, deskripsiSoftSkill: deskripsiSoftskill, deskripsiTeknis: deskripsiTeknis);
        _assessmentsList.add(newAssessment);
        notifyListeners();
        debugPrint('Asessment: $newAssessment');
      } else {
        debugPrint('Gagal submit Asessment: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitAssessment: $e');
    }
  }
}
