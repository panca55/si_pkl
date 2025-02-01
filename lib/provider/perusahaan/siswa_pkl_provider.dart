import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/perusahaan/siswa_pkl_model.dart';

class SiswaPklProvider extends BaseApi with ChangeNotifier {
  SiswaPklModel? _siswaPklModel;
  SiswaPklModel? get siswaPklModel => _siswaPklModel;
  final AuthController authController;
  SiswaPklProvider({required this.authController});

  Future<void> getSiswaPkl() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.siswaPklPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _siswaPklModel = SiswaPklModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_siswaPklModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
}
