import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/perusahaan/bursa_kerja_model.dart';

class BursaKerjaProvider extends BaseApi with ChangeNotifier {
  BursaKerjaModel? _bursaKerjaModel;
  BursaKerjaModel? get bursaKerjaModel => _bursaKerjaModel;
  final AuthController authController;
  BursaKerjaProvider({required this.authController});

  Future<void> getBursaKerja() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.bursaKerjaPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _bursaKerjaModel = BursaKerjaModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_bursaKerjaModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
}
