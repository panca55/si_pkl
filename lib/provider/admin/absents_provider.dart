import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/absents_model.dart';
import 'package:si_pkl/models/admin/corporations_model.dart';
import 'package:si_pkl/models/admin/departments_model.dart';

class AbsentsProvider extends BaseApi with ChangeNotifier {
  AbsentsModel? _absentsModel;
  AbsentsModel? get absentsModel => _absentsModel;
  final AuthController authController;
  AbsentsProvider({required this.authController});

  Future<void> getCorporations() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.absentsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _absentsModel = AbsentsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_absentsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
}
