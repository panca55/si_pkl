import 'package:flutter/material.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:si_pkl/models/user_model.dart';

class AuthController extends BaseApi with ChangeNotifier {
  final BaseApi api = BaseApi();
  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  
  String? _token;
  String? get authToken => _token;
  void clearUserData() {
    _users.clear();
    _currentUser = null;
    _token = null;
    api.setToken(''); 
    notifyListeners();
  }
  Future<bool> login(String email, String password) async {
    var body = jsonEncode({'email': email, 'password': password});
    http.Response response =
        await http.post(super.authPath, headers: super.headers, body: body);
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final loginResponse = UserModel.fromJson(responseData);
        _currentUser = UserModel.fromJson(responseData);
        api.setToken(loginResponse.token!);
        _token = loginResponse.token;
        notifyListeners();
        if (loginResponse.token != null) {
          api.setToken(loginResponse.token!);
          debugPrint('Login berhasil: ${loginResponse.token}');
          debugPrint('role `user: ${currentUser?.user?.role}');
          notifyListeners();
          return true;
        } else {
          debugPrint('Login gagal: token tidak ditemukan');
          return false;
        }
      } else {
        debugPrint(
            'Login gagal: status respon(${response.statusCode}), body: body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: ');
      return false;
    }
  }
  Future<bool> register({required String name, required String email,
      required String password, required String passwordConfirmation}) async {
    var body = jsonEncode({
      'name': name, 
      'email': email, 
      'password': password,
      'password_confirmation': passwordConfirmation,
      });
    http.Response response =
        await http.post(super.registerPath, headers: super.headers, body: body);
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('response: $responseData');
        notifyListeners();
        return true;
      } else {
        debugPrint(
            'Login gagal: status respon(${response.statusCode}), body: body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error: ');
      return false;
    }
  }

  Future<bool> logout(String token) async {
  if (_token == null) {
    debugPrint("Logout gagal: Tidak ada token yang tersimpan.");
    return false;
  }

  try {
    http.Response response = await http.delete(
      super.logoutPath,
      headers: super.getHeaders(token), // Token dikirim dalam header
    );

    if (response.statusCode == 200) {
      clearUserData();
      debugPrint("Logout berhasil.");
      return true;
    } else {
      debugPrint("Logout gagal: status respon (${response.statusCode}), body: ${response.body}");
      return false;
    }
  } catch (e) {
    debugPrint("Error saat logout: $e");
    return false;
  }
}

}
