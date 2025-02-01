import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/instruktur/sertifikat/sertifikat_model.dart';

class SertifikatProvider extends BaseApi with ChangeNotifier {
  SertifikatModel? _sertifikatModel;
  SertifikatModel? get sertifikatModel => _sertifikatModel;
  final AuthController authController;
  SertifikatProvider({required this.authController});

  Future<void> getBimbingan() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      debugPrint('Try API');
      http.Response response = await http.get(
        super.sertifikatPath,
        headers: super.getHeaders(tokenUser),
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        // debugPrint('Berhasil mendapatkan data: ${response.body}');
        final responseData = json.decode(response.body);
        debugPrint('respon data: $responseData');
        _sertifikatModel = SertifikatModel.fromJson(responseData);
        debugPrint('Data berhasil di-parse: $_sertifikatModel');

        notifyListeners();

        debugPrint('Data berhasil di-parse: $_sertifikatModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sertifikat Siswa Provider Error: $e');
      debugPrint('Url Sertifikat Siswa: ${super.sertifikatPath}');
    }
  }
  Future<void> submitSertifikat(
      {required Map<String, dynamic> formData}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.postSertifikatPath;
      final requestBody = formData;
      final request = http.Request('POST', uri)
        ..headers.addAll({
          ...super.getHeaders(tokenUser),
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode(requestBody);
      debugPrint('Request Body: ${jsonEncode(requestBody)}');
      final response = await request.send();
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil submit logbook');
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
}
