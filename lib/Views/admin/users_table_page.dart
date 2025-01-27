import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_user_popup.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class UsersTablePage extends StatelessWidget {
  const UsersTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersProvider.getUsers(),
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
                      'Data User',
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
                        await showTambahUserPopup(
                          context: context,
                          onSubmit: (data) {
                            usersProvider.addUser(data: data);
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
                Consumer<UsersProvider?>(
                  builder: (context, provider, child) {
                    final user = provider?.usersModel?.user ?? [];
                    if (user.isEmpty) {
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
                                      "User Name".toUpperCase(),
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
                                      "Role".toUpperCase(),
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
                                      "aksi".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  user.length,
                                  (index) {
                                    final userData = user[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(userData.name ?? '-')),
                                        DataCell(Text(userData.email ?? '-')),
                                        DataCell(Text(userData.role ?? '-')),
                                        DataCell(Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: userData.isActive == 1
                                                    ? GlobalColorTheme
                                                        .successColor
                                                    : GlobalColorTheme
                                                        .errorColor),
                                            child: Text(
                                              userData.isActive == 1
                                                  ? 'Aktif'.toUpperCase()
                                                  : 'Tidak Aktif'.toUpperCase(),
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ))),
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
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.indigo.shade700,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                  await context
                                                      .read<
                                                          UsersProvider>()
                                                      .toggleActive(
                                                          userId: userData.id!);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade900,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: GlobalColorTheme
                                                        .errorColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
