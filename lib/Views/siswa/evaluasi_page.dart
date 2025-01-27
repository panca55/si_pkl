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

          // Handle if `evaluation` is null
          if (evaluation == null ||
              evaluationDate == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Belum periode penilaian',
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
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              'No',
                              style: GoogleFonts.poppins(),
                            )),
                            TableCell(
                                child: Text('Aspek Penilaian',
                                    style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text('Nilai',
                                    style: GoogleFonts.poppins())),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('1', style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text('Rata-Rata Nilai Monitoring',
                                    style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text(evaluation.monitoring.toString(),
                                    style: GoogleFonts.poppins())),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('2', style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text('Rata - Rata Nilai Sertifikat PKL',
                                    style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text(evaluation.sertifikat.toString(),
                                    style: GoogleFonts.poppins())),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('3', style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text('Laporan PKL',
                                    style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text(evaluation.logbook.toString(),
                                    style: GoogleFonts.poppins())),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('4', style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text('Presentasi',
                                    style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text(evaluation.presentasi.toString(),
                                    style: GoogleFonts.poppins())),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text('Nilai Akhir',
                                    style: GoogleFonts.poppins())),
                            TableCell(
                                child: Text(evaluation.nilaiAkhir.toString(),
                                    style: GoogleFonts.poppins())),
                          ]),
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
}
