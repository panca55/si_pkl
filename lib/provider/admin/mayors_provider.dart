import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/mayors_model.dart';

class MayorsProvider extends BaseApi with ChangeNotifier {
  MayorsModel? _mayorsModel;
  MayorsModel? get mayorsModel => _mayorsModel;
  final AuthController authController;
  MayorsProvider({required this.authController});

  Future<void> getMayors() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
    try {
      http.Response response = await http.get(
        super.mayorsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _mayorsModel = MayorsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_mayorsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addMayor({
    required Map<String, dynamic> data,
  }) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';
    try {
      final uri = super.addMayorPath;
      final requestBody = data;
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
        final responseData = json.decode(responseBody);
        _mayorsModel = MayorsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
}
