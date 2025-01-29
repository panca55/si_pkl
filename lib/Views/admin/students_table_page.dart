import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_student.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_student.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
import 'package:si_pkl/provider/admin/students_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class StudentsTablePage extends StatefulWidget {
  const StudentsTablePage({super.key});

  @override
  State<StudentsTablePage> createState() => _StudentsTablePageState();
}

class _StudentsTablePageState extends State<StudentsTablePage> {
  @override
  Widget build(BuildContext context) {
    final studentsProvider = Provider.of<StudentsProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final mayorProvider = Provider.of<MayorsProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          studentsProvider.getStudents(),
          userProvider.getUsers(),
          mayorProvider.getMayors(),
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
          final user = userProvider.usersModel?.user?.toList() ?? [];
          final kelas = mayorProvider.mayorsModel?.mayor?.toList() ?? [];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Siswa',
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
                        await showTambahStudentPopup(user: user, kelas: kelas, context: context, onSubmit: (data, fileByte, fileName)async{
                          await studentsProvider.addStudent(data: data, fileBytes:fileByte, fileName: fileName, filePath: fileName).then((value){
                            studentsProvider.getStudents();
                            setState(() {});
                            });
                        });
                        await studentsProvider.getStudents();
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
                Consumer<StudentsProvider?>(
                  builder: (context, provider, child) {
                    final student = provider?.studentsModel?.student ?? [];
                    if (student.isEmpty) {
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
                                      "nisn".toUpperCase(),
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
                                      "Jurusan".toUpperCase(),
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
                                      "Konsentrasi".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tahun Masuk".toUpperCase(),
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
                                      "Alamat Siswa".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Alamat Ortu".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "No HP Siswa".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "No HP Ortu".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Status".toUpperCase(),
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
                                      "Aksi".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  student.length,
                                  (index) {
                        
                                    final studentData = student[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(studentData.nisn ?? '-')),
                                        DataCell(Text(studentData.user?.email ?? '-')),
                                        DataCell(Text(studentData.nama ?? '-')),
                                        DataCell(Text(studentData.mayor?.department?.nama ?? '-')),
                                        DataCell(Text(studentData.mayor?.nama ?? '-')),
                                        DataCell(Text(studentData.konsentrasi ?? '-')),
                                        DataCell(Text(studentData.tahunMasuk ?? '-')),
                                        DataCell(Text(studentData.jenisKelamin ?? '-')),
                                        DataCell(Text(studentData.tempatLahir ?? '-')),
                                        DataCell(Text(studentData.tanggalLahir ?? '-')),
                                        DataCell(Text(studentData.alamatSiswa ?? '-')),
                                        DataCell(Text(studentData.alamatOrtu ?? '-')),
                                        DataCell(Text(studentData.hpSiswa ?? '-')),
                                        DataCell(Text(studentData.hpOrtu ?? '-')),
                                        DataCell(Text(studentData.statusPkl ?? '-')),
                                        DataCell(Text(studentData.foto ?? '-')),
                                        DataCell(
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final userModel =
                                                      user.firstWhere(
                                                          (u) =>
                                                              u.id ==
                                                              studentData.userId);
                                                  final studentModel =
                                                      student.firstWhere(
                                                          (u) =>
                                                              u.id ==
                                                              studentData.id);
                                                  final kelasModel = kelas.firstWhere((k)=> k.id == studentData.mayor?.id);
                                                  final id = studentData.id;
                                                  showEditStudentPopup(user: userModel, student: studentModel, listKelas: kelas, kelas: kelasModel, context: context, onSubmit: (data,fileByte, fileName)async{
                                                    await studentsProvider.editStudent(id: id!, data: data, fileBytes: fileByte, fileName: fileName).then((value){
                                                      studentsProvider.getStudents();
                                                      setState(() {});
                                                    });
                                                  });
                                                  await studentsProvider
                                                      .getStudents();
                                                  setState(() {});
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
