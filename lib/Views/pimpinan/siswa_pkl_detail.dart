import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/pimpinan/siswa_index_model.dart';
import 'package:si_pkl/provider/pimpinan/siswa_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class SiswaPklDetail extends StatelessWidget {
  static const String routname = '/siswa-pkl-detail';
  final int? siswaId;
  const SiswaPklDetail({super.key, required this.siswaId});

  @override
  Widget build(BuildContext context) {
    if (siswaId == null) {
      debugPrint('ID Siswa = $siswaId / tidak ditemukan');
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('ID Siswa tidak ditemukan'),
        ),
      );
    }
    debugPrint('ID yang terpilih: $siswaId');

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Provider.of<SiswaProvider>(context, listen: false)
              .getIndexSiswa(id: siswaId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            final siswa =
                Provider.of<SiswaProvider>(context, listen: false).siswa;
            debugPrint('Persentase hadir: ${siswa?.attendance?.percentage}');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    image:
                        'http://localhost:8000/storage/public/teachers-images/indah_1732989878.png',
                    colorHeader: GlobalColorTheme.primaryBlueColor,
                    title: siswa!.student!.nama!,
                    property1: 'Email',
                    value1: siswa.student?.user?.email,
                    property2: 'Tanggal Mulai',
                    value2: siswa.tanggalMulai,
                    property3: 'Tanggal Berakhir',
                    value3: siswa.tanggalBerakhir,
                    property4: 'Status PKL',
                    value4: siswa.status,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildAttendanceCard(
                    context: context,
                    colorHeader: GlobalColorTheme.successColor,
                    title: 'KEHADIRAN',
                    property1: 'Hadir',
                    property2: 'Izin',
                    property3: 'Sakit',
                    property4: 'Alpha',
                    value1: siswa.attendance?.hadir,
                    value2: siswa.attendance?.izin,
                    value3: siswa.attendance?.sakit,
                    value4: siswa.attendance?.alpha,
                    percentage: siswa.attendance?.percentage?.toDouble(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildLogbookCard(
                      colorHeader: Colors.amber,
                      title: 'Logbook',
                      logbookList: siswa.logbook!,
                      context: context),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildEvaluationCard(
                      colorHeader: GlobalColorTheme.errorColor,
                      title: "Penilaian Akhir Siswa",
                      context: context,
                      evaluation: siswa.evaluation)
                ],
              ),
            );
          }),
    );
  }

  Widget _buildInfoCard(
      {required Color colorHeader,
      required String title,
      required String property1,
      required String property2,
      required String property3,
      required String image,
      String? property4,
      String? value1,
      String? value2,
      String? value3,
      String? value4}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                image,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              const Divider(),
              _buildInfoRow(property1, value1 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property2, value2 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property3, value3 ?? '-'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property4!,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: GlobalColorTheme.successColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(1, 1))
                          ]),
                      child: Text(
                        value4!,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/pencil-rocket.png',
                  height: 180,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(
      {required Color colorHeader,
      required String title,
      required String property1,
      required String property2,
      required String property3,
      String? property4,
      int? value1,
      int? value2,
      int? value3,
      int? value4,
      double? percentage,
      required BuildContext context}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              _buildAttendanceRow(property1, value1 ?? 0),
              const SizedBox(height: 8),
              _buildAttendanceRow(property2, value2 ?? 0),
              const SizedBox(height: 8),
              _buildAttendanceRow(property3, value3 ?? 0),
              const SizedBox(height: 8),
              _buildAttendanceRow(property3, value4 ?? 0),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearPercentIndicator(
                      barRadius: const Radius.circular(1000),
                      backgroundColor: Colors.grey.shade400,
                      percent: percentage! / 100,
                      animation: true,
                      animationDuration: 1000,
                      center: Text('$percentage%',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 12)),
                      width: MediaQuery.of(context).size.width - 150,
                      lineHeight: 20,
                      progressBorderColor: Colors.black,
                      progressColor: GlobalColorTheme.primaryBlueColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogbookCard(
      {required Color colorHeader,
      required String title,
      required List<Logbook> logbookList,
      required BuildContext context}) {
    String removeHtmlTags(String htmlString) {
      final RegExp exp =
          RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '').trim();
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logbookList[i].judul!,
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          logbookList[i].tanggal!,
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(removeHtmlTags(logbookList[i].isi!)),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: logbookList.length),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationCard(
      {required Color colorHeader,
      required String title,
      Evaluation? evaluation,
      required BuildContext context}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (evaluation == null)
            const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Belum ada penilaian',
              ),
            ))
          else
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
                  TableCell(child: Text('Nilai', style: GoogleFonts.poppins())),
                ]),
                TableRow(children: [
                  TableCell(child: Text('1', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text('Rata-Rata Nilai Monitoring',
                          style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text(evaluation.monitoring.toString(),
                          style: GoogleFonts.poppins())),
                ]),
                TableRow(children: [
                  TableCell(child: Text('2', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text('Rata - Rata Nilai Sertifikat PKL',
                          style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text(evaluation.monitoring.toString(),
                          style: GoogleFonts.poppins())),
                ]),
                TableRow(children: [
                  TableCell(child: Text('3', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text('Laporan PKL', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text(evaluation.monitoring.toString(),
                          style: GoogleFonts.poppins())),
                ]),
                TableRow(children: [
                  TableCell(child: Text('4', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text('Presentasi', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text(evaluation.monitoring.toString(),
                          style: GoogleFonts.poppins())),
                ]),
                TableRow(children: [
                  TableCell(
                      child: Text('Nilai Akhir', style: GoogleFonts.poppins())),
                  TableCell(
                      child: Text(evaluation.nilaiAkhir.toString(),
                          style: GoogleFonts.poppins())),
                ]),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Text(
            ': $value',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Text(
            ': $value',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
