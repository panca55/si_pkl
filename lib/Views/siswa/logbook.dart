import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/siswa/intern_provider.dart';

class Logbook extends StatelessWidget {
  const Logbook({super.key});

  @override
  Widget build(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: internProvider.getInternSiswa(),
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
          return Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tambah Jurnal Harian',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Consumer<InternProvider>(
                    builder: (context, provider, child) {
                      final intern = provider.currentIntern;
                      if (intern == null ||
                          intern.logbook == null ||
                          intern.logbook!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'Belum ada jurnal harian yang ditambahkan.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            clipBehavior: Clip.hardEdge,
                            dataRowMinHeight: 45,
                            horizontalMargin: 30,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  "No".toUpperCase(),
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Tanggal".toUpperCase(),
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Kategori Kegiatan".toUpperCase(),
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Judul Kegiatan".toUpperCase(),
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Aksi".toUpperCase(),
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              intern.logbook!.length,
                              (index) {
                                final logbook = intern.logbook![index];
                                final DateTime tanggalDateTime =
                                    DateTime.parse(logbook.tanggal!);
                                String tanggal =
                                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(tanggalDateTime);
                                final nomor = index + 1;
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(nomor.toString())),
                                    DataCell(Text(tanggal)),
                                    DataCell(Text(logbook.category ?? '-')),
                                    DataCell(Text(logbook.judul ?? '-')),
                                    DataCell(
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFF3E1D),
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
