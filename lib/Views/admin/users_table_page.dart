import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_user.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_user_popup.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class UsersTablePage extends StatefulWidget {
  const UsersTablePage({super.key});

  @override
  State<UsersTablePage> createState() => _UsersTablePageState();
}

class _UsersTablePageState extends State<UsersTablePage> {
  int _rowsPerPage = 5; // Jumlah baris per halaman
  String? _selectedRole;

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
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await showTambahUserPopup(
                          context: context,
                          onSubmit: (data) {
                            usersProvider.addUser(data: data).then((value) {
                              usersProvider.getUsers();
                              setState(() {});
                            });
                          },
                        );
                        await usersProvider.getUsers();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "ROLE",
                            border: OutlineInputBorder(),
                          ),
                          items: ['ADMIN', 'SISWA', 'GURU', 'PERUSAHAAN', 'INSTRUKTUR', 'WAKAHUMAS', 'WAKAKURIKULUM','KEPSEK', 'WAKASEK', 'DAPODIK']
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          value: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Penilaian harus dipilih';
                            }
                            return null;
                          },
                        ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer<UsersProvider?>(
                  builder: (context, provider, child) {
                    final userRole = provider?.usersModel?.user?.where((u)=> u.role == _selectedRole)
                        .toList() ?? []; 
                    final user = _selectedRole == null ? provider?.usersModel?.user ?? [] : userRole;
                    if (user.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data users',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            columns: <DataColumn>[
                              DataColumn(label: Text("No".toUpperCase())),
                              DataColumn(
                                  label: Text("User Name".toUpperCase())),
                              DataColumn(label: Text("Email".toUpperCase())),
                              DataColumn(label: Text("Role".toUpperCase())),
                              DataColumn(label: Text("Status".toUpperCase())),
                              DataColumn(label: Text("Aksi".toUpperCase())),
                            ],
                            source: _UserDataTableSource(
                                user, context, usersProvider),
                            rowsPerPage: _rowsPerPage,
                            availableRowsPerPage: const [5, 10, 20],
                            onRowsPerPageChanged: (value) {
                              setState(() {
                                _rowsPerPage = value ?? 5;
                              });
                            },
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

class _UserDataTableSource extends DataTableSource {
  final List user;
  final BuildContext context;
  final UsersProvider usersProvider;

  void _showDeleteDialog(BuildContext context, int id) {
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
                          await usersProvider.deleteUser(id: id);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          usersProvider.getUsers();
                        },
                  child:  const Text("Hapus",
                          style: TextStyle(color: Colors.red)),
                )
          ],
        );
      },
    );
  }
  _UserDataTableSource(this.user, this.context, this.usersProvider);

  @override
  DataRow? getRow(int index) {
    if (index >= user.length) return null;
    final userData = user[index];
    final nomor = index + 1;
    return DataRow(
        color: const WidgetStatePropertyAll(Colors.white),
        cells: <DataCell>[
          DataCell(Text(nomor.toString())),
          DataCell(Text(userData.name ?? '-')),
          DataCell(Text(userData.email ?? '-')),
          DataCell(Text(userData.role ?? '-')),
          DataCell(
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: userData.isActive == 1
                    ? GlobalColorTheme.successColor
                    : GlobalColorTheme.errorColor,
              ),
              child: Text(
                userData.isActive == 1
                    ? 'Aktif'.toUpperCase()
                    : 'Tidak Aktif'.toUpperCase(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          DataCell(
            Row(children: [
              GestureDetector(
                onTap: () async {
                  showEditUserPopup(
                    context: context,
                    user: userData,
                    onSubmit: (data) async {
                      await usersProvider.editUser(
                          id: userData.id!, data: data);
                      usersProvider.getUsers();
                    },
                  );
                },
                child: const Icon(Icons.edit, color: Colors.blue),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  await usersProvider.toggleActive(userId: userData.id!);
                },
                child: const Icon(Icons.power_settings_new, color: Colors.red),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  _showDeleteDialog(context, userData.id);
                },
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ]),
          ),
        ]);
  }

  @override
  int get rowCount => user.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
