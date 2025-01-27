import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/bimbingan/bimbingan_siswa_model.dart';

class BimbinganSiswaProvider extends BaseApi with ChangeNotifier {
  final List<Internship> _bimbinganSiswaModel = [];
  List<Internship> get bimbinganSiswaModel => _bimbinganSiswaModel;
  final AuthController authController;
  BimbinganSiswaProvider({required this.authController});

  Future<void> getBimbingan() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.bimbinganPath,
        headers: super.getHeaders(tokenUser),
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);

        if (responseData != null && responseData['internships'] != null) {
          // Parsing data internships
          final List<Internship> internships = (responseData['internships']
                  as List)
              .map((item) => Internship.fromJson(item as Map<String, dynamic>))
              .toList();

          _bimbinganSiswaModel
            ..clear()
            ..addAll(internships);

          notifyListeners();
          debugPrint('Data berhasil di-parse: $_bimbinganSiswaModel');
          debugPrint('respon data: $responseData');
        } else {
          debugPrint('Response body tidak valid: ${response.body}');
        }
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  
}
