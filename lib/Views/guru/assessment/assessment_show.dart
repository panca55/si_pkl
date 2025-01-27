import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_detail.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_edit.dart';
import 'package:si_pkl/models/guru/assessment/assessments_show_model.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_detail_provider.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_show_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssessmentShow extends StatefulWidget {
  static const String routname = '/assessment-show';
  final int? assessmentId;
  const AssessmentShow({super.key, required this.assessmentId});

  @override
  State<AssessmentShow> createState() => _AssessmentShowState();
}

class _AssessmentShowState extends State<AssessmentShow> {
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
    final assessment =
        Provider.of<AssessmentShowProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: assessment.getShowAssessments(widget.assessmentId!),
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
            final assessmentData = assessment.assessmentsModel;
            final internship = assessmentData?.internship;
            final tanggalBerakhir = internship?.tanggalBerakhir != null
                ? DateTime.tryParse(internship!.tanggalBerakhir!)
                : null;
            final dateEnd = tanggalBerakhir != null
                ? DateFormat('dd MMMM yyyy', 'id_ID')
                    .format(tanggalBerakhir)
                : '-';
            final tanggalMulai = internship?.tanggalMulai != null
                ? DateTime.tryParse(internship!.tanggalMulai!)
                : null;
            final dateStart = tanggalMulai != null
                ? DateFormat('dd MMMM yyyy', 'id_ID')
                    .format(tanggalMulai)
                : '-';
            loading = false;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: loading,
                    enableSwitchAnimation: true,
                    child: _buildInfoCard(
                      colorHeader: GlobalColorTheme.primaryBlueColor,
                      title: 'Informasi Siswa',
                      property1: 'Nama',
                      value1: internship?.student?.nama,
                      property2: 'NISN',
                      value2: internship?.student?.nisn,
                      property3: 'Kelas',
                      value3: internship?.student?.mayor?.nama,
                      property4: 'Keahlian',
                      value4: internship?.student?.mayor?.department?.nama,
                      property5: 'Konsentrasi',
                      value5: internship?.student?.konsentrasi,
                      property6: 'Tempat PKL',
                      value6: internship?.corporation?.nama,
                      property7: 'Tanggal Pkl',
                      value7: 'Mulai: $dateStart / Selesai : $dateEnd',
                      property8: 'Nama Instruktur',
                      value8: internship?.instructor?.nama,
                      property9: 'Nama Pembimbing',
                      value9: internship?.teacher?.nama,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: assessmentList(assessmentShow: assessmentData)),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }

  StatefulBuilder assessmentList({AssessmentsShowModel? assessmentShow}) {
    const int itemsPerPage = 3; // Jumlah item per halaman
    int currentPage = 0; // Halaman saat ini

    return StatefulBuilder(
      builder: (context, setState) {
        final assessment = assessmentShow?.assessment?.toList() ?? [];
        final totalPages = (assessment.length / itemsPerPage).ceil();

        // Ambil absensi untuk halaman saat ini
        final currentPageItems = assessment
            .skip(currentPage * itemsPerPage)
            .take(itemsPerPage)
            .toList();

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
                    'Tabel Penilaian',
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
                      currentPageItems.length,
                      
                      (index) {
                        final nomor = index + 1;
                        final assessmentData = currentPageItems[index];
                        final tanggalPenilaian = assessmentData.createdAt != null
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
                                              AssessmentDetail(
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
                                  const SizedBox(width: 4,),
                                  GestureDetector(
                                    onTap: () async {
                                      final assessmentId = assessmentData.id;
                                      debugPrint(
                                          'ID yang dipilih: $assessmentId');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              AssessmentEdit(
                                            internshipId: assessmentId!,
                                          ),
                                        ),
                                      );},
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.edit_document,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final assessmentId = assessmentData.id;
                                      await context
                                          .read<AssessmentDetailProvider>()
                                          .getPrintAssessment(assessmentId!);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: GlobalColorTheme.errorColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.print,
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

              // Pagination buttons
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.green.shade800
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildInfoCard(
      {required Color colorHeader,
      required String title,
      required String property1,
      required String property2,
      required String property3,
      String? property4,
      String? property5,
      String? property6,
      String? property7,
      String? property8,
      String? property9,
      String? value1,
      String? value2,
      String? value3,
      String? value4,
      String? value5,
      String? value6,
      String? value7,
      String? value8,
      String? value9,
      }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoRow(property1, value1 ?? '-'),
              const SizedBox(height: 0),
              _buildInfoRow(property2, value2 ?? '-'),
              const SizedBox(height: 0),
              _buildInfoRow(property3, value3 ?? '-'),
              const SizedBox(height: 0),
              _buildInfoRow(property4!, value4 ?? '-'),
              const SizedBox(height: 0),
              _buildInfoRow(property5!, value5 ?? '-'),
              const SizedBox(width: 12),
              _buildInfoRow(property6!, value6 ?? '-'),
              const SizedBox(width: 12),
              _buildInfoRow(property7!, value7 ?? '-'),
              const SizedBox(width: 12),
              _buildInfoRow(property8!, value8 ?? '-'),
              const SizedBox(width: 12),
              _buildInfoRow(property9!, value9 ?? '-'),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Expanded(
            child: Text(
              softWrap: true,
              value,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
