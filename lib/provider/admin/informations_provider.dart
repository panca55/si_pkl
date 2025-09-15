import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/informations_model.dart';

class InformationsProvider extends BaseApi with ChangeNotifier {
  InformationsModel? _informationsModel;
  InformationsModel? get informationsModel => _informationsModel;
  List<Information> _information = [];
  List<Information> get informations => _information;
  Information? _detailInformation;
  Information? get detailInformation => _detailInformation;
  final AuthController authController;

  
  InformationsProvider({required this.authController});

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
  void _safeNotifyListeners() {
    if (!_disposed && hasListeners) {
      notifyListeners();
    }
  }
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
        _safeNotifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }
  Future<void> getInformations() async {
    try {
      http.Response response = await http.get(
        super.informationsPath,
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _informationsModel = InformationsModel.fromJson(responseData);
        _safeNotifyListeners();
        debugPrint('Data berhasil di-parse: $_informationsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  Future<void> getListInformations() async {
    try {
      http.Response response = await http.get(
        super.listinformationsPath,
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        debugPrint('Berhasil mendapatkan data: ${response.body}');
        final responseData = json.decode(response.body);
        _information = (responseData as List)
            .map((e) => Information.fromJson(e))
            .toList();
        _safeNotifyListeners();
        debugPrint('Data berhasil di-parse: $_informationsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Information Provider Error: $e');
    }
  }
  Future<void> getDetailInformations(int id) async {
    try {
      http.Response response = await http.get(
        super.infoDetailPath(id),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        debugPrint('Berhasil mendapatkan data: ${response.body}');
        final responseData = json.decode(response.body);

        // Simpan sebagai Information langsung
        _detailInformation = Information.fromJson(responseData);

        _safeNotifyListeners();
        debugPrint('Data berhasil di-parse: $_detailInformation');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Information Provider Error: $e');
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
        _safeNotifyListeners();
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
        _safeNotifyListeners();
      } else {
        debugPrint('Gagal edit data siswa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit data siswa: $e');
    }
  }
}
