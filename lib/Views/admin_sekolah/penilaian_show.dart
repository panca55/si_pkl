import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin_sekolah/widgets/penilaian_detail.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_detail.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_edit.dart';
import 'package:si_pkl/models/admin/evaluation/evaluations_show_model.dart';
import 'package:si_pkl/provider/admin/evaluations_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PenilaianShow extends StatefulWidget {
  static const String routname = '/penilaian-show';
  final int? assessmentId;
  const PenilaianShow({super.key, required this.assessmentId});

  @override
  State<PenilaianShow> createState() => _PenilaianShowState();
}

class _PenilaianShowState extends State<PenilaianShow> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    if (widget.assessmentId == null) {
      debugPrint('ID Siswa = ${widget.assessmentId} / tidak ditemukan');
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('ID Siswa tidak ditemukan'),
        ),
      );
    }
    debugPrint('ID yang terpilih: ${widget.assessmentId}');
    final assessment = Provider.of<EvaluationsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: assessment.getEvaluationShow(widget.assessmentId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              loading = true;
            } else if (snapshot.hasError) {
              debugPrint('Terjadi kesalahan: ${snapshot.error}');
              return Center(
                child: Text(
                  'Terjadi kesalahan: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final assessmentData = assessment.evaluationsShowModel;
            final sertifikatSiswaList =
                assessment.evaluationsShowModel?.certificate?.toList() ?? [];
            final penilaianAkhir =
                assessment.evaluationsShowModel?.internship?.evaluation;
            debugPrint('assessmentData: $assessmentData');
            debugPrint('penilaianAkhir: $penilaianAkhir');
            loading = false;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: assessmentList(assessmentShow: assessmentData)),
                  const SizedBox(
                    height: 20,
                  ),
                  if (penilaianAkhir == null)
                    const SizedBox.shrink()
                  else
                    Skeletonizer(
                        enabled: loading,
                        enableSwitchAnimation: true,
                        child: nilaiAkhir(assessmentShow: penilaianAkhir)),
                  const SizedBox(
                    height: 20,
                  ),
                  if (sertifikatSiswaList.isEmpty)
                    const SizedBox.shrink()
                  else
                    Skeletonizer(
                        enabled: loading,
                        enableSwitchAnimation: true,
                        child: sertifikatSiswa(
                            assessmentShow: sertifikatSiswaList)),
                ],
              ),
            );
          }),
    );
  }

  StatefulBuilder sertifikatSiswa({List<Certificate>? assessmentShow}) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Grouping data berdasarkan kategori
        final Map<String, List<Certificate>> groupedData = {};
        if (assessmentShow != null) {
          for (var certificate in assessmentShow) {
            final category = certificate.category ?? "Tanpa Kategori";
            groupedData.putIfAbsent(category, () => []).add(certificate);
          }
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
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Sertifikat Siswa',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // DataTable untuk Sertifikat
              Container(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(Colors.amber.shade700),
                    border:
                        TableBorder.all(color: Colors.grey.shade300, width: 1),
                    dividerThickness: 2,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          "No",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Kompetensi Penilaian",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Nilai",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Predikat",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: _generateTableRows(groupedData),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  List<DataRow> _generateTableRows(Map<String, List<Certificate>> groupedData) {
    List<DataRow> rows = [];

    for (var entry in groupedData.entries) {
      final category = entry.key;
      final categoryData = entry.value;

      // Tambahkan baris kategori
      rows.add(
        DataRow(
          color: WidgetStateProperty.all(Colors.amber.shade100),
          cells: [
            const DataCell(Text('')), // Kolom kosong
            DataCell(
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const DataCell(Text('')),
            const DataCell(Text('')),
          ],
        ),
      );

      // Tambahkan baris data di bawah kategori
      rows.addAll(
        categoryData.asMap().entries.map((entry) {
          final index = entry.key + 1; // Penomoran dimulai dari 1
          final data = entry.value;
          return DataRow(
            cells: [
              DataCell(Text(index.toString())), // Nomor urut
              DataCell(Text(data.nama ?? '-')), // Kompetensi Penilaian
              DataCell(Text(data.score.toString())), // Nilai
              DataCell(Text(data.predikat ?? '-')), // Predikat
            ],
          );
        }).toList(),
      );
    }

    return rows;
  }

  StatefulBuilder nilaiAkhir({Evaluation? assessmentShow}) {
    return StatefulBuilder(
      builder: (context, setState) {
        final penilaianAkhir = assessmentShow;
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
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Nilai Akhir',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // DataTable untuk absensi
              Padding(
                padding: const EdgeInsets.all(12),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Lebih besar untuk kolom KOMPONEN
                    1: FlexColumnWidth(1), // Lebih kecil untuk kolom NILAI
                  },
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // Header Tabel
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'KOMPONEN',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'NILAI',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // Baris Tabel
                    _buildTableRow(
                        'Penilaian Monitoring', penilaianAkhir?.monitoring),
                    _buildTableRow('Rata-Rata Nilai Sertifikat',
                        penilaianAkhir?.sertifikat),
                    _buildTableRow('Jurnal Harian', penilaianAkhir?.logbook),
                    _buildTableRow('Presentasi', penilaianAkhir?.presentasi),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Fungsi untuk membuat baris tabel
  TableRow _buildTableRow(String title, dynamic value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 13),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            value?.toString() ?? '-',
            style: GoogleFonts.poppins(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  StatefulBuilder assessmentList({EvaluationsShowModel? assessmentShow}) {
    final penilaianMonitoring = assessmentShow?.internship?.assessment ?? [];
    return StatefulBuilder(
      builder: (context, setState) {
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
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Penilaian Monitoring',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // DataTable untuk absensi
              Container(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    clipBehavior: Clip.hardEdge,
                    dataRowMinHeight: 45,
                    // horizontalMargin: 30,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          "No".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Judul Penilaian".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Tanggal Penilaian".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Aksi".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      penilaianMonitoring.length,
                      (index) {
                        final nomor = index + 1;
                        final assessmentData = penilaianMonitoring[index];
                        final tanggalPenilaian =
                            assessmentData.createdAt != null
                                ? DateTime.tryParse(assessmentData.createdAt!)
                                : null;
                        final tanggal = tanggalPenilaian != null
                            ? DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                .format(tanggalPenilaian)
                            : '-';

                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(nomor.toString(),
                                style: GoogleFonts.poppins(fontSize: 10))),
                            DataCell(Text(assessmentData.nama ?? '',
                                style: GoogleFonts.poppins(fontSize: 10))),
                            DataCell(Text(tanggal,
                                style: GoogleFonts.poppins(fontSize: 10))),
                            DataCell(
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final assessmentId = assessmentData.id;
                                      debugPrint(
                                          'ID yang dipilih: $assessmentId');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              PenilaianDetail(
                                            assessmentId: assessmentId!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: GlobalColorTheme.successColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
