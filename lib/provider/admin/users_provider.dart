import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/users_model.dart';

class UsersProvider extends BaseApi with ChangeNotifier {
  UsersModel? _usersModel;
  UsersModel? get usersModel => _usersModel;
  final List<User> _user = [];
  List<User> get user => _user;
  final AuthController authController;
  UsersProvider({required this.authController});

  Future<void> getUsers() async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.usersPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _usersModel = UsersModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_usersModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Users Provider Error: $e');
    }
  }

  Future<void> addUser({
    required Map<String, dynamic> data,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.addUserPath;
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
        _usersModel = UsersModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
  Future<void> toggleActive({
    required int userId,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.toggleActivePath;
      final requestBody = {
        'user_id': userId,
      };
      final request = http.Request('PATCH', uri)
        ..headers.addAll({
          ...super.getHeaders(tokenUser),
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode(requestBody);
      debugPrint('Request Body: ${jsonEncode(requestBody)}');
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil mengubah status aktif');

        // Cari user dalam model dan perbarui status
        if (_usersModel != null) {
          final userIndex =
              _usersModel!.user?.indexWhere((user) => user.id == userId);
          if (userIndex != -1) {
            // Ubah nilai isActive (1 -> 0 atau 0 -> 1)
            _usersModel!.user?[userIndex!].isActive =
                _usersModel!.user?[userIndex].isActive == 1 ? 0 : 1;
          }
        }

        notifyListeners();
      } else {
        debugPrint('Gagal mengubah status aktif: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error toggleActive: $e');
    }
  }

  Future<void> editUser({
    required int id,
    required Map<String, dynamic> data
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editUserPath(id);
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
        _usersModel = UsersModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal edit data siswa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error edit data siswa: $e');
    }
  }
  Future<void> deleteUser({
    required int id,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.deleteUserPath(id);
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
        _user.removeWhere((user) => user.id == id);
        notifyListeners();
      } else {
        debugPrint('Gagal menghapus data user:: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error menghapus data user:: $e');
    }
  }
}
