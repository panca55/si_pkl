import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_kelas.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_kelas.dart';
import 'package:si_pkl/provider/admin/departments_provider.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
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

class KelasTablePage extends StatefulWidget {
  const KelasTablePage({super.key});

  @override
  State<KelasTablePage> createState() => _KelasTablePageState();
}

class _KelasTablePageState extends State<KelasTablePage> {
  @override
  Widget build(BuildContext context) {
    final mayorsProvider = Provider.of<MayorsProvider>(context, listen: false);
    final departmentsProvider =
        Provider.of<DepartmentsProvider>(context, listen: false);
    // showDeleteDialog akan dipanggil di dalam Consumer agar update realtime

    Future<void> _exportToPDF(List mayors) async {
      debugPrint('Exporting ${mayors.length} mayors to PDF');

      if (mayors.isEmpty) {
        debugPrint('No mayors data to export');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada data untuk diekspor'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      List<List<String>> tableData = [
        ['No', 'Nama Jurusan', 'Nama Kelas']
      ];

      for (int i = 0; i < mayors.length; i++) {
        final mayor = mayors[i];
        debugPrint('Processing mayor ${i + 1}: ${mayor.nama}');
        tableData.add([
          (i + 1).toString(),
          mayor.department?.nama ?? '-',
          mayor.nama ?? '-'
        ]);
      }

      debugPrint('Table data created with ${tableData.length} rows');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> children = [
              pw.Text('Data Kelas',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
            ];

            List<pw.TableRow> tableRows = [];
            tableRows.add(pw.TableRow(
              children: tableData[0]
                  .map((h) => pw.Text(h,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)))
                  .toList(),
            ));

            for (var row in tableData.sublist(1)) {
              tableRows.add(pw.TableRow(
                children: row
                    .map((cell) =>
                        pw.Text(cell, style: pw.TextStyle(fontSize: 10)))
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
        anchor.setAttribute('download', 'kelas_data.pdf');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('PDF downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/kelas_data.pdf');
        await file.writeAsBytes(bytes);
        await Share.share(file.path, subject: 'Data Kelas Export');
        debugPrint('PDF file saved and shared');
      }
    }

    Future<void> _exportToCSV(List mayors) async {
      debugPrint('Exporting ${mayors.length} mayors to CSV');

      if (mayors.isEmpty) {
        debugPrint('No mayors data to export');
        return;
      }

      List<List<String>> csvData = [
        ['No', 'Nama Jurusan', 'Nama Kelas']
      ];

      for (int i = 0; i < mayors.length; i++) {
        final mayor = mayors[i];
        debugPrint('Mayor $i: ${mayor.nama}');
        csvData.add([
          (i + 1).toString(),
          mayor.department?.nama ?? '-',
          mayor.nama ?? '-'
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      debugPrint('CSV data created with ${csvData.length} rows');

      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'kelas_data.csv');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('CSV downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/kelas_data.csv');
        await file.writeAsString(csv);
        await Share.share(file.path, subject: 'Data Kelas Export');
        debugPrint('CSV file saved and shared');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          mayorsProvider.getMayors(),
          departmentsProvider.getDepartments(),
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
          final department =
              departmentsProvider.departmentsModel?.department?.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Kelas',
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
                        showTambahKelasPopup(
                            department: department,
                            context: context,
                            onSubmit: (data) async {
                              await mayorsProvider
                                  .addMayor(data: data)
                                  .then((value) {
                                mayorsProvider.getMayors();
                                setState(() {});
                              });
                            });
                        await mayorsProvider.getMayors();
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
                        final mayors = mayorsProvider.mayorsModel?.mayor ?? [];

                        debugPrint('Export selected: $value');
                        debugPrint('Mayors count: ${mayors.length}');

                        if (mayors.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak ada data untuk diekspor'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        if (value == 'pdf') {
                          await _exportToPDF(mayors);
                        } else if (value == 'excel') {
                          await _exportToCSV(mayors);
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
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<MayorsProvider?>(
                  builder: (context, provider, child) {
                    final kelas = provider?.mayorsModel?.mayor ?? [];
                    if (kelas.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data kelas',
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
                                      "Nama Kelas".toUpperCase(),
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
                                  kelas.length,
                                  (index) {
                                    final kelasData = kelas[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(kelasData.nama ?? '-')),
                                        DataCell(Text(
                                            kelasData.department?.nama ?? '-')),
                                        DataCell(
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final mayor =
                                                      kelas.firstWhere((k) =>
                                                          k.id == kelasData.id);
                                                  final id = kelasData.id;
                                                  showEditKelasPopup(
                                                      department: department,
                                                      mayor: mayor,
                                                      context: context,
                                                      onSubmit: (data) async {
                                                        mayorsProvider
                                                            .editKelas(
                                                                id: id!,
                                                                data: data)
                                                            .then((value) {
                                                          mayorsProvider
                                                              .getMayors();
                                                          setState(() {});
                                                        });
                                                      });
                                                  await mayorsProvider
                                                      .getMayors();
                                                  setState(() {});
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
                                                  // panggil showDeleteDialog lokal
                                                  final showDelete =
                                                      (BuildContext ctx,
                                                          int id) {
                                                    showDialog(
                                                      context: ctx,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Konfirmasi"),
                                                          content: const Text(
                                                              "Apakah Anda yakin ingin menghapus data ini?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: const Text(
                                                                  "Batal"),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await provider
                                                                    ?.deleteUser(
                                                                        id: id);
                                                                Navigator.pop(
                                                                    context);
                                                                await provider
                                                                    ?.getMayors();
                                                              },
                                                              child: const Text(
                                                                  "Hapus",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  };
                                                  showDelete(
                                                      context, kelasData.id!);
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
