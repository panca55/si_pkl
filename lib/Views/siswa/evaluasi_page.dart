import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/siswa/evaluation_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EvaluasiPage extends StatefulWidget {
  const EvaluasiPage({super.key});

  @override
  State<EvaluasiPage> createState() => _EvaluasiPageState();
}

class _EvaluasiPageState extends State<EvaluasiPage> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final evaluationProvider =
        Provider.of<EvaluationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: evaluationProvider.getEvaluationSiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Aktifkan skeleton saat menunggu
            loading = true;
          } else {
            // Nonaktifkan skeleton saat data selesai dimuat
            loading = false;

            if (snapshot.hasError) {
              // Tampilkan pesan error jika terjadi kesalahan
              return Center(
                child: Text(
                  'Terjadi kesalahan: ${snapshot.error}',
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                ),
              );
            }
          }

          final evaluation =
              evaluationProvider.evaluationModel?.internship?.evaluation;
          final isEvaluationEmpty =
              evaluationProvider.evaluationModel?.isEvaluationEmpty;
          final evaluationDate =
              evaluationProvider.evaluationModel?.evaluationDate;
          debugPrint('Evaluation Data: ${evaluation?.sertifikat}');
          debugPrint('Evaluation Data: $evaluationDate');
          // Handle if `evaluation` is null or empty
          if (evaluation == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  evaluationDate == null
                      ? 'Belum periode penilaian'
                      : 'Belum ada penilaian',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            );
          }
          if (isEvaluationEmpty == true) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Belum ada penilaian',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Skeletonizer(
                enabled: loading,
                enableSwitchAnimation: true,
                child: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Penilaian Siswa',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(40),
                          1: FlexColumnWidth(2),
                          2: FixedColumnWidth(80),
                        },
                        border: TableBorder.all(
                            color: Colors.grey.shade300, width: 1),
                        children: [
                          _buildTableHeader(),
                          _buildTableRow('1', 'Rata-Rata Nilai Monitoring',
                              evaluation.monitoring),
                          _buildTableRow('2', 'Rata-Rata Nilai Sertifikat PKL',
                              evaluation.sertifikat),
                          _buildTableRow(
                              '3', 'Laporan PKL', evaluation.logbook),
                          _buildTableRow(
                              '4', 'Presentasi', evaluation.presentasi),
                          _buildTableRow(
                              '5', 'Nilai Akhir', evaluation.nilaiAkhir),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.amber.shade100),
      children: [
        _buildCell('No', isHeader: true),
        _buildCell('Aspek Penilaian', isHeader: true),
        _buildCell('Nilai', isHeader: true),
      ],
    );
  }

  TableRow _buildTableRow(String no, String aspek, dynamic nilai) {
    return TableRow(
      children: [
        _buildCell(no),
        _buildCell(aspek),
        _buildCell(nilai?.toString() ?? '-'),
      ],
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 13 : 12,
          color: isHeader ? Colors.black87 : Colors.black,
        ),
      ),
    );
  }
}
