import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/siswa/evaluation_model.dart';

class EvaluationProvider extends BaseApi with ChangeNotifier {
  EvaluationModel? _evaluationModel;
  EvaluationModel? get evaluationModel => _evaluationModel;
  final AuthController authController;

  EvaluationProvider({required this.authController});

  Future<void> getEvaluationSiswa() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.siswaEvaluationPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _evaluationModel = EvaluationModel.fromJson(responseData);
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Provider Error: $e');
    }
  }
}
