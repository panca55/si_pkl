import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_user.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_user_popup.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'dart:html' as html;

class UsersTablePage extends StatefulWidget {
  const UsersTablePage({super.key});

  @override
  State<UsersTablePage> createState() => _UsersTablePageState();
}

class _UsersTablePageState extends State<UsersTablePage> {
  int _rowsPerPage = 5; // Jumlah baris per halaman
  String? _selectedRole;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.getUsers();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _exportToPDF(List users) async {
    debugPrint('Exporting ${users.length} users to PDF');

    if (users.isEmpty) {
      debugPrint('No users data to export');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data untuk diekspor'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create data list explicitly
    List<List<String>> tableData = [
      ['No', 'User Name', 'Email', 'Role', 'Status']
    ];

    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      debugPrint(
          'Processing user ${i + 1}: ${user.name}, ${user.email}, ${user.role}');
      tableData.add([
        (i + 1).toString(),
        user.name ?? '-',
        user.email ?? '-',
        user.role ?? '-',
        user.isActive == 1 ? 'Aktif' : 'Tidak Aktif'
      ]);
    }

    debugPrint('Table data created with ${tableData.length} rows');

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          List<pw.Widget> children = [
            pw.Text('Data User',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
          ];

          List<pw.TableRow> tableRows = [];
          tableRows.add(pw.TableRow(
            children: tableData[0]
                .map((h) => pw.Text(h,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))
                .toList(),
          ));

          for (var row in tableData.sublist(1)) {
            tableRows.add(pw.TableRow(
              children: row.map((cell) => pw.Text(cell)).toList(),
            ));
          }

          children.add(pw.Table(
            border: pw.TableBorder.all(width: 1),
            children: tableRows,
          ));

          return pw.Column(children: children);
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    debugPrint('PDF bytes length: ${bytes.length}');

    if (kIsWeb) {
      // For web, download directly to browser
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url);
      anchor.setAttribute('download', 'users_data.pdf');
      anchor.click();
      html.Url.revokeObjectUrl(url);
      debugPrint('PDF downloaded to browser');
    } else {
      // For mobile, save to file and share
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/users_data.pdf');
      await file.writeAsBytes(bytes);
      await Share.share(file.path, subject: 'Data User Export');
      debugPrint('PDF file saved and shared');
    }
  }

  Future<void> _exportToCSV(List users) async {
    debugPrint('Exporting ${users.length} users to CSV');

    if (users.isEmpty) {
      debugPrint('No users data to export');
      return;
    }

    List<List<String>> csvData = [
      ['No', 'User Name', 'Email', 'Role', 'Status']
    ];

    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      debugPrint('User $i: ${user.name}, ${user.email}, ${user.role}');
      csvData.add([
        (i + 1).toString(),
        user.name ?? '-',
        user.email ?? '-',
        user.role ?? '-',
        user.isActive == 1 ? 'Aktif' : 'Tidak Aktif'
      ]);
    }

    String csv = const ListToCsvConverter().convert(csvData);
    debugPrint('CSV data created with ${csvData.length} rows');

    if (kIsWeb) {
      // For web, download directly to browser
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url);
      anchor.setAttribute('download', 'users_data.csv');
      anchor.click();
      html.Url.revokeObjectUrl(url);
      debugPrint('CSV downloaded to browser');
    } else {
      // For mobile, save to file and share
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/users_data.csv');
      await file.writeAsString(csv);
      await Share.share(file.path, subject: 'Data User Export');
      debugPrint('CSV file saved and shared');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                            onSubmit: (data) async {
                              await usersProvider.addUser(data: data);
                              await _fetchUsers();
                            },
                          );
                          await _fetchUsers();
                        },
                        child: Icon(
                          Icons.person_add_alt_1,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Consumer<UsersProvider>(
                        builder: (context, usersProvider, child) {
                          final allUsers = usersProvider.usersModel?.user ?? [];
                          final users = _selectedRole == null
                              ? allUsers
                              : allUsers
                                  .where((u) => u.role == _selectedRole)
                                  .toList();
                          return PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (users.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Tidak ada data untuk diekspor'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              if (value == 'pdf') {
                                await _exportToPDF(users);
                              } else if (value == 'excel') {
                                await _exportToCSV(users);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'pdf',
                                child: Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf,
                                        color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Export to PDF'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'excel',
                                child: Row(
                                  children: [
                                    Icon(Icons.table_chart,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Export to Excel'),
                                  ],
                                ),
                              ),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.file_download,
                                      color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Export',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "ROLE",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            'ADMIN',
                            'SISWA',
                            'GURU',
                            'PERUSAHAAN',
                            'INSTRUKTUR',
                            'WAKAHUMAS',
                            'WAKAKURIKULUM',
                            'KEPSEK',
                            'WAKASEK',
                            'DAPODIK'
                          ]
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
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: Colors.black,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            label: Text("Masukkan nama user atau email user"),
                            labelStyle:
                                TextStyle(color: Colors.blueGrey.shade700)),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      )),
                  const SizedBox(height: 10),
                  Consumer<UsersProvider>(
                    builder: (context, usersProvider, child) {
                      final allUsers = usersProvider.usersModel?.user ?? [];
                      final userList = _selectedRole == null
                          ? allUsers
                          : allUsers
                              .where((u) => u.role == _selectedRole)
                              .toList();
                      final searchLower = _searchQuery.toLowerCase();
                      final filteredUser = userList.where((u) {
                        final name = (u.name ?? '').toLowerCase();
                        final email = (u.email ?? '').toLowerCase();
                        return name.contains(searchLower) ||
                            email.contains(searchLower);
                      }).toList();
                      if (filteredUser.isEmpty) {
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
                                  filteredUser, context, usersProvider),
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
                Navigator.pop(context);
                // Consumer will update UI automatically
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
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
