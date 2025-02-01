import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_teacher.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_teacher.dart';
import 'package:si_pkl/provider/admin/teachers_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class TeachersTablePage extends StatefulWidget {
  const TeachersTablePage({super.key});

  @override
  State<TeachersTablePage> createState() => _TeachersTablePageState();
}

class _TeachersTablePageState extends State<TeachersTablePage> {
  @override
  Widget build(BuildContext context) {
    final teacherProvider =
        Provider.of<TeachersProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen:false);
    void showDeleteDialog(BuildContext context, int id) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  await teacherProvider.deleteUser(id: id);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  teacherProvider.getTeachers();
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          teacherProvider.getTeachers(),
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
          final users = userProvider.usersModel?.user?.toList() ?? [];
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
                          user: users,
                          context: context, 
                          onSubmit:(data, fileBytes, fileName) async{
                            await teacherProvider.addTeacher(data: data, fileBytes: fileBytes, filePath: fileName, fileName: fileName).then((value){
                              teacherProvider.getTeachers();
                              setState(() {});
                            });
                          });
                        await teacherProvider.getTeachers();
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
                                    final DateTime dateLahir = DateTime.parse(
                                        teacherData.tanggalLahir!);
                                    String tanggalLahir = DateFormat(
                                            'EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(dateLahir);
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
                                            Text(tanggalLahir)),
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
                                                  final userModel =
                                                      users.firstWhere((u) =>
                                                          u.id ==
                                                          teacherData.userId);
                                                  final id = teacherData.id;
                                                  final teachers = teacher.firstWhere((t)=> t.id == teacherData.id);  
                                                  showEditTeacherPopup(teachers: teachers, user: userModel, context: context, onSubmit: (data, fileByte, fileNeme) async{
                                                    await teacherProvider.editTeacher(id: id!, data: data, fileBytes: fileByte).then((value){
                                                      teacherProvider.getTeachers();
                                                      setState(() {});
                                                    });
                                                  });
                                                  await teacherProvider
                                                      .getTeachers();
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
                                                  showDeleteDialog(context, teacherData.id!);
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
