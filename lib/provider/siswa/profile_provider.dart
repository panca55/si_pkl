import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/siswa/profile_model.dart';

class ProfileProvider extends BaseApi with ChangeNotifier {
  final List<ProfileModel> _siswa = [];
  List<ProfileModel> get siswa => _siswa;
  ProfileModel? _currentSiswa;
  ProfileModel? get currentSiswa => _currentSiswa;
  final AuthController authController;

  ProfileProvider({required this.authController});

  Future<void> getProfileSiswa() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.profileSiswaPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentSiswa = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }

  Future<void> getCurrentUser() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.siswaPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentSiswa = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }
}
