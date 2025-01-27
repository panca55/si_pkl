import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/profile_model.dart';

class ProfileGuruProvider extends BaseApi with ChangeNotifier {
  ProfileModel? _currentGuru;
  ProfileModel? get currentguru => _currentGuru;
  final AuthController authController;

  ProfileGuruProvider({required this.authController});

  Future<void> getProfileguru() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.guruProfilePath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentGuru = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }
}
