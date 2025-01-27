import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/detail_logbook_model.dart';

class DetailLogbookProvider extends BaseApi with ChangeNotifier {
  DetailLogbookModel? _detailLogbookModel;
  DetailLogbookModel? get detailLogbookModel => _detailLogbookModel;
  final AuthController authController;
  DetailLogbookProvider({required this.authController});

  Future<void> getIndexLogbook(int id) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
    try {
      http.Response response = await http.get(
        super.detailLogbookGuruPath(id),
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        final logbook = DetailLogbookModel.fromJson(responseData);
        _detailLogbookModel = logbook;
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> submitKomentar(
      {required int logbookId,
      required String noteType,
      required String catatan,
      required String penilaian}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.postKomentarPath;
      final requestBody = {
        'logbook_id': logbookId,
        'note_type': noteType,
        'catatan': catatan,
        'penilaian': penilaian,
      };
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
        final newKomentar = NoteGuru(catatan: catatan, penilaian: penilaian);
        _detailLogbookModel?.noteGuru = newKomentar;
        notifyListeners();
        debugPrint('Komentar: $newKomentar');
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
  Future<void> editKomentar(
      {required int id,
      required String catatan,
      required String penilaian}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editKomentarGuruPath(id);
      final requestBody = {
        'catatan': catatan,
        'penilaian': penilaian,
      };
      final request = http.Request('PUT', uri)
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
        final newKomentar = Note(id: id, catatan: catatan, penilaian: penilaian);
        _detailLogbookModel?.logbook?.note?.first = newKomentar;
        notifyListeners();
        debugPrint('Komentar: $newKomentar');
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
}
