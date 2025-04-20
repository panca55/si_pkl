import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
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

  Future<void> getPrintEvaluation(int id) async {
    final tokenUser = authController.authToken;

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }
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
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        debugPrint('Berhasil mendapatkan data PDF.');

        // Ubah data PDF menjadi byte array
        Uint8List pdfData = response.bodyBytes;

        if (kIsWeb) {
          // Logika untuk platform web
          // await _downloadPdfWeb(pdfData, 'assessment.pdf');
        } else {
          // Logika untuk platform non-web
          await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdfData,
          );
        }

        debugPrint('File berhasil dicetak.');
        notifyListeners();
      } else {
        debugPrint('Gagal print: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Print Error: $e');
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