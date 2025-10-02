import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/evaluation_model.dart';

class EvaluationGuruProvider extends BaseApi with ChangeNotifier {
  EvaluationModel? _evaluationModel;
  EvaluationModel? get evaluationModel => _evaluationModel;
  Evaluation? _evaluation;
  Evaluation? get evaluation => _evaluation;
  final AuthController authController;
  Uint8List? _pdfData;

  Uint8List? get pdfData => _pdfData;
  EvaluationGuruProvider({required this.authController});

  Future<void> getEvaluationSiswa() async {
    final tokenUser = authController.authToken;
    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
    try {
      http.Response response = await http.get(
        super.evaluationPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        final evaluation = EvaluationModel.fromJson(responseData);
        _evaluationModel = evaluation;
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }

  Future<Uint8List?> getPrintEvaluation(int id) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return null;
    }
    try {
      http.Response response = await http.get(
        super.printEvaluationPath(id),
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': '*/*',
        },
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        debugPrint('Content-Type: ${response.headers['content-type']}');
        debugPrint('Content-Length: ${response.headers['content-length']}');
        debugPrint('Berhasil mendapatkan data PDF.');
        debugPrint('PDF data length: ${response.bodyBytes.length}');
        debugPrint('PDF data first 20 bytes: ${response.bodyBytes.take(20)}');

        // Check if response is actually PDF data
        if (response.bodyBytes.isEmpty) {
          debugPrint('ERROR: PDF data is empty!');
          return null;
        }

        // Check if response is HTML error page instead of PDF
        if (response.headers['content-type']?.contains('text/html') == true) {
          debugPrint('ERROR: Server returned HTML instead of PDF!');
          debugPrint('Response body: ${response.body}');
          return null;
        }

        // Additional check: if response body starts with HTML tags, it's likely an error page
        String responseStart = response.body.length > 100
            ? response.body.substring(0, 100)
            : response.body;
        if (responseStart.contains('<html') ||
            responseStart.contains('<HTML') ||
            responseStart.contains('<!DOCTYPE html') ||
            responseStart.contains('error') ||
            responseStart.contains('Error') ||
            responseStart.contains('404') ||
            responseStart.contains('500')) {
          debugPrint('ERROR: Response appears to be HTML error page, not PDF!');
          debugPrint('Response start: $responseStart');
          return null;
        }

        return response.bodyBytes;
      } else {
        debugPrint('Gagal mendapatkan PDF: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Print Error: $e');
      return null;
    }
  }

  // Future<void> _downloadPdfWeb(Uint8List pdfData, String fileName) async {
  //   // Fungsi khusus untuk mengunduh file PDF di platform web
  //   final blob = html.Blob([pdfData]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..target = 'blank'
  //     ..download = fileName
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }

  Future<Uint8List?> getShowEvaluation(int id) async {
    final tokenUser = authController.authToken;

    try {
      http.Response response = await http.get(
        super.printEvaluationPath(id),
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Content-Type': 'application/pdf',
          'Accept': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data PDF.');
        _pdfData = response.bodyBytes; // Update data PDF
        notifyListeners(); // Beritahu UI untuk memperbarui
        return _pdfData; // Kembalikan data PDF
      } else {
        debugPrint('Gagal print: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Print Error: $e');
      return null;
    }
  }

  Future<void> submitEvaluation({
    required int internshipId,
    required int monitoring,
    required int sertifikat,
    required int logbook,
    required int presentasi,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.evaluationPath;
      final requestBody = {
        'internship_id': internshipId,
        'monitoring': monitoring,
        'sertifikat': sertifikat,
        'logbook': logbook,
        'presentasi': presentasi,
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
        final newEvaluation = Evaluation(
          internshipId: internshipId,
          monitoring: monitoring,
          sertifikat: sertifikat,
          logbook: logbook,
          presentasi: presentasi,
        );
        _evaluation = newEvaluation;
        notifyListeners();
        debugPrint('Evaluation: $newEvaluation');
      } else {
        debugPrint('Gagal submit Evaluation: ${response.statusCode}');
        debugPrint('Request: $request');
      }
    } catch (e) {
      debugPrint('Error submitEvaluation: $e');
    }
  }
}
