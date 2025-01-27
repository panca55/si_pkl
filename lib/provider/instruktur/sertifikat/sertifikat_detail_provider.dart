import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/instruktur/sertifikat/sertifikat_detail_model.dart';
import 'dart:html' as html;

class SertifikatDetailProvider extends BaseApi with ChangeNotifier {
  SertifikatDetailModel? _sertifikatDetailModel;
  SertifikatDetailModel? get sertifikatDetailModel => _sertifikatDetailModel;
  final AuthController authController;
  SertifikatDetailProvider({required this.authController});
  Uint8List? _pdfData;

  Uint8List? get pdfData => _pdfData;
  Future<void> getBimbingan(int id) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '501|OzL9PoHIs30Npe6CfbJGHvgIyciA2BNgNRr47Ck712239be1';

    if (tokenUser == null) {
      debugPrint('Auth token is null. Please log in again.');
      return;
    }

    try {
      debugPrint('Try API');
      http.Response response = await http.get(
        super.sertifikatDetailPath(id),
        headers: super.getHeaders(tokenUser),
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mendapatkan data: ${response.statusCode}');

        final responseData = json.decode(response.body);
        _sertifikatDetailModel = SertifikatDetailModel.fromJson(responseData);
        notifyListeners();

        debugPrint('Data berhasil di-parse: $_sertifikatDetailModel');
        debugPrint('respon data: $responseData');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sertifikat Siswa Provider Error: $e');
      debugPrint('Url Sertifikat Siswa: ${super.sertifikatPath}');
    }
  }
  Future<void> getPrintSertifikat(int id) async {
    // final tokenUser = authController.authToken;
    const tokenUser = '501|OzL9PoHIs30Npe6CfbJGHvgIyciA2BNgNRr47Ck712239be1';

    // if (tokenUser == null) {
    //   debugPrint('Auth token is null. Please log in again.');
    //   return;
    // }
    try {
      http.Response response = await http.get(
        super.printSertifikatPath(id),
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
            ..download = 'sertifikat.pdf'
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
