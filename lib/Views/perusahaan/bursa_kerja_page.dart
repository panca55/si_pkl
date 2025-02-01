import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/perusahaan/bursa_kerja_model.dart';
import 'package:si_pkl/provider/perusahaan/bursa_kerja_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BursaKerjaPage extends StatefulWidget {
  const BursaKerjaPage({super.key});

  @override
  State<BursaKerjaPage> createState() => _BursaKerjaPageState();
}

class _BursaKerjaPageState extends State<BursaKerjaPage> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final bursaKerjaProvider =
        Provider.of<BursaKerjaProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: bursaKerjaProvider.getBursaKerja(),
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
          final bursaKerja =
              bursaKerjaProvider.bursaKerjaModel?.jobs?.toList() ?? [];
          if (bursaKerjaProvider.bursaKerjaModel == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Skeletonizer(
              enabled: loading,
              enableSwitchAnimation: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Lowongan Pekerjaan',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.add,
                          color: Colors.indigo.shade700,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (bursaKerja.isEmpty)
                    const Center(
                      child: Text(
                        'Belum ada data siswa PKL.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    tabelBimbingan(bursaKerja)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container tabelBimbingan(List<Job> bursaKerja) {
    String removeHtmlTags(String htmlString) {
      final RegExp exp =
          RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '').trim();
    }

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
                  "Judul".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Deskripsi".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Jenis Pekerjaan".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Rentang Gaji".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Status".toUpperCase(),
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
              bursaKerja.length,
              (index) {
                final bursaKerjaData = bursaKerja[index];
                final nomor = index + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(nomor.toString())),
                    DataCell(Text(bursaKerjaData.judul ?? '-')),
                    DataCell(
                        Text(removeHtmlTags(bursaKerjaData.deskripsi ?? '-'))),
                    DataCell(Text(bursaKerjaData.jenisPekerjaan ?? '-')),
                    DataCell(Text(NumberFormat.currency(
                      locale: 'id_ID', // Lokasi Indonesia
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(int.parse(bursaKerjaData.rentangGaji ?? '0')))),
                    DataCell(bursaKerjaData.status == 1
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: GlobalColorTheme.successColor,
                            ),
                            child: Text(
                              'Aktf'.toUpperCase(),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ))
                        : Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: GlobalColorTheme.errorColor,
                            ),
                            child: Text(
                              'Tidak Aktf'.toUpperCase(),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ))),
                    DataCell(
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // final bimbinganId = bursaKerjaData
                              //     .id; // Ambil ID siswa dari objek siswa
                              // debugPrint('ID yang dipilih: $bimbinganId');

                              // // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         BimbinganDetail(
                              //       bimbinganId: bimbinganId,
                              //     ),
                              //   ),
                              // );
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
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // final bimbinganId = bursaKerjaData
                              //     .id; // Ambil ID siswa dari objek siswa
                              // debugPrint('ID yang dipilih: $bimbinganId');

                              // // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         BimbinganDetail(
                              //       bimbinganId: bimbinganId,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade700,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.edit_document,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // final bimbinganId = bursaKerjaData
                              //     .id; // Ambil ID siswa dari objek siswa
                              // debugPrint('ID yang dipilih: $bimbinganId');

                              // // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         BimbinganDetail(
                              //       bimbinganId: bimbinganId,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade900,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.power_settings_new_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // final bimbinganId = bursaKerjaData
                              //     .id; // Ambil ID siswa dari objek siswa
                              // debugPrint('ID yang dipilih: $bimbinganId');

                              // // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         BimbinganDetail(
                              //       bimbinganId: bimbinganId,
                              //     ),
                              //   ),
                              // );
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
                                Icons.delete,
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
