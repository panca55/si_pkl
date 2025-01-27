import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/guru/evaluation_guru_provider.dart';

class EvaluationShow extends StatefulWidget {
  static const String routname = '/evaluation-input';
  final int internshipId;

  const EvaluationShow({super.key, required this.internshipId});

  @override
  State<EvaluationShow> createState() => _EvaluationShowState();
}

class _EvaluationShowState extends State<EvaluationShow> {
  @override
  Widget build(BuildContext context) {
    final evaluationProvider =
        Provider.of<EvaluationGuruProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Uint8List?>(
        future: evaluationProvider.getShowEvaluation(widget.internshipId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'PDF tidak tersedia.',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Tampilkan PDF menggunakan `PdfPreview` dari `printing`
          final pdfData = snapshot.data!;
          return PdfPreview(
            initialPageFormat: PdfPageFormat.a4,
            scrollViewDecoration: const BoxDecoration(color: Colors.white),
            previewPageMargin:
                const EdgeInsets.only(top: 46, right: 26, left: 26),
            build: (format) => pdfData,
            allowPrinting: false,
            allowSharing: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            onZoomChanged: (value) => true,
          );
        },
      ),
    );
  }
}
