import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/evaluation/evaluations_detail_model.dart';
import 'package:si_pkl/models/admin/evaluation/evaluations_model.dart';
import 'package:si_pkl/models/admin/evaluation/evaluations_show_model.dart';
class EvaluationsProvider extends BaseApi with ChangeNotifier {
  EvaluationsModel? _evaluationsModel;
  EvaluationsModel? get evaluationsModel => _evaluationsModel;
  EvaluationsDetailModel? _evaluationsDetailModel;
  EvaluationsDetailModel? get evaluationsDetailModel => _evaluationsDetailModel;
  EvaluationsShowModel? _evaluationsShowModel;
  EvaluationsShowModel? get evaluationsShowModel => _evaluationsShowModel;
  final AuthController authController;
  EvaluationsProvider({required this.authController});

  Future<void> getEvaluations() async {
    final tokenUser = authController.authToken;
    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.evaluationsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _evaluationsModel = EvaluationsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_evaluationsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  Future<void> getEvaluationDetail(int id) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.penilaianDetailPath(id),
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _evaluationsDetailModel = EvaluationsDetailModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_evaluationsDetailModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  Future<void> getEvaluationShow(int id) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.penilaianShowPath(id),
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _evaluationsShowModel = EvaluationsShowModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_evaluationsShowModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
}
