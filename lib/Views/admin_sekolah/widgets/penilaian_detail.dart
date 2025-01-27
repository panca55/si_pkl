import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/admin/evaluation/evaluations_detail_model.dart';
import 'package:si_pkl/provider/admin/evaluations_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PenilaianDetail extends StatefulWidget {
  static const String routeName = '/assessment-detail';
  final int? assessmentId;

  const PenilaianDetail({super.key, required this.assessmentId});

  @override
  State<PenilaianDetail> createState() => _PenilaianDetailState();
}

class _PenilaianDetailState extends State<PenilaianDetail> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    if (widget.assessmentId == null) {
      debugPrint('ID Siswa tidak ditemukan: ${widget.assessmentId}');
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('ID Siswa tidak ditemukan'),
        ),
      );
    }

    debugPrint('ID yang terpilih: ${widget.assessmentId}');
    final penilaianDetailProvider =
        Provider.of<EvaluationsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: penilaianDetailProvider.getEvaluationDetail(widget.assessmentId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            loading = true;
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint('Terjadi kesalahan: ${snapshot.error}');
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final assessmentData = penilaianDetailProvider.evaluationsDetailModel;
          final assessment = assessmentData?.assessment;

          loading = false;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Skeletonizer(
                  enabled: loading,
                  enableSwitchAnimation: true,
                  child: _assessmentTable(assessment: assessment),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(2, 2))
                          ]),
                      child: Text(
                        'Kembali',
                        style: GoogleFonts.poppins(
                            color: GlobalColorTheme.primaryBlueColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _assessmentTable({Assessment? assessment}) {
    return _buildContainer(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(3),
        },
        border: TableBorder.all(color: Colors.grey.shade300, width: 1),
        children: [
          _buildTableRow('Tujuan Pembelajaran', 'Skor', 'Deskripsi', true),
          _buildTableRow(
              '1. Menerapkan soft skills',
              assessment?.softskill?.toString() ?? '-',
              assessment?.deskripsiSoftskill ?? '-'),
          _buildTableRow(
              '2. Menerapkan norma dan K3LH',
              assessment?.norma?.toString() ?? '-',
              assessment?.deskripsiNorma ?? '-'),
          _buildTableRow(
              '3. Menerapkan kompetensi teknis',
              assessment?.teknis?.toString() ?? '-',
              assessment?.deskripsiTeknis ?? '-'),
          _buildTableRow(
              '4. Memahami alur bisnis',
              assessment?.pemahaman?.toString() ?? '-',
              assessment?.deskripsiPemahaman ?? '-'),
          _buildTableRow(
              '5. ${assessment?.catatan ?? '-'}',
              assessment?.score?.toString() ?? '-',
              assessment?.deskripsiCatatan ?? '-'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String col1,
      [String? col2, String? col3, bool isHeader = false]) {
    final style = GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        color: isHeader ? Colors.white : Colors.black);
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey: Colors.white
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(col1, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(col2 ?? '-', style: style, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(col3 ?? '-', style: style),
        ),
      ],
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
