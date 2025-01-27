import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin_sekolah/penilaian_show.dart';
import 'package:si_pkl/provider/admin/evaluations_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class PenilaianTablePage extends StatelessWidget {
  const PenilaianTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final evaluationsProvider =
        Provider.of<EvaluationsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: evaluationsProvider.getEvaluations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Data Penilaian',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Consumer<EvaluationsProvider?>(
                  builder: (context, provider, child) {
                    final penilaian =
                        provider?.evaluationsModel?.internship ?? [];
                    if (penilaian.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data penilaian PKL.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(1, 1),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(-1, -1),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              clipBehavior: Clip.hardEdge,
                              dataRowMinHeight: 45,
                              horizontalMargin: 30,
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    "No".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "NISN",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Nama Siswa".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "kelas".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "nama guru pembimbing".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "nama perusahaan".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "nilai monitoring".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "nilai sertifikat".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "nilai akhir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "aksi".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                penilaian.length,
                                (index) {
                                  final penilaianData = penilaian[index];
                                  final nomor = index + 1;
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(nomor.toString())),
                                      DataCell(Text(
                                          penilaianData.student?.nisn ?? '-')),
                                      DataCell(Text(
                                          penilaianData.student?.nama ?? '-')),
                                      DataCell(Text(
                                          penilaianData.student?.mayor?.nama ??
                                              '-')),
                                      DataCell(Text(
                                          penilaianData.teacher?.nama ?? '-')),
                                      DataCell(Text(
                                          penilaianData.corporation?.nama ??
                                              '-')),
                                      DataCell(Text(
                                          '${penilaianData.assessment?.length.toString()}/5')),
                                      DataCell(Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: penilaianData.evaluation
                                                        ?.nilaiAkhir !=
                                                    null
                                                ? GlobalColorTheme.successColor
                                                    .withOpacity(0.15)
                                                : GlobalColorTheme.errorColor
                                                    .withOpacity(0.15)),
                                        child: Text(
                                          penilaianData
                                                      .evaluation?.nilaiAkhir !=
                                                  null
                                              ? 'Sudah diberi penilaian'
                                                  .toUpperCase()
                                              : 'Belum diberi penilaian'
                                                  .toUpperCase(),
                                          style: TextStyle(
                                              color: penilaianData.evaluation
                                                          ?.nilaiAkhir !=
                                                      null
                                                  ? GlobalColorTheme
                                                      .successColor
                                                  : GlobalColorTheme
                                                      .errorColor),
                                        ),
                                      )),
                                      DataCell(Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: penilaianData.evaluation
                                                        ?.sertifikat !=
                                                    null
                                                ? GlobalColorTheme.successColor
                                                    .withOpacity(0.15)
                                                : GlobalColorTheme.errorColor
                                                    .withOpacity(0.15)),
                                        child: Text(
                                          penilaianData
                                                      .evaluation?.sertifikat !=
                                                  null
                                              ? 'Sudah diberi sertifikat'
                                                  .toUpperCase()
                                              : 'Belum diberi sertifikat'
                                                  .toUpperCase(),
                                          style: TextStyle(
                                              color: penilaianData.evaluation
                                                          ?.sertifikat !=
                                                      null
                                                  ? GlobalColorTheme
                                                      .successColor
                                                  : GlobalColorTheme
                                                      .errorColor),
                                        ),
                                      )),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {
                                            final penilaianId = penilaianData
                                                .id; // Ambil ID penilaian dari objek penilaian
                                            debugPrint(
                                                'ID penilaian yang dipilih: $penilaianId');

                                            // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        PenilaianShow(
                                                  assessmentId: penilaianId,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
