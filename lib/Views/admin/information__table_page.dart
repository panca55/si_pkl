import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_info.dart';
import 'package:si_pkl/provider/admin/informations_provider.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class InformationTablePage extends StatefulWidget {
  const InformationTablePage({super.key});

  @override
  State<InformationTablePage> createState() => _InformationTablePageState();
}

class _InformationTablePageState extends State<InformationTablePage> {
  @override
  Widget build(BuildContext context) {
    final informationsProvider =
        Provider.of<InformationsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: informationsProvider.getInformations(),
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
                  children: [
                    Text(
                      'Data Informasi',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async{
                        await showTambahInfoPopup(
                          context: context,
                          onSubmit: (data) async {
                            await informationsProvider.addInfo(
                              data: data,
                            ).then((value){
                              // Refresh data setelah popup selesai
                              informationsProvider.getInformations();
                              // Perbarui UI
                              setState(() {});
                            });
                          },
                        );

                        // Refresh data setelah popup selesai
                        await informationsProvider.getInformations();

                        // Perbarui UI
                        setState(() {});
                      },
                      child: Icon(
                        Icons.add_comment_outlined,
                        color: Colors.indigo.shade700,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<InformationsProvider?>(
                  builder: (context, provider, child) {
                    String removeHtmlTags(String htmlString) {
                      final RegExp exp = RegExp(r"<[^>]*>",
                          multiLine: true, caseSensitive: true);
                      return htmlString.replaceAll(exp, '').trim();
                    }

                    final informasi =
                        provider?.informationsModel?.information ?? [];
                    if (informasi.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data informasi',
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
                                    "Judul".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Isi".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Tanggal Mulai".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Tanggal Berakhir".toUpperCase(),
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
                                informasi.length,
                                (index) {
                                  final informasiData = informasi[index];
                                  final nomor = index + 1;
                                  final DateTime dateMulai = DateTime.parse(
                                      informasiData.tanggalMulai!);
                                  String tanggalMulai =
                                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                          .format(dateMulai);
                                  final DateTime dateAkhir = DateTime.parse(
                                      informasiData.tanggalBerakhir!);
                                  String tanggalBerakhir =
                                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                          .format(dateAkhir);
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(nomor.toString())),
                                      DataCell(Text(informasiData.nama ?? '-')),
                                      DataCell(Text(removeHtmlTags(
                                          informasiData.isi ?? '-'))),
                                      DataCell(Text(tanggalMulai)),
                                      DataCell(Text(tanggalBerakhir)),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo.shade700,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: GlobalColorTheme
                                                      .errorColor,
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
