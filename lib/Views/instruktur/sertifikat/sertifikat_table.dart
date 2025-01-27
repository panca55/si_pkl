import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/instruktur/sertifikat/sertifikat_detail.dart';
import 'package:si_pkl/Views/instruktur/sertifikat/tambah_sertifikat.dart';
import 'package:si_pkl/models/instruktur/sertifikat/sertifikat_model.dart';
import 'package:si_pkl/provider/instruktur/sertifikat/sertifikat_detail_provider.dart';
import 'package:si_pkl/provider/instruktur/sertifikat/sertifikat_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SertifikatTable extends StatefulWidget {
  const SertifikatTable({super.key});

  @override
  State<SertifikatTable> createState() => _SertifikatTableState();
}

class _SertifikatTableState extends State<SertifikatTable> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final sertifikatProvider =
        Provider.of<SertifikatProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: sertifikatProvider.getBimbingan(),
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
          final sertifikat =
              sertifikatProvider.sertifikatModel?.sertifikat?.toList() ?? [];
          if (sertifikat.isEmpty) return const SizedBox.shrink();
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
                  if (sertifikat.isEmpty)
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
                    tabelBimbingan(sertifikat)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container tabelBimbingan(List<Sertifikat> sertifikat) {
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
                  "nama guru pembimbing".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "sertifikat".toUpperCase(),
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
              sertifikat.length,
              (index) {
                final sertifikatData = sertifikat[index];
                final nomor = index + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(nomor.toString())),
                    DataCell(Text(sertifikatData.student?.nama ?? '-')),
                    DataCell(Text(
                        sertifikatData.student?.mayor?.department?.nama ??
                            '-')),
                    DataCell(Text(sertifikatData.student?.mayor?.nama ?? '-')),
                    DataCell(Text(sertifikatData.teacher?.nama ?? '-')),
                    DataCell(Text(sertifikatData.certificate != null
                        ? 'Belum diberi penilaian'
                        : 'Sudah diberi penilaian')),
                    DataCell(
                      sertifikatData.certificate == null
                          ? GestureDetector(
                              onTap: () {
                                final id = sertifikatData.id;
                                debugPrint('ID yang dipilih: $id');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        TambahSertifikat(
                                      id: id!,
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
                                    final id = sertifikatData.id;
                                    debugPrint('ID yang dipilih: $id');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            SertifikatDetail(
                                          id: id!,
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
                                  onTap: () async {
                                    final sertifikatId = sertifikatData.id;
                                    debugPrint(
                                        'ID yang dipilih: $sertifikatId');
                                    await context
                                        .read<SertifikatDetailProvider>()
                                        .getPrintSertifikat(sertifikatId!);
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
    );
  }
}
