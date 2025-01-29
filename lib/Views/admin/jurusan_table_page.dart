import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_jurusan.dart';
import 'package:si_pkl/provider/admin/departments_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class JurusanTablePage extends StatelessWidget {
  const JurusanTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final departmentsProvider =
        Provider.of<DepartmentsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: departmentsProvider.getDepartments(),
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
                      'Data Jurusan',
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
                      onTap: () {
                        showTambahJurusanPopup(context: context, onSubmit: (nama)async{
                          await departmentsProvider.addDepartment(nama: nama);
                        });
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
                Consumer<DepartmentsProvider?>(
                  builder: (context, provider, child) {
                    final jurusan =
                        provider?.listDepartment ?? [];
                    if (jurusan.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data jurusan',
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
                                      "Nama Jurusan".toUpperCase(),
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
                                  jurusan.length,
                                  (index) {
                                    final jurusanData = jurusan[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(
                                            jurusanData.nama ?? '-')),
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
