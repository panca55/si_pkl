import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/perusahaan/bursa_kerja_model.dart';

class BursaKerjaProvider extends BaseApi with ChangeNotifier {
  BursaKerjaModel? _bursaKerjaModel;
  BursaKerjaModel? get bursaKerjaModel => _bursaKerjaModel;
  final AuthController authController;
  BursaKerjaProvider({required this.authController});

  Future<void> getBursaKerja() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.bursaKerjaPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _bursaKerjaModel = BursaKerjaModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_bursaKerjaModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> createBursaKerja(
      Map<String, dynamic> data, Uint8List? fileBytes, String? fileName) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      if (fileBytes != null && fileName != null) {
        // Use MultipartRequest for file upload
        var request = http.MultipartRequest('POST', super.bursaKerjaPath);
        request.headers.addAll(super.getHeaders(tokenUser));
        request.fields
            .addAll(data.map((key, value) => MapEntry(key, value.toString())));
        request.files.add(http.MultipartFile.fromBytes('foto', fileBytes,
            filename: fileName));
        var response = await request.send();
        var responseData = await http.Response.fromStream(response);
        if (response.statusCode == 201) {
          debugPrint(
              'Berhasil membuat data dengan file: ${response.statusCode}');
          await getBursaKerja(); // Refresh data after creation
          notifyListeners();
        } else {
          debugPrint('Gagal membuat data dengan file: ${response.statusCode}');
          debugPrint('Response body: ${responseData.body}');
        }
      } else {
        // Use regular POST if no file
        http.Response response = await http.post(
          super.bursaKerjaPath,
          headers: super.getHeaders(tokenUser),
          body: json.encode(data),
        );
        if (response.statusCode == 201) {
          debugPrint('Berhasil membuat data: ${response.statusCode}');
          await getBursaKerja(); // Refresh data after creation
          notifyListeners();
        } else {
          debugPrint('Gagal membuat data: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Create Bursa Kerja Error: $e');
    }
  }

  Future<void> editBursaKerja(int id, Map<String, dynamic> data,
      Uint8List? fileBytes, String? fileName) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      // Remove 'id' from data as it should not be in request body for Laravel updates
      Map<String, dynamic> requestData = Map.from(data);
      requestData.remove('id');

      if (fileBytes != null && fileName != null) {
        // Use MultipartRequest for file upload
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://127.0.0.1:8000/api/bursa/$id'));
        request.headers.addAll(super.getHeaders(tokenUser));
        request.fields.addAll(
            requestData.map((key, value) => MapEntry(key, value.toString())));
        request.fields['_method'] = 'PUT'; // For Laravel PUT via POST
        request.files.add(http.MultipartFile.fromBytes('foto', fileBytes,
            filename: fileName));
        var response = await request.send();
        var responseData = await http.Response.fromStream(response);
        if (response.statusCode == 200) {
          debugPrint('Berhasil edit data dengan file: ${response.statusCode}');
          await getBursaKerja(); // Refresh data after edit
          notifyListeners();
        } else {
          debugPrint('Gagal edit data dengan file: ${response.statusCode}');
          debugPrint('Response body: ${responseData.body}');
        }
      } else {
        // Use regular PUT if no file
        http.Response response = await http.put(
          Uri.parse('http://127.0.0.1:8000/api/bursa/$id'),
          headers: super.getHeaders(tokenUser),
          body: json.encode(requestData),
        );
        if (response.statusCode == 200) {
          debugPrint('Berhasil edit data: ${response.statusCode}');
          await getBursaKerja(); // Refresh data after edit
          notifyListeners();
        } else {
          debugPrint('Gagal edit data: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Edit Bursa Kerja Error: $e');
    }
  }
}
