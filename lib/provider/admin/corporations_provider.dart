import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/corporations_model.dart';
import 'package:universal_io/io.dart' as universal_io;
class CorporationsProvider extends BaseApi with ChangeNotifier {
  CorporationsModel? _corporationsModel;
  CorporationsModel? get corporationsModel => _corporationsModel;
  final AuthController authController;
  CorporationsProvider({required this.authController});

  Future<void> getCorporations() async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      http.Response response = await http.get(
        super.corporationsPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        _corporationsModel = CorporationsModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Data berhasil di-parse: $_corporationsModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<void> addCorporate(
      {required Map<String, dynamic> data,
      required Uint8List? fileBytes,
      String? filePath,
      String? fileName}) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '296|2Pi0cH5e1fkYjZfMogujnAue733mGJeUNKuEsoG805d7cc10';
    try {
      final uri = super.addCorporatePath;
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          ...super.getHeaders(tokenUser),
        });
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      if (fileBytes != null && fileName != null) {
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto',
              fileBytes,
              filename: fileName,
              contentType: MediaType('image', fileName.split('.').last),
            ),
          );
        } else if (universal_io.Platform.isAndroid ||
            universal_io.Platform.isIOS) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto',
              filePath!,
              filename: fileName,
              contentType: MediaType('image', fileName.split('.').last),
            ),
          );
        }
      }

      debugPrint('Request Body: ${jsonEncode(data)}');
      final response = await request.send();
      debugPrint('Response Status Code: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil submit logbook');
        final responseData = json.decode(responseBody);
        _corporationsModel = CorporationsModel.fromJson(responseData);
        final newInstruktur = Corporations.fromJson(data);
        _corporationsModel?.corporation?.add(newInstruktur);
        notifyListeners();
      } else {
        debugPrint('Gagal submit komentar: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitKomentar: $e');
    }
  }
}
