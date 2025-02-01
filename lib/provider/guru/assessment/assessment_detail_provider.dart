import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/guru/assessment/assessment_detail_model.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class AssessmentDetailProvider extends BaseApi with ChangeNotifier {
  AssessmentDetailModel? _assessmentDetailModel;
  AssessmentDetailModel? get assessmentsModel => _assessmentDetailModel;
  final AuthController authController;
  AssessmentDetailProvider({required this.authController});

  Future<void> getShowAssessments(int id) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '340|PtK7ZVsJUxGaO9i0e96koACk8m07CqZ1eMm4aqg496e10889';

    // if (tokenUser == null) {
    //   debugPrint('Auth token is null. Please log in again.');
    //   return;
    // }
    try {
      http.Response response = await http.get(
        super.assessmentDetailPath(id),
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');
        final responseData = json.decode(response.body);
        final assessment = AssessmentDetailModel.fromJson(responseData);
        _assessmentDetailModel = assessment;
        notifyListeners();
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Bimbingan Siswa Provider Error: $e');
    }
  }
  Future<void> getPrintAssessment(int id) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '340|PtK7ZVsJUxGaO9i0e96koACk8m07CqZ1eMm4aqg496e10889';

    // if (tokenUser == null) {
    //   debugPrint('Auth token is null. Please log in again.');
    //   return;
    // }
    try {
      http.Response response = await http.get(
        super.printAssessmentPath(id),
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
          final blob = html.Blob([pdfData]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = 'assessment.pdf'
            ..click();
          html.Url.revokeObjectUrl(url);
          return;
        }
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        );

        debugPrint('File berhasil dicetak.');
        notifyListeners();
      } else {
        debugPrint('Gagal print: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Print Error: $e');
    }
  }
}
