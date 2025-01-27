import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/bimbingan/bimbingan_index_model.dart';

class BimbinganIndexProvider extends BaseApi with ChangeNotifier {
  BimbinganIndexModel? _bimbinganIndexModel;
  BimbinganIndexModel? get bimbinganIndexModel => _bimbinganIndexModel;
  final AuthController authController;
  BimbinganIndexProvider({required this.authController});


  Future<void> getIndexBimbingan(int id) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
    try {
      http.Response response = await http.get(
        super.bimbinganIndexPath(id),
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        final bimbinganIndex = BimbinganIndexModel.fromJson(responseData);
        _bimbinganIndexModel = bimbinganIndex;
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
}
