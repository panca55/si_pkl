import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_teacher.dart';
import 'package:si_pkl/provider/admin/teachers_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class TeachersTablePage extends StatelessWidget {
  const TeachersTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final teacherProvider =
        Provider.of<TeachersProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: teacherProvider.getTeachers(),
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
          final teachers = teacherProvider.teachersModel?.teachers?.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Guru',
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
                        await showTambahTeacherPopup(
                          teachers: teachers, 
                          context: context, 
                          onSubmit:(data, fileBytes, fileName) {
                            teacherProvider.addTeacher(data: data, fileBytes: fileBytes, filePath: fileName, fileName: fileName);
                          },
                          );
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
                Consumer<TeachersProvider?>(
                  builder: (context, provider, child) {
                    final teacher =
                        provider?.teachersModel?.teachers ?? [];
                    if (teacher.isEmpty) {
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
                                    "nip".toUpperCase(),
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
                                    "Golongan".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Bidang Studi".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Pendidikan Terakhir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Jabatan".toUpperCase(),
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
                                teacher.length,
                                (index) {
                                  final teacherData = teacher[index];
                                  final nomor = index + 1;
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(nomor.toString())),
                                      DataCell(Text(teacherData.nip ?? '-')),
                                      DataCell(Text(
                                          teacherData.user?.email ?? '-')),
                                      DataCell(Text(teacherData.nama ?? '-')),
                                      DataCell(
                                          Text(teacherData.jenisKelamin ?? '-')),
                                      DataCell(
                                          Text(teacherData.golongan ?? '-')),
                                      DataCell(
                                          Text(teacherData.bidangStudi ?? '-')),
                                      DataCell(
                                          Text(teacherData.pendidikanTerakhir ?? '-')),
                                      DataCell(
                                          Text(teacherData.jabatan ?? '-')),
                                      DataCell(
                                          Text(teacherData.tempatLahir ?? '-')),
                                      DataCell(
                                          Text(teacherData.tanggalLahir ?? '-')),
                                      DataCell(
                                          Text(teacherData.alamat ?? '-')),
                                      DataCell(
                                          Text(teacherData.hp ?? '-')),
                                      DataCell(
                                          Text(teacherData.foto ?? '-')),
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
                                                  color: Colors.red.shade900,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .power_settings_new_sharp,
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
