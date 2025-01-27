import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/users_model.dart';

class UsersProvider extends BaseApi with ChangeNotifier {
  UsersModel? _usersModel;
  UsersModel? get usersModel => _usersModel;
  final AuthController authController;
  UsersProvider({required this.authController});

  Future<void> getUsers() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';

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
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';
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
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';
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
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil mengubah status aktif');
        final responseData = json.decode(responseBody);

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

}
