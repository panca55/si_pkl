import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_input.dart';
import 'package:si_pkl/Views/guru/evaluation/evaluation_input.dart';
import 'package:si_pkl/Views/guru/evaluation/evaluation_show.dart';
import 'package:si_pkl/models/guru/evaluation_model.dart';
import 'package:si_pkl/provider/guru/evaluation_guru_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:si_pkl/widgets/pdf_preview_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  bool loading = true;
  bool _isPrinting = false;
  @override
  Widget build(BuildContext context) {
    final evaluationProvider =
        Provider.of<EvaluationGuruProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: evaluationProvider.getEvaluationSiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            loading = true;
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          loading = false;
          final evaluation =
              evaluationProvider.evaluationModel?.internship?.toList();
          final periode = evaluationProvider.evaluationModel?.periode;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Skeletonizer(
              enabled: loading,
              enableSwitchAnimation: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Penilaian Akhir Siswa',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (evaluation == null ||
                      evaluation.isEmpty ||
                      periode == null)
                    const Center(
                      child: Text(
                        'Mengambil data siswa monitoring',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (evaluation != null &&
                      evaluation.isNotEmpty &&
                      periode != null)
                    tabelMonitoring(evaluation)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container tabelMonitoring(List<Internship> internship) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(1, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
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
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "nama siswa".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "jurusan".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "kelas".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "nama perusahaan".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "penilaian".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "aksi".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
            ],
            rows: List<DataRow>.generate(
              internship.length,
              (index) {
                final internshipData = internship[index];
                final nomor = index + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(nomor.toString())),
                    DataCell(Text(internshipData.student?.nama ?? '-')),
                    DataCell(Text(
                        internshipData.student?.mayor?.department?.nama ??
                            '-')),
                    DataCell(Text(internshipData.student?.mayor?.nama ?? '-')),
                    DataCell(Text(internshipData.corporation?.nama ?? '-')),
                    DataCell(Text(internshipData.evaluation != null
                        ? 'Sudah Dinilai'
                        : 'Belum Diberi Nilai')),
                    DataCell(
                      internshipData.evaluation == null
                          ? GestureDetector(
                              onTap: () {
                                final internshipId = internshipData.id;
                                debugPrint('ID yang dipilih: $internshipId');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        EvaluationInput(
                                      internshipId: internshipId!,
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
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final internshipId =
                                        internshipData.evaluation?.id;
                                    debugPrint(
                                        'ID yang dipilih: $internshipId');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            EvaluationShow(
                                          internshipId: internshipId!,
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final internshipId = internshipData.id;
                                    debugPrint(
                                        'ID yang dipilih: $internshipId');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            AssessmentInput(
                                          internshipId: internshipId!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.edit_document,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: _isPrinting
                                      ? null
                                      : () async {
                                          setState(() => _isPrinting = true);
                                          try {
                                            final evaluationId =
                                                internshipData.evaluation?.id;
                                            final internshipId =
                                                internshipData.id;
                                            debugPrint(
                                                'ID evaluation: $evaluationId, ID internship: $internshipId');

                                            // Get PDF data - try internship ID first, fallback to evaluation ID
                                            Uint8List? pdfData = await context
                                                .read<EvaluationGuruProvider>()
                                                .getPrintEvaluation(
                                                    internshipId!);

                                            if (pdfData == null ||
                                                pdfData.isEmpty) {
                                              debugPrint(
                                                  'PDF kosong untuk internship ID, coba evaluation ID');
                                              pdfData = await context
                                                  .read<
                                                      EvaluationGuruProvider>()
                                                  .getPrintEvaluation(
                                                      evaluationId!);
                                            }

                                            if (pdfData != null &&
                                                pdfData.isNotEmpty &&
                                                mounted) {
                                              // Show PDF preview dialog even with minimal data
                                              // The preview widget will handle displaying whatever data we have
                                              debugPrint(
                                                  'PDF data size: ${pdfData.length} bytes - showing preview');

                                              // Show PDF preview dialog
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PdfPreviewDialog(
                                                  pdfData: pdfData!,
                                                  title:
                                                      'Preview Evaluasi ${internshipData.student?.nama ?? ''}',
                                                  evaluationId: internshipData
                                                      .evaluation?.id,
                                                  internshipId:
                                                      internshipData.id,
                                                ),
                                              );
                                            } else {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Data PDF kosong dari server'),
                                                    backgroundColor:
                                                        Colors.orange,
                                                    duration: const Duration(
                                                        seconds: 4),
                                                  ),
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Gagal memuat PDF: $e'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } finally {
                                            if (mounted) {
                                              setState(
                                                  () => _isPrinting = false);
                                            }
                                          }
                                        },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _isPrinting
                                          ? Colors.grey
                                          : GlobalColorTheme.errorColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: _isPrinting
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const Icon(
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
    );
  }
}
