import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/instruktur/bimbingan/bimbingan_detail.dart';
import 'package:si_pkl/models/instruktur/bimbingan/bimbingan_siswa_model.dart';
import 'package:si_pkl/provider/instruktur/bimbingan_instruktur_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BimbinganSiswa extends StatefulWidget {
  const BimbinganSiswa({super.key});

  @override
  State<BimbinganSiswa> createState() => _BimbinganSiswaState();
}

class _BimbinganSiswaState extends State<BimbinganSiswa> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final bimbinganSiswaProvider =
        Provider.of<BimbinganInstrukturProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: bimbinganSiswaProvider.getBimbingan(),
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
          final bimbingan = bimbinganSiswaProvider.bimbinganSiswaModel?.internship?.toList();
          if (bimbingan == null || bimbingan.isEmpty) return const SizedBox.shrink();
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
                      'Data PKL',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (bimbingan.isEmpty)
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
                    tabelBimbingan(bimbingan)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container tabelBimbingan(List<Internship> bimbingan) {
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
                  "keterangan absen harian".toUpperCase(),
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
              bimbingan.length,
              (index) {
                final bimbinganData = bimbingan[index];
                final nomor = index + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(nomor.toString())),
                    DataCell(Text(bimbinganData.student?.nama ?? '-')),
                    DataCell(Text(
                        bimbinganData.student?.mayor?.department?.nama ?? '-')),
                    DataCell(Text(bimbinganData.student?.mayor?.nama ?? '-')),
                    DataCell(Text(bimbinganData.corporation?.nama ?? '-')),
                    DataCell(bimbinganData.instructor?.nama == null
                        ? const Text('Belum diisi')
                        : Text(bimbinganData.instructor?.nama ?? '-')),
                    DataCell(bimbinganData.absents == null || bimbinganData.absents!.isEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: GlobalColorTheme.errorColor
                                    .withOpacity(0.15)),
                            child: Center(
                              child: Text(
                                'Belum Mengisi Absen'.toUpperCase(),
                                style: GoogleFonts.poppins(
                                    color: GlobalColorTheme.errorColor),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: GlobalColorTheme.successColor
                                    .withOpacity(0.15)),
                            child: Center(
                              child: Text(
                                bimbinganData.absents?.last.keterangan!
                                    .toUpperCase() ?? '-',
                                style: GoogleFonts.poppins(
                                    color: GlobalColorTheme.successColor),
                              ),
                            ),
                          )),
                    DataCell(
                      GestureDetector(
                        onTap: () async {
                          final bimbinganId =
                              bimbinganData.id; // Ambil ID siswa dari objek siswa
                          debugPrint('ID yang dipilih: $bimbinganId');

                          // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => BimbinganDetail(
                                bimbinganId: bimbinganId,
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
