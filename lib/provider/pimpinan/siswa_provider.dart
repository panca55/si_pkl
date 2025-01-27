import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/pimpinan/siswa_index_model.dart';
import 'package:si_pkl/models/pimpinan/siswa_model.dart';

class SiswaProvider extends BaseApi with ChangeNotifier {
  // List untuk menyimpan data siswa
  final List<DataSiswa> _siswaList = [];
  List<DataSiswa> get siswaList => List.unmodifiable(_siswaList);

  // Data individu siswa
  SiswaIndexModel? _siswa;
  SiswaIndexModel? get siswa => _siswa;

  // Dependency AuthController untuk autentikasi
  final AuthController authController;

  SiswaProvider({required this.authController});

  /// Fungsi untuk mendapatkan semua data siswa PKL
  Future<void> getSiswa() async {
    final tokenUser = authController.authToken;
    try {
      final response = await http.get(
        super.siswaPimpinanPath,
        headers: super.getHeaders(tokenUser),
      );

      if (response.statusCode == 200) {
        // Parsing JSON dan simpan ke dalam list
        final siswaList = siswaModelFromJson(response.body);
        _siswaList
          ..clear() // Kosongkan daftar sebelum menambahkan data baru
          ..addAll(siswaList.data);
        notifyListeners();
      } else {
        _logError(response, 'Gagal mendapatkan data siswa.');
      }
    } catch (e) {
      debugPrint('SiswaProvider Error (getSiswa): $e');
    }
  }

  /// Fungsi untuk mendapatkan data siswa berdasarkan ID
  Future<void> getIndexSiswa({required int id}) async {
    final tokenUser = authController.authToken;
    try {
      final response = await http.get(
        super.siswaIndexPath(id),
        headers: super.getHeaders(tokenUser),
      );

      if (response.statusCode == 200) {
        // Parsing JSON dan simpan ke dalam objek siswa
        final siswa = SiswaIndexModel.fromJson(json.decode(response.body));
        _siswa = siswa;
        notifyListeners();
      } else {
        _logError(response, 'Gagal mendapatkan data siswa dengan ID $id.');
      }
    } catch (e) {
      debugPrint('SiswaProvider Error (getIndexSiswa): $e');
    }
  }

  /// Logging error secara konsisten
  void _logError(http.Response response, String message) {
    debugPrint(
      '$message\nStatus Code: ${response.statusCode}\nResponse Body: ${response.body}',
    );
  }
}
