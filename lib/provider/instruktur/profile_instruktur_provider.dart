import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/instruktur/profile_model.dart';

class ProfileInstrukturProvider extends BaseApi with ChangeNotifier {
  ProfileModel? _currentInstruktur;
  ProfileModel? get currentInstruktur => _currentInstruktur;
  final AuthController authController;

  ProfileInstrukturProvider({required this.authController});

  Future<void> getProfileguru() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '501|OzL9PoHIs30Npe6CfbJGHvgIyciA2BNgNRr47Ck712239be1';
    try {
      http.Response response = await http.get(
        super.instrukturProfilePath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentInstruktur = ProfileModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }
}