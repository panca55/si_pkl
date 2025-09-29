import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_student.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_student.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
import 'package:si_pkl/provider/admin/students_provider.dart';
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

class StudentsTablePage extends StatefulWidget {
  const StudentsTablePage({super.key});

  @override
  State<StudentsTablePage> createState() => _StudentsTablePageState();
}

class _StudentsTablePageState extends State<StudentsTablePage> {
  String? _searchQuery;
  List<dynamic> _allStudents = [];
  bool _isLoading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final studentsProvider =
        Provider.of<StudentsProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final mayorProvider = Provider.of<MayorsProvider>(context, listen: false);
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
                  await studentsProvider.deleteUser(id: id);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  studentsProvider.getStudents();
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
      );
    }

    Future<void> _exportToPDF(List? students) async {
      debugPrint('Exporting ${students?.length} students to PDF');

      if ((students ?? []).isEmpty) {
        debugPrint('No students data to export');
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
          'NISN',
          'Email',
          'Nama Lengkap',
          'Jurusan',
          'Kelas',
          'Konsentrasi',
          'Tahun Masuk',
          'Jenis Kelamin',
          'Tempat Lahir',
          'Tanggal Lahir',
          'Alamat Siswa',
          'Alamat Ortu',
          'No HP Siswa',
          'No HP Ortu'
        ]
      ];

      for (int i = 0; i < students!.length; i++) {
        final student = students[i];
        debugPrint('Processing student ${i + 1}: ${student.nama}');
        String tanggalLahir = '-';
        if (student.tanggalLahir != null && student.tanggalLahir!.isNotEmpty) {
          try {
            final dateLahir = DateTime.parse(student.tanggalLahir!);
            tanggalLahir =
                DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateLahir);
          } catch (_) {
            tanggalLahir = '-';
          }
        }
        tableData.add([
          (i + 1).toString(),
          student.nisn ?? '-',
          student.user?.email ?? '-',
          student.nama ?? '-',
          student.mayor?.department?.nama ?? '-',
          student.mayor?.nama ?? '-',
          student.konsentrasi ?? '-',
          student.tahunMasuk ?? '-',
          student.jenisKelamin ?? '-',
          student.tempatLahir ?? '-',
          tanggalLahir,
          student.alamatSiswa ?? '-',
          student.alamatOrtu ?? '-',
          student.hpSiswa ?? '-',
          student.hpOrtu ?? '-',
        ]);

      }

      debugPrint('Table data created with ${tableData.length} rows');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> children = [
              pw.Text('Data Siswa',
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
        anchor.setAttribute('download', 'students_data.pdf');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('PDF downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/students_data.pdf');
        await file.writeAsBytes(bytes);
        await Share.share(file.path, subject: 'Data Siswa Export');
        debugPrint('PDF file saved and shared');
      }
    }

    Future<void> _exportToCSV(List students) async {
      debugPrint('Exporting ${students.length} students to CSV');

      if (students.isEmpty) {
        debugPrint('No students data to export');
        return;
      }

      List<List<String>> csvData = [
        [
          'No',
          'NISN',
          'Email',
          'Nama Lengkap',
          'Jurusan',
          'Kelas',
          'Konsentrasi',
          'Tahun Masuk',
          'Jenis Kelamin',
          'Tempat Lahir',
          'Tanggal Lahir',
          'Alamat Siswa',
          'Alamat Ortu',
          'No HP Siswa',
          'No HP Ortu'
        ]
      ];

      for (int i = 0; i < students.length; i++) {
        final student = students[i];
        debugPrint('Student $i: ${student.nama}');
        final DateTime dateLahir = DateTime.parse(student.tanggalLahir!);
        String tanggalLahir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateLahir);
        csvData.add([
          (i + 1).toString(),
          student.nisn ?? '-',
          student.user?.email ?? '-',
          student.nama ?? '-',
          student.mayor?.department?.nama ?? '-',
          student.mayor?.nama ?? '-',
          student.konsentrasi ?? '-',
          student.tahunMasuk ?? '-',
          student.jenisKelamin ?? '-',
          student.tempatLahir ?? '-',
          tanggalLahir,
          student.alamatSiswa ?? '-',
          student.alamatOrtu ?? '-',
          student.hpSiswa ?? '-',
          student.hpOrtu ?? '-'
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      debugPrint('CSV data created with ${csvData.length} rows');

      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'students_data.csv');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('CSV downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/students_data.csv');
        await file.writeAsString(csv);
        await Share.share(file.path, subject: 'Data Siswa Export');
        debugPrint('CSV file saved and shared');
      }
    }

    // Fetch students, users, and mayors once when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isLoading) {
        try {
          await Future.wait([
            studentsProvider.getStudents(),
            userProvider.getUsers(),
            mayorProvider.getMayors(),
          ]);
          setState(() {
            _allStudents = studentsProvider.studentsModel?.student ?? [];
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

    final user = userProvider.usersModel?.user?.toList() ?? [];
    final kelas = mayorProvider.mayorsModel?.mayor?.toList() ?? [];
    final search = _searchQuery?.toLowerCase() ?? '';
    final filteredStudents = search.isEmpty
        ? _allStudents
        : _allStudents.where((s) {
            if (s == null) return false;

            final nama = (s.nama ?? '').toLowerCase();
            final nisn = s.nisn ?? '';
            final email = (s.user?.email ?? '').toLowerCase();

            return nama.contains(search) ||
                nisn.contains(search) ||
                email.contains(search);
          }).toList();


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
                  'Data Siswa',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    await showTambahStudentPopup(
                        user: user,
                        kelas: kelas,
                        context: context,
                        onSubmit: (data, fileByte, fileName) async {
                          await studentsProvider
                              .addStudent(
                                  data: data,
                                  fileBytes: fileByte,
                                  fileName: fileName,
                                  filePath: fileName)
                              .then((value) async {
                            await studentsProvider.getStudents();
                            setState(() {
                              _allStudents =
                                  studentsProvider.studentsModel?.student ?? [];
                            });
                          });
                        });
                    await studentsProvider.getStudents();
                    setState(() {
                      _allStudents =
                          studentsProvider.studentsModel?.student ?? [];
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
                    final students = _allStudents;
                    debugPrint('Export selected: $value');
                    debugPrint('Students count: ${students.length}');
                    if (students.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak ada data untuk diekspor'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    if (value == 'pdf') {
                      await _exportToPDF(students);
                    } else if (value == 'excel') {
                      await _exportToCSV(students);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                hintText: 'Cari siswa berdasarkan nama, NISN, atau email...',
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
                  'Terjadi kesalahan: Ѱ${_error}',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (filteredStudents.isEmpty)
              const Center(
                child: Text(
                  'Belum ada data users',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("nisn".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Email".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Nama Lengkap".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Jurusan".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("kelas".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Konsentrasi".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Tahun Masuk".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Jenis Kelamin".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Tempat Lahir".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Tanggal Lahir".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Alamat Siswa".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Alamat Ortu".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("No HP Siswa".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("No HP Ortu".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Status".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Foto".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                          DataColumn(
                            label: Text("Aksi".toUpperCase(),
                                style:
                                    GoogleFonts.poppins(color: Colors.black)),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          filteredStudents.length,
                          (index) {
                            final studentData = filteredStudents[index];
                            final nomor = index + 1;
                            String tanggalLahir = '-';
                            if (studentData.tanggalLahir != null &&
                                studentData.tanggalLahir!.isNotEmpty) {
                              try {
                                final dateLahir =
                                    DateTime.parse(studentData.tanggalLahir!);
                                tanggalLahir =
                                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(dateLahir);
                              } catch (_) {
                                tanggalLahir = '-';
                              }
                            }
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(nomor.toString())),
                                DataCell(Text(studentData.nisn ?? '-')),
                                DataCell(Text(studentData.user?.email ?? '-')),
                                DataCell(Text(studentData.nama ?? '-')),
                                DataCell(Text(
                                    studentData.mayor?.department?.nama ??
                                        '-')),
                                DataCell(Text(studentData.mayor?.nama ?? '-')),
                                DataCell(Text(studentData.konsentrasi ?? '-')),
                                DataCell(Text(studentData.tahunMasuk ?? '-')),
                                DataCell(Text(studentData.jenisKelamin ?? '-')),
                                DataCell(Text(studentData.tempatLahir ?? '-')),
                                DataCell(Text(tanggalLahir)),
                                DataCell(Text(studentData.alamatSiswa ?? '-')),
                                DataCell(Text(studentData.alamatOrtu ?? '-')),
                                DataCell(Text(studentData.hpSiswa ?? '-')),
                                DataCell(Text(studentData.hpOrtu ?? '-')),
                                DataCell(Text(studentData.statusPkl ?? '-')),
                                DataCell(Text(studentData.foto ?? '-')),
                                DataCell(Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final userModel = user.firstWhere(
                                            (u) => u.id == studentData.userId);
                                        final studentModel =
                                            filteredStudents.firstWhere(
                                                (u) => u.id == studentData.id);
                                        final kelasModel = kelas.firstWhere(
                                            (k) =>
                                                k.id == studentData.mayor?.id);
                                        final id = studentData.id;
                                        showEditStudentPopup(
                                            user: userModel,
                                            student: studentModel,
                                            listKelas: kelas,
                                            kelas: kelasModel,
                                            context: context,
                                            onSubmit: (data, fileByte,
                                                fileName) async {
                                              await studentsProvider
                                                  .editStudent(
                                                      id: id!,
                                                      data: data,
                                                      fileBytes: fileByte,
                                                      fileName: fileName)
                                                  .then((value) async {
                                                await studentsProvider
                                                    .getStudents();
                                                setState(() {
                                                  _allStudents =
                                                      studentsProvider
                                                              .studentsModel
                                                              ?.student ??
                                                          [];
                                                });
                                              });
                                            });
                                        await studentsProvider.getStudents();
                                        setState(() {
                                          _allStudents = studentsProvider
                                                  .studentsModel?.student ??
                                              [];
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
                                        child: const Icon(Icons.edit_document,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        showDeleteDialog(
                                            context, studentData.id!);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: GlobalColorTheme.errorColor,
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
  }
}
