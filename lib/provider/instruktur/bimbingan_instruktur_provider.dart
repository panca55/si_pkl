import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/instruktur/bimbingan/bimbingan_siswa_model.dart';

class BimbinganInstrukturProvider extends BaseApi with ChangeNotifier {
  BimbinganSiswaModel? _bimbinganSiswaModel;
  BimbinganSiswaModel? get bimbinganSiswaModel => _bimbinganSiswaModel;
  final AuthController authController;
  BimbinganInstrukturProvider({required this.authController});

  Future<void> getBimbingan() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '501|OzL9PoHIs30Npe6CfbJGHvgIyciA2BNgNRr47Ck712239be1';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.bimbinganInstrukturPath,
        headers: super.getHeaders(tokenUser),
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _bimbinganSiswaModel = BimbinganSiswaModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_bimbinganSiswaModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  
}
