import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/admin/absents_provider.dart';

class AbesntsTablePage extends StatelessWidget {
  static const String routname = '/absents';
  const AbesntsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final absentsProvider =
        Provider.of<AbsentsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: absentsProvider.getCorporations(),
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
                Text(
                  'Data Absensi Siswa',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<AbsentsProvider?>(
                  builder: (context, provider, child) {
                    final absent = provider?.absentsModel?.data ?? [];
                    if (absent.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data absent PKL.',
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
                                    "Nama".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Hadir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Izin".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Sakit".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Alpha".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Total".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                absent.length,
                                (index) {
                                  final absentData = absent[index];
                                  final nomor = index + 1;
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(nomor.toString())),
                                      DataCell(Text(absentData.nisn ?? '-')),
                                      DataCell(Text(absentData.nama ?? '-')),
                                      DataCell(Text(absentData.absents?.hadir
                                              .toString() ??
                                          '0')),
                                      DataCell(Text(
                                          absentData.absents?.izin.toString() ??
                                              '0')),
                                      DataCell(Text(absentData.absents?.sakit
                                              .toString() ??
                                          '0')),
                                      DataCell(Text(absentData.absents?.alpha
                                              .toString() ??
                                          '0')),
                                      DataCell(Text(absentData.absents?.total
                                              .toString() ??
                                          '0')),
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
