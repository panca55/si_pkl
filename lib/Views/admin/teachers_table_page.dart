import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_teacher.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_teacher.dart';
import 'package:si_pkl/models/admin/teachers_model.dart';
import 'package:si_pkl/models/admin/users_model.dart';
import 'package:si_pkl/provider/admin/teachers_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class TeachersTablePage extends StatefulWidget {
  const TeachersTablePage({super.key});

  @override
  State<TeachersTablePage> createState() => _TeachersTablePageState();
}

class _TeachersTablePageState extends State<TeachersTablePage> {
  String _searchQuery = '';
  bool _isLoading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final teacherProvider =
        Provider.of<TeachersProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
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

    Future<void> _exportToPDF(List teachers) async {
      debugPrint('Exporting ${teachers.length} teachers to PDF');

      if (teachers.isEmpty) {
        debugPrint('No teachers data to export');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada data untuk diekspor'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      List<List<String>> tableData = [
        [
          'No',
          'NIP',
          'Email',
          'Nama Lengkap',
          'Jenis Kelamin',
          'Golongan',
          'Bidang Studi',
          'Pendidikan Terakhir',
          'Jabatan',
          'Tempat Lahir',
          'Tanggal Lahir',
          'Alamat',
          'No HP'
        ]
      ];

      for (int i = 0; i < teachers.length; i++) {
        final teacher = teachers[i];
        debugPrint('Processing teacher ${i + 1}: ${teacher.nama}');
        final DateTime dateLahir = DateTime.parse(teacher.tanggalLahir!);
        String tanggalLahir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateLahir);
        tableData.add([
          (i + 1).toString(),
          teacher.nip ?? '-',
          teacher.user?.email ?? '-',
          teacher.nama ?? '-',
          teacher.jenisKelamin ?? '-',
          teacher.golongan ?? '-',
          teacher.bidangStudi ?? '-',
          teacher.pendidikanTerakhir ?? '-',
          teacher.jabatan ?? '-',
          teacher.tempatLahir ?? '-',
          tanggalLahir,
          teacher.alamat ?? '-',
          teacher.hp ?? '-'
        ]);
      }

      debugPrint('Table data created with ${tableData.length} rows');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> children = [
              pw.Text('Data Guru',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
            ];

            List<pw.TableRow> tableRows = [];
            tableRows.add(pw.TableRow(
              children: tableData[0]
                  .map((h) => pw.Text(h,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 8)))
                  .toList(),
            ));

            for (var row in tableData.sublist(1)) {
              tableRows.add(pw.TableRow(
                children: row
                    .map((cell) =>
                        pw.Text(cell, style: pw.TextStyle(fontSize: 6)))
                    .toList(),
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
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'teachers_data.pdf');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('PDF downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/teachers_data.pdf');
        await file.writeAsBytes(bytes);
        await Share.share(file.path, subject: 'Data Guru Export');
        debugPrint('PDF file saved and shared');
      }
    }

    Future<void> _exportToCSV(List teachers) async {
      debugPrint('Exporting ${teachers.length} teachers to CSV');

      if (teachers.isEmpty) {
        debugPrint('No teachers data to export');
        return;
      }

      List<List<String>> csvData = [
        [
          'No',
          'NIP',
          'Email',
          'Nama Lengkap',
          'Jenis Kelamin',
          'Golongan',
          'Bidang Studi',
          'Pendidikan Terakhir',
          'Jabatan',
          'Tempat Lahir',
          'Tanggal Lahir',
          'Alamat',
          'No HP'
        ]
      ];

      for (int i = 0; i < teachers.length; i++) {
        final teacher = teachers[i];
        debugPrint('Teacher $i: ${teacher.nama}');
        final DateTime dateLahir = DateTime.parse(teacher.tanggalLahir!);
        String tanggalLahir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateLahir);
        csvData.add([
          (i + 1).toString(),
          teacher.nip ?? '-',
          teacher.user?.email ?? '-',
          teacher.nama ?? '-',
          teacher.jenisKelamin ?? '-',
          teacher.golongan ?? '-',
          teacher.bidangStudi ?? '-',
          teacher.pendidikanTerakhir ?? '-',
          teacher.jabatan ?? '-',
          teacher.tempatLahir ?? '-',
          tanggalLahir,
          teacher.alamat ?? '-',
          teacher.hp ?? '-'
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      debugPrint('CSV data created with ${csvData.length} rows');

      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'teachers_data.csv');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('CSV downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/teachers_data.csv');
        await file.writeAsString(csv);
        await Share.share(file.path, subject: 'Data Guru Export');
        debugPrint('CSV file saved and shared');
      }
    }

    // Fetch teachers and users once when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isLoading) {
        try {
          await Future.wait([
            teacherProvider.getTeachers(),
            userProvider.getUsers(),
          ]);
          setState(() {
            _isLoading = false;
            _error = null;
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
            _error = e.toString();
          });
        }
      }
    });

    return Consumer<TeachersProvider>(
      builder: (context, teacherProvider, child) {
        final users = userProvider.usersModel?.user?.toList() ?? [];
        final filteredTeachers = _searchQuery.isEmpty
            ? (teacherProvider.teachersModel?.teachers ?? [])
            : (teacherProvider.teachersModel?.teachers ?? [])
                .where((t) =>
                    (t.nama ?? '')
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    (t.user?.email ?? '')
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                .toList();

        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
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
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await showTambahTeacherPopup(
                            user: users,
                            context: context,
                            onSubmit: (data, fileBytes, fileName) async {
                              await teacherProvider
                                  .addTeacher(
                                      data: data,
                                      fileBytes: fileBytes,
                                      filePath: fileName,
                                      fileName: fileName)
                                  .then((value) async {
                                await teacherProvider.getTeachers();
                              });
                            });
                      },
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        final teachers = filteredTeachers;
                        debugPrint('Export selected: $value');
                        debugPrint('Teachers count: ${teachers.length}');
                        if (teachers.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak ada data untuk diekspor'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        if (value == 'pdf') {
                          await _exportToPDF(teachers);
                        } else if (value == 'excel') {
                          await _exportToCSV(teachers);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'pdf',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Export to PDF'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'excel',
                          child: Row(
                            children: [
                              Icon(Icons.table_chart, color: Colors.green),
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
                            Icon(Icons.file_download, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Export',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari guru berdasarkan nama atau email...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_error != null)
                  Center(
                    child: Text(
                      'Terjadi kesalahan: ${_error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else if (filteredTeachers.isEmpty)
                  const Center(
                    child: Text(
                      'Belum ada data users',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                else
                  Expanded(
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
                                label: Text("No".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("nip".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Email".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Nama Lengkap".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Jenis Kelamin".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Golongan".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Bidang Studi".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Pendidikan Terakhir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Jabatan".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Tempat Lahir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Tanggal Lahir".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Alamat".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("No HP".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("Foto".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                              DataColumn(
                                label: Text("aksi".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black)),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              filteredTeachers.length,
                              (index) {
                                final teacherData = filteredTeachers[index];
                                final nomor = index + 1;
                                final DateTime dateLahir =
                                    DateTime.parse(teacherData.tanggalLahir!);
                                String tanggalLahir =
                                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(dateLahir);
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(nomor.toString())),
                                    DataCell(Text(teacherData.nip ?? '-')),
                                    DataCell(
                                        Text(teacherData.user?.email ?? '-')),
                                    DataCell(Text(teacherData.nama ?? '-')),
                                    DataCell(
                                        Text(teacherData.jenisKelamin ?? '-')),
                                    DataCell(Text(teacherData.golongan ?? '-')),
                                    DataCell(
                                        Text(teacherData.bidangStudi ?? '-')),
                                    DataCell(Text(
                                        teacherData.pendidikanTerakhir ?? '-')),
                                    DataCell(Text(teacherData.jabatan ?? '-')),
                                    DataCell(
                                        Text(teacherData.tempatLahir ?? '-')),
                                    DataCell(Text(tanggalLahir)),
                                    DataCell(Text(teacherData.alamat ?? '-')),
                                    DataCell(Text(teacherData.hp ?? '-')),
                                    DataCell(Text(teacherData.foto ?? '-')),
                                    DataCell(Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final id = teacherData.id;
                                            debugPrint('Edit teacher ID: $id');
                                            debugPrint(
                                                'userId: ${teacherData.userId}');
                                            final teacherModel =
                                                filteredTeachers.firstWhere(
                                              (t) => t.id == id,
                                              orElse: () => throw Exception(
                                                  'Teacher ID: $id not found'),
                                            );
                                            final userModel = users.firstWhere(
                                                (u) =>
                                                    u.id == teacherModel.userId,
                                                orElse: () => throw Exception(
                                                    'Userid: ${teacherModel.userId} not found'));
                                            showEditTeacherPopup(
                                                teachers: teacherModel,
                                                user: userModel,
                                                context: context,
                                                onSubmit: (data, fileByte,
                                                    fileNeme) async {
                                                  await teacherProvider
                                                      .editTeacher(
                                                          id: id!,
                                                          data: data,
                                                          fileBytes: fileByte,
                                                          fileName: fileNeme);
                                                  await teacherProvider
                                                      .getTeachers();
                                                });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.indigo.shade700,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                                Icons.edit_document,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () async {
                                            showDeleteDialog(
                                                context, teacherData.id!);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  GlobalColorTheme.errorColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
