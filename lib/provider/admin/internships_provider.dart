import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/internships_model.dart';

class InternshipsProvider extends BaseApi with ChangeNotifier {
  InternshipsModel? _internshipsModel;
  InternshipsModel? get internshipsModel => _internshipsModel;
  final AuthController authController;
  InternshipsProvider({required this.authController});

  Future<void> getInternships() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.internshipsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _internshipsModel = InternshipsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_internshipsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

}
