import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/Provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_instruktur.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_instruktur.dart';
import 'package:si_pkl/provider/admin/corporations_provider.dart';
import 'package:si_pkl/provider/admin/instructors_provider.dart';
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

class InstructorsTablePage extends StatefulWidget {
  const InstructorsTablePage({super.key});

  @override
  State<InstructorsTablePage> createState() => _InstructorsTablePageState();
}

class _InstructorsTablePageState extends State<InstructorsTablePage> {
  String _searchQuery = '';
  List<dynamic> _instructorsData = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final instructorsProvider =
        Provider.of<InstructorsProvider>(context, listen: false);
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final coporateProvider =
        Provider.of<CorporationsProvider>(context, listen: false);
    await Future.wait([
      instructorsProvider.getInstructors(),
      userProvider.getUsers(),
      coporateProvider.getCorporations(),
    ]);
    setState(() {
      _instructorsData = instructorsProvider.instructorsModel?.instructor ?? [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final coporateProvider =
        Provider.of<CorporationsProvider>(context, listen: false);

    Future<void> _exportToPDF(List instructors) async {
      debugPrint('Exporting ${instructors.length} instructors to PDF');

      if (instructors.isEmpty) {
        debugPrint('No instructors data to export');
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
          'Nama Perusahaan',
          'Nama Lengkap',
          'Jenis Kelamin',
          'Tempat Lahir',
          'Tanggal Lahir',
          'Alamat',
          'No HP'
        ]
      ];

      for (int i = 0; i < instructors.length; i++) {
        final instructor = instructors[i];
        debugPrint('Processing instructor ${i + 1}: ${instructor.nama}');
        final DateTime dateLahir = DateTime.parse(instructor.tanggalLahir!);
        String tanggalLahir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateLahir);
        tableData.add([
          (i + 1).toString(),
          instructor.nip ?? '-',
          instructor.user?.email ?? '-',
          instructor.corporation?.nama ?? '-',
          instructor.nama ?? '-',
          instructor.jenisKelamin ?? '-',
          instructor.tempatLahir ?? '-',
          tanggalLahir,
          instructor.alamat ?? '-',
          instructor.hp ?? '-'
        ]);
      }

      debugPrint('Table data created with ${tableData.length} rows');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> children = [
              pw.Text('Data Instruktur',
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
        anchor.setAttribute('download', 'instructors_data.pdf');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('PDF downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/instructors_data.pdf');
        await file.writeAsBytes(bytes);
        await Share.share(file.path, subject: 'Data Instruktur Export');
        debugPrint('PDF file saved and shared');
      }
    }

    Future<void> _exportToCSV(List instructors) async {
      debugPrint('Exporting ${instructors.length} instructors to CSV');

      if (instructors.isEmpty) {
        debugPrint('No instructors data to export');
        return;
      }

      List<List<String>> csvData = [
        [
          'No',
          'NIP',
          'Email',
          'Nama Perusahaan',
          'Nama Lengkap',
          'Jenis Kelamin',
          'Tempat Lahir',
          'Tanggal Lahir',
          'Alamat',
          'No HP'
        ]
      ];

      for (int i = 0; i < instructors.length; i++) {
        final instructor = instructors[i];
        debugPrint('Instructor $i: ${instructor.nama}');
        final DateTime dateLahir = DateTime.parse(instructor.tanggalLahir!);
        String tanggalLahir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateLahir);
        csvData.add([
          (i + 1).toString(),
          instructor.nip ?? '-',
          instructor.user?.email ?? '-',
          instructor.corporation?.nama ?? '-',
          instructor.nama ?? '-',
          instructor.jenisKelamin ?? '-',
          instructor.tempatLahir ?? '-',
          tanggalLahir,
          instructor.alamat ?? '-',
          instructor.hp ?? '-'
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      debugPrint('CSV data created with ${csvData.length} rows');

      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'instructors_data.csv');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('CSV downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/instructors_data.csv');
        await file.writeAsString(csv);
        await Share.share(file.path, subject: 'Data Instruktur Export');
        debugPrint('CSV file saved and shared');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<InstructorsProvider>(
              builder: (context, instructorsProvider, _) {
                final user = userProvider.usersModel?.user?.toList();
                final perusahaan =
                    coporateProvider.corporationsModel?.corporation?.toList();
                final searchLower = _searchQuery.toLowerCase();
                final filteredInstructors = instructorsProvider
                        .instructorsModel?.instructor
                        ?.where((i) {
                      final name = (i.nama ?? '').toLowerCase();
                      final email = (i.user?.email ?? '').toLowerCase();
                      return name.contains(searchLower) ||
                          email.contains(searchLower);
                    }).toList() ??
                    [];
                void showDeleteDialog(BuildContext context, int id) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Konfirmasi"),
                        content: const Text(
                            "Apakah Anda yakin ingin menghapus data ini?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await instructorsProvider.deleteUser(id: id);
                              Navigator.pop(context);
                              await instructorsProvider.getInstructors();
                              setState(() {});
                            },
                            child: const Text("Hapus",
                                style: TextStyle(color: Colors.red)),
                          )
                        ],
                      );
                    },
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
                                  );
                                  await instructorsProvider.getInstructors();
                                  setState(() {});
                                },
                              );
                              await instructorsProvider.getInstructors();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.person_add_alt_1,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              final instructors = instructorsProvider
                                      .instructorsModel?.instructor ??
                                  [];

                              debugPrint('Export selected: $value');
                              debugPrint(
                                  'Instructors count: ${instructors.length}');

                              if (instructors.isEmpty) {
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
                                await _exportToPDF(instructors);
                              } else if (value == 'excel') {
                                await _exportToCSV(instructors);
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
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText:
                              'Cari instruktur berdasarkan nama atau email...',
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
                      const SizedBox(
                        height: 10,
                      ),
                      filteredInstructors.isEmpty
                          ? const Center(
                              child: Text(
                                'Belum ada data users',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Expanded(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
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
                                        filteredInstructors.length,
                                        (index) {
                                          final instrukturData =
                                              filteredInstructors[index];
                                          final nomor = index + 1;
                                          final DateTime dateLahir =
                                              DateTime.parse(
                                                  instrukturData.tanggalLahir!);
                                          String tanggalLahir = DateFormat(
                                                  'EEEE, dd MMMM yyyy', 'id_ID')
                                              .format(dateLahir);
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(Text(nomor.toString())),
                                              DataCell(Text(
                                                  instrukturData.user?.email ??
                                                      '-')),
                                              DataCell(Text(
                                                  instrukturData.nip ?? '-')),
                                              DataCell(Text(instrukturData
                                                      .corporation?.nama ??
                                                  '-')),
                                              DataCell(Text(
                                                  instrukturData.nama ?? '-')),
                                              DataCell(Text(
                                                  instrukturData.jenisKelamin ??
                                                      '-')),
                                              DataCell(Text(
                                                  instrukturData.tempatLahir ??
                                                      '-')),
                                              DataCell(Text(tanggalLahir)),
                                              DataCell(Text(
                                                  instrukturData.alamat ??
                                                      '-')),
                                              DataCell(Text(
                                                  instrukturData.hp ?? '-')),
                                              DataCell(Text(
                                                  instrukturData.foto ?? '-')),
                                              DataCell(
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final userModel = user
                                                            ?.firstWhere((u) =>
                                                                u.id ==
                                                                instrukturData
                                                                    .userId);
                                                        final perusahaanModel =
                                                            perusahaan?.firstWhere((u) =>
                                                                u.id ==
                                                                instrukturData
                                                                    .corporationId);
                                                        final id =
                                                            instrukturData.id;
                                                        final instructor =
                                                            filteredInstructors
                                                                .firstWhere((i) =>
                                                                    i.id ==
                                                                    instrukturData
                                                                        .id);
                                                        showEditInstrukturPopup(
                                                          user: userModel,
                                                          perusahaan:
                                                              perusahaanModel,
                                                          instructor:
                                                              instructor,
                                                          context: context,
                                                          onSubmit: (data,
                                                              fileByte,
                                                              fileName) async {
                                                            await instructorsProvider
                                                                .editInstructor(
                                                              id: id!,
                                                              data: data,
                                                              fileBytes:
                                                                  fileByte,
                                                              fileName:
                                                                  fileName,
                                                            );
                                                            await instructorsProvider
                                                                .getInstructors();
                                                            setState(() {});
                                                          },
                                                        );
                                                        await instructorsProvider
                                                            .getInstructors();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5,
                                                            horizontal: 5),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .indigo.shade700,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: const Icon(
                                                          Icons.edit_document,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        showDeleteDialog(
                                                            context,
                                                            instrukturData.id!);
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5,
                                                            horizontal: 5),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              GlobalColorTheme
                                                                  .errorColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
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
                            ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
