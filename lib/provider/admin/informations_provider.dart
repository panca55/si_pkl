import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/informations_model.dart';

class InformationsProvider extends BaseApi with ChangeNotifier {
  InformationsModel? _informationsModel;
  InformationsModel? get informationsModel => _informationsModel;
  final List<Information> _information = [];
  List<Information> get informations => _information;
  final AuthController authController;
  InformationsProvider({required this.authController});

  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editInfoPath(id);
      // Menyiapkan request dengan 'Content-Type' application/json
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // Mengecek respon dari server
      debugPrint('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil menghapus data user:');
        _information.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }
  Future<void> getInformations() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.informationsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _informationsModel = InformationsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_informationsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addInfo({
    required Map<String, dynamic> data,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addInfoPath;
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
        _informationsModel = InformationsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
  Future<void> editInfo({
    required int id,
    required Map<String, dynamic> data,
    String? fileName,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editInfoPath(id);
      // Menyiapkan request dengan 'Content-Type' application/json
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data), // Kirim data sebagai JSON
      );

      // Mengecek respon dari server
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = response.body;
      debugPrint('Response Body: $responseBody');
      debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(responseBody);
        debugPrint('Berhasil edit data siswa');
        debugPrint('Data sebelum dikirim: ${jsonEncode(data)}');
        _informationsModel = InformationsModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal edit data siswa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit data siswa: $e');
    }
  }
}
