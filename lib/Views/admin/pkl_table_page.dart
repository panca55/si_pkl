import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin_sekolah/abesnts_table_page.dart';
import 'package:si_pkl/Views/pimpinan/siswa_pkl_detail.dart';
import 'package:si_pkl/provider/admin/internships_provider.dart';

class PklTablePage extends StatelessWidget {
  const PklTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pklProvider =
        Provider.of<InternshipsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: pklProvider.getInternships(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Data PKL',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.person_add_alt_rounded,
                            color: Colors.indigo.shade700,
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const AbesntsTablePage(),
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade700,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(2, 2))
                              ]),
                          child: Text('Absensi Siswa',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ))),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<InternshipsProvider?>(
                  builder: (context, provider, child) {
                    final siswa = provider?.internshipsModel?.internship ?? [];
                    if (siswa.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data siswa PKL.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
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
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              scrollDirection: Axis.horizontal,
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
                                      "jurusan".toUpperCase(),
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
                                      "nama siswa".toUpperCase(),
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
                                      "tahun ajaran".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "tanggal mulai".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "tanggal berakhir".toUpperCase(),
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
                                  siswa.length,
                                  (index) {
                                    final siswaData = siswa[index];
                                    final DateTime dateMulai =
                                        DateTime.parse(siswaData.tanggalMulai!);
                                    String tanggalMulai =
                                        DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                            .format(dateMulai);
                                    final DateTime dateBerakhir = DateTime.parse(
                                        siswaData.tanggalBerakhir!);
                                    String tanggalBerakhir =
                                        DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                            .format(dateBerakhir);
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(
                                            Text(siswaData.student?.nisn ?? '-')),
                                        DataCell(Text(siswaData.student?.mayor
                                                ?.department?.nama ??
                                            '-')),
                                        DataCell(Text(
                                            siswaData.student?.mayor?.nama ??
                                                '-')),
                                        DataCell(
                                            Text(siswaData.student?.nama ?? '-')),
                                        DataCell(
                                            Text(siswaData.teacher?.nama ?? '-')),
                                        DataCell(Text(
                                            siswaData.corporation?.nama ?? '-')),
                                        DataCell(
                                            Text(siswaData.tahunAjaran ?? '-')),
                                        DataCell(Text(tanggalMulai)),
                                        DataCell(Text(tanggalBerakhir)),
                                        DataCell(
                                          GestureDetector(
                                            onTap: () async {
                                              final siswaId = siswaData
                                                  .id; // Ambil ID siswa dari objek siswa
                                              debugPrint(
                                                  'ID yang dipilih: $siswaId');
                        
                                              // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SiswaPklDetail(
                                                    siswaId: siswaId,
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
