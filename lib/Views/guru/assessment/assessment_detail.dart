import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/guru/assessment/assessment_detail_model.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_detail_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssessmentDetail extends StatefulWidget {
  static const String routeName = '/assessment-detail';
  final int? assessmentId;

  const AssessmentDetail({super.key, required this.assessmentId});

  @override
  State<AssessmentDetail> createState() => _AssessmentDetailState();
}

class _AssessmentDetailState extends State<AssessmentDetail> {
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
    final assessmentProvider =
        Provider.of<AssessmentDetailProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: assessmentProvider.getShowAssessments(widget.assessmentId!),
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

          final assessmentData = assessmentProvider.assessmentsModel;
          final assessment = assessmentData?.assessment;
          final internship = assessment?.internship;

          loading = false;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeletonizer(
                  enabled: loading,
                  enableSwitchAnimation: true,
                  child: _internshipTable(internship: internship),
                ),
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _internshipTable({Internship? internship}) {
    final dateStart = _formatDate(internship?.tanggalMulai);
    final dateEnd = _formatDate(internship?.tanggalBerakhir);

    return _buildContainer(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(3),
        },
        border: TableBorder.all(color: Colors.grey.shade300, width: 1),
        children: [
          _buildTableRow(
              'Nama Peserta Didik',':',internship?.student?.nama ?? '-'),
          _buildTableRow('NISN', ':', internship?.student?.nisn ?? '-'),
          _buildTableRow('Kelas', ':', internship?.student?.mayor?.nama ?? '-'),
          _buildTableRow('Program Keahlian', ':',
              internship?.student?.mayor?.department?.nama ?? '-'),
          _buildTableRow(
              'Konsentrasi Keahlian', ':', internship?.student?.konsentrasi ?? '-'),
          _buildTableRow('Tempat PKL', ':', internship?.corporation?.nama ?? '-'),
          _buildTableRow(
              'Tanggal PKL', ':', 'Mulai: $dateStart / Selesai: $dateEnd'),
          _buildTableRow(
              'Nama Instruktur', ':', internship?.instructor?.nama ?? '-'),
          _buildTableRow('Nama Pembimbing', ':', internship?.teacher?.nama ?? '-'),
        ],
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
          _buildTableRow('Tujuan Pembelajaran', 'Skor','Deskripsi', true),
          _buildTableRow(
              '1. Menerapkan soft skills',
              assessment?.softSkill?.toString() ?? '-',
              assessment?.deskripsiSoftSkill ?? '-'),
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
              '5. ${assessment?.catatan ?? '-'}', assessment?.score?.toString() ?? '-', assessment?.deskripsiCatatan ?? '-'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String col1,
      [String? col2, String? col3, bool isHeader = false]) {
    final style = GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal);
    return TableRow(
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

  String _formatDate(String? date) {
    if (date == null) return '-';
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return '-';
    return DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);
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
