import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/user_model.dart';

class UserProvider extends BaseApi with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  final AuthController authController;

  UserProvider({required this.authController});

  Future<void> getUser() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.currentUserPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        _currentUser = User.fromJson(result);
        notifyListeners();
        debugPrint('status: ${response.statusCode}');
        debugPrint('username: ${_currentUser?.name}');
        debugPrint('role: ${_currentUser?.role}');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }
}
