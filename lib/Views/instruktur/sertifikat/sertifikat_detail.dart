import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/instruktur/sertifikat/sertifikat_detail_model.dart';
import 'package:si_pkl/provider/instruktur/sertifikat/sertifikat_detail_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SertifikatDetail extends StatefulWidget {
  final int id;
  const SertifikatDetail({super.key, required this.id});

  @override
  State<SertifikatDetail> createState() => _SertifikatDetailState();
}

class _SertifikatDetailState extends State<SertifikatDetail> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final sertifikatProvider =
        Provider.of<SertifikatDetailProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: sertifikatProvider.getBimbingan(widget.id),
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
          final pkl = sertifikatProvider.sertifikatDetailModel!.internship;
          final namaSiswa = pkl?.student?.nama ?? '-';
          final kompetensiSiswa = pkl?.student?.mayor?.department?.nama ?? '-';
          final namaPerusahaan = pkl?.corporation?.nama ?? '-';
          final sertifikat =
              sertifikatProvider.sertifikatDetailModel?.data?.toList() ?? [];
          if (sertifikat.isEmpty) {
            return const Center(
              child: Text('Tidak ada data sertifikat'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Skeletonizer(
              enabled: loading,
              enableSwitchAnimation: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'DAFTAR NILAI',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'PRAKTIK KERJA LAPANGAN',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nama'.toUpperCase()),
                            Text(': ${namaSiswa.toUpperCase()}'),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Kompetensi Keahlian'.toUpperCase()),
                            Text(': ${kompetensiSiswa.toUpperCase()}'),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sekolah'.toUpperCase()),
                            Text(': SMK Negeri 2 Padang'.toUpperCase()),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tempat Praktek Kerja Lapangan'.toUpperCase()),
                            Text(': ${namaPerusahaan.toUpperCase()}'),
                          ]),
                    ],
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

  Container tabelBimbingan(List<Data> sertifikat) {
    // Mengelompokkan data berdasarkan kategori
    final Map<String, List<Data>> groupedData = {};
    for (var data in sertifikat) {
      if (!groupedData.containsKey(data.category)) {
        groupedData[data.category!] = [];
      }
      groupedData[data.category!]!.add(data);
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
            headingRowColor: WidgetStatePropertyAll(Colors.amber.shade700),
            border: TableBorder.all(),
            dividerThickness: 2,
            clipBehavior: Clip.hardEdge,
            dataRowMinHeight: 45,
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  "No".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Kompetensi Penilaian".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Nilai".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
              DataColumn(
                label: Text(
                  "Predikat".toUpperCase(),
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
            ],
            rows: _generateTableRows(groupedData),
          ),
        ),
      ),
    );
  }

  List<DataRow> _generateTableRows(Map<String, List<Data>> groupedData) {
    List<DataRow> rows = [];

    for (var entry in groupedData.entries) {
      final category = entry.key;
      final categoryData = entry.value;

      // Tambahkan baris untuk kategori
      rows.add(
        DataRow(
          color: const WidgetStatePropertyAll(Colors.amber),
          cells: [
            const DataCell(Text('')), // Kolom kosong
            DataCell(
              Text(
                category.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            const DataCell(Text('')),
            const DataCell(Text('')),
          ],
        ),
      );

      // Tambahkan baris data untuk kategori ini
      rows.addAll(
        categoryData.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data.id.toString())),
              DataCell(Text(data.nama ?? '-')),
              DataCell(Text(data.score.toString())),
              DataCell(Text(data.predikat ?? '-')),
            ],
          );
        }).toList(),
      );
    }

    return rows;
  }
}
