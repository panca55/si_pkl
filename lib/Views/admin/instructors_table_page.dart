import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_instruktur.dart';
import 'package:si_pkl/provider/admin/corporations_provider.dart';
import 'package:si_pkl/provider/admin/instructors_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class InstructorsTablePage extends StatefulWidget {
  const InstructorsTablePage({super.key});

  @override
  State<InstructorsTablePage> createState() => _InstructorsTablePageState();
}

class _InstructorsTablePageState extends State<InstructorsTablePage> {
  @override
  Widget build(BuildContext context) {
    final instructorsProvider =
        Provider.of<InstructorsProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final coporateProvider =
        Provider.of<CorporationsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          instructorsProvider.getInstructors(),
          userProvider.getUsers(),
          coporateProvider.getCorporations()
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
          final perusahaan =
              coporateProvider.corporationsModel?.corporation?.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Instruktur',
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
                      onTap: () async {
                        await showTambahInstrukturPopup(
                          user: user,
                          perusahaan: perusahaan,
                          context: context,
                          onSubmit: (data, fileBytes, fileName) async {
                            await instructorsProvider.addInstruktur(
                              data: data,
                              fileBytes: fileBytes,
                              fileName: fileName,
                              filePath: fileName,
                            ).then((value){
                              // Refresh data setelah popup selesai
                              instructorsProvider.getInstructors();
                              // Perbarui UI
                              setState(() {});
                            });
                          },
                        );

                        // Refresh data setelah popup selesai
                        await instructorsProvider.getInstructors();

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
                Consumer<InstructorsProvider?>(
                  builder: (context, provider, child) {
                    final instruktur =
                        provider?.instructorsModel?.instructor ?? [];
                    if (instruktur.isEmpty) {
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
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "NIP".toUpperCase(),
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
                                      "Nama Lengkap".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Jenis Kelamin".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tempat Lahir".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tanggal Lahir".toUpperCase(),
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
                                      "aksi".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  instruktur.length,
                                  (index) {
                                    final instrukturData = instruktur[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(
                                            instrukturData.user?.email ?? '-')),
                                        DataCell(Text(instrukturData.nip ?? '-')),
                                        DataCell(Text(
                                            instrukturData.corporation?.nama ??
                                                '-')),
                                        DataCell(
                                            Text(instrukturData.nama ?? '-')),
                                        DataCell(Text(
                                            instrukturData.jenisKelamin ?? '-')),
                                        DataCell(Text(
                                            instrukturData.tempatLahir ?? '-')),
                                        DataCell(Text(
                                            instrukturData.tanggalLahir ?? '-')),
                                        DataCell(
                                            Text(instrukturData.alamat ?? '-')),
                                        DataCell(Text(instrukturData.hp ?? '-')),
                                        DataCell(
                                            Text(instrukturData.foto ?? '-')),
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
