import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/perusahaan/profile_perusahaan_model.dart';

class ProfilePerusahaanProvider extends BaseApi with ChangeNotifier {
  ProfilePerusahaanModel? _profilePerusahaanModel;
  ProfilePerusahaanModel? get profilePerusahaanModel => _profilePerusahaanModel;
  final AuthController authController;

  ProfilePerusahaanProvider({required this.authController});

  Future<void> getProfilePerusahaan() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.perusahaanProfilePath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _profilePerusahaanModel = ProfilePerusahaanModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
        debugPrint('Request: $response');
        debugPrint('Request: ${response.request}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }
}
