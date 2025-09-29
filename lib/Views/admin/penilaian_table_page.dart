import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin_sekolah/penilaian_show.dart';
import 'package:si_pkl/provider/admin/evaluations_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class PenilaianTablePage extends StatelessWidget {
  Future<void> showTanggalPenilaianDialog(BuildContext context,
      {DateTime? initialStart,
      DateTime? initialEnd,
      required Function(DateTime, DateTime) onSubmit}) async {
    DateTime? startDate = initialStart;
    DateTime? endDate = initialEnd;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(initialStart == null
                  ? 'Buat Tanggal Penilaian'
                  : 'Edit Tanggal Penilaian'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Tanggal Mulai'),
                    subtitle: Text(startDate != null
                        ? DateFormat('dd MMMM yyyy').format(startDate!)
                        : 'Pilih tanggal'),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                          if (endDate != null &&
                              endDate!.isBefore(startDate!)) {
                            endDate = null;
                          }
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Tanggal Akhir'),
                    subtitle: Text(endDate != null
                        ? DateFormat('dd MMMM yyyy').format(endDate!)
                        : 'Pilih tanggal'),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? (startDate ?? DateTime.now()),
                        firstDate: startDate ?? DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (startDate != null && endDate != null) {
                      onSubmit(startDate!, endDate!);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> postTanggalPenilaian(
      BuildContext context, DateTime startDate, DateTime endDate) async {
    final provider = Provider.of<EvaluationsProvider>(context, listen: false);
    final tokenUser = provider.authController.authToken;
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/admin/evaluation'),
        headers: {
          'Authorization': 'Bearer $tokenUser',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'start_date': DateFormat('yyyy-MM-dd').format(startDate),
          'end_date': DateFormat('yyyy-MM-dd').format(endDate),
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Tanggal penilaian berhasil dibuat/diupdate'),
            backgroundColor: Colors.green));
        await provider.getEvaluations();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Gagal membuat/ubah tanggal penilaian: ${response.body}'),
            backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

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
                Consumer<EvaluationsProvider>(
                    builder: (context, provider, child) {
                  // Gunakan evaluationDates dari provider langsung
                  final evaluationDates = provider.evaluationDates;
                  final isTanggalPenilaian = evaluationDates != null &&
                      evaluationDates.startDate != null &&
                      evaluationDates.endDate != null;
                  DateTime? tanggalMulai = evaluationDates?.startDate;
                  DateTime? tanggalAkhir = evaluationDates?.endDate;
                  debugPrint(
                      'Tanggal Penilaian Terbaru: $tanggalMulai - $tanggalAkhir');
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF233446),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                          'Tanggal Penilaian',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        if (isTanggalPenilaian &&
                            tanggalMulai != null &&
                            tanggalAkhir != null)
                          Text(
                            '${DateFormat('dd MMMM yyyy').format(tanggalMulai)} - ${DateFormat('dd MMMM yyyy').format(tanggalAkhir)}',
                            style: GoogleFonts.poppins(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold),
                          )
                        else
                          Text(
                            'Belum Diisi',
                            style: GoogleFonts.poppins(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 10),
                        if (isTanggalPenilaian)
                          GestureDetector(
                            onTap: () async {
                              await showTanggalPenilaianDialog(
                                context,
                                initialStart: tanggalMulai,
                                initialEnd: tanggalAkhir,
                                onSubmit: (start, end) async {
                                  await postTanggalPenilaian(
                                      context, start, end);
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFF233446),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white)),
                              child: Text('Edit Tanggal Penilaian',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () async {
                              await showTanggalPenilaianDialog(
                                context,
                                onSubmit: (start, end) async {
                                  await postTanggalPenilaian(
                                      context, start, end);
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFF233446),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white)),
                              child: Text('Buat Tanggal Penilaian',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                          )
                      ],
                    ),
                  );
                }),
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
