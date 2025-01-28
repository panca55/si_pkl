import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_corporate.dart';
import 'package:si_pkl/provider/admin/corporations_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class CorporateTablePage extends StatefulWidget {
  const CorporateTablePage({super.key});

  @override
  State<CorporateTablePage> createState() => _CorporateTablePageState();
}

class _CorporateTablePageState extends State<CorporateTablePage> {
  @override
  Widget build(BuildContext context) {
    final corporatesProvider = Provider.of<CorporationsProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          corporatesProvider.getCorporations(),
          userProvider.getUsers(),
        ]),
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
          final user = userProvider.usersModel?.user?.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Perusahaan',
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
                        showTambahPerusahaanPopup(user: user, context: context, onSubmit: (data, fileBytes, filePath) async{
                          await corporatesProvider.addCorporate(data: data, fileBytes: fileBytes)
                                  .then((value) {
                                // Refresh data setelah popup selesai
                                corporatesProvider.getCorporations();
                                // Perbarui UI
                                setState(() {});
                              });
                        });
                        // Refresh data setelah popup selesai
                        await corporatesProvider.getCorporations();
                        // Perbarui UI
                        setState(() {});
                      },
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.indigo.shade700,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<CorporationsProvider?>(
                  builder: (context, provider, child) {
                    final corporate = provider?.corporationsModel?.corporation ?? [];
                    if (corporate.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data users',
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
                                    "Email".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Nama Perusahan".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Alamat".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Kuota Siswa".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Hari Mulai Kerja".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Hari Berakhir Kerja".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Jam Mulai".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Jam Berakhir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "No HP".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Foto".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Logo".toUpperCase(),
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
                                corporate.length,
                                (index) {
                                  final corporateData = corporate[index];
                                  final nomor = index + 1;
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(nomor.toString())),
                                      DataCell(Text(corporateData.user?.email ?? '-')),
                                      DataCell(Text(corporateData.nama ?? '-')),
                                      DataCell(Text(corporateData.alamat ?? '-')),
                                      DataCell(Text(corporateData.quota?.toString() ?? '-')),
                                      DataCell(Text(corporateData.mulaiHariKerja ?? '-')),
                                      DataCell(Text(corporateData.akhirHariKerja ?? '-')),
                                      DataCell(Text(corporateData.jamMulai ?? '-')),
                                      DataCell(Text(corporateData.jamBerakhir ?? '-')),
                                      DataCell(Text(corporateData.hp ?? '-')),
                                      DataCell(Text(corporateData.foto ?? '-')),
                                      DataCell(Text(corporateData.logo ?? '-')),
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
