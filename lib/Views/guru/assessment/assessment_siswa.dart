import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_input.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_show.dart';
import 'package:si_pkl/models/guru/assessment/assessments_model.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssessmentSiswa extends StatefulWidget {
  const AssessmentSiswa({super.key});

  @override
  State<AssessmentSiswa> createState() => _AssessmentSiswaState();
}

class _AssessmentSiswaState extends State<AssessmentSiswa> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final assessmentprovider =
        Provider.of<AssessmentProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: assessmentprovider.getAssessments(),
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
          final assessment = assessmentprovider.assessmentsModel?.monitoring?.internship;
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
                      'Penilaian Monitoring',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (assessment == null || assessment.isEmpty)
                    const Center(
                      child: Text(
                        'Mengambil data siswa monitoring',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    tabelMonitoring(assessment)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container tabelMonitoring(List<Internship> assessment) {
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
                  "nama instruktur".toUpperCase(),
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
              assessment.length,
              (index) {
                final assessmentData = assessment[index];
                final nomor = index + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(nomor.toString())),
                    DataCell(Text(assessmentData.student?.nama ?? '-')),
                    DataCell(Text(
                        assessmentData.student?.mayor?.department?.nama ?? '-')),
                    DataCell(Text(assessmentData.student?.mayor?.nama ?? '-')),
                    DataCell(Text(assessmentData.corporation?.nama ?? '-')),
                    DataCell(assessmentData.instructor?.nama == null
                        ? const Text('Belum diisi')
                        : Text(assessmentData.instructor?.nama ?? '-')),
                    DataCell(Text('${assessmentData.assessment?.length}/5')),
                    DataCell(
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final internshipId = assessmentData.id;
                              debugPrint('ID yang dipilih: $internshipId');
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
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final internshipId = assessmentData.id;
                              debugPrint('ID yang dipilih: $internshipId');
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      AssessmentShow(
                                    assessmentId: internshipId!,
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
