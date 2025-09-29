import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/Provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_corporate.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_corporate.dart';
import 'package:si_pkl/provider/admin/corporations_provider.dart';
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

class CorporateTablePage extends StatefulWidget {
  const CorporateTablePage({super.key});

  @override
  State<CorporateTablePage> createState() => _CorporateTablePageState();
}

class _CorporateTablePageState extends State<CorporateTablePage> {
  @override
  Widget build(BuildContext context) {
    final corporatesProvider =
        Provider.of<CorporationsProvider>(context, listen: false);
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
                  await corporatesProvider.deleteUser(id: id);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  corporatesProvider.getCorporations();
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
      );
    }

    Future<void> _exportToPDF(List corporations) async {
      debugPrint('Exporting ${corporations.length} corporations to PDF');

      if (corporations.isEmpty) {
        debugPrint('No corporations data to export');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada data untuk diekspor'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      List<List<String>> tableData = [
        ['No', 'Nama Perusahaan', 'Alamat', 'No HP', 'Email']
      ];

      for (int i = 0; i < corporations.length; i++) {
        final corporation = corporations[i];
        debugPrint('Processing corporation ${i + 1}: ${corporation.nama}');
        tableData.add([
          (i + 1).toString(),
          corporation.nama ?? '-',
          corporation.alamat ?? '-',
          corporation.hp ?? '-',
          corporation.user?.email ?? '-'
        ]);
      }

      debugPrint('Table data created with ${tableData.length} rows');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> children = [
              pw.Text('Data Corporate',
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
                        pw.Text(cell, style: pw.TextStyle(fontSize: 8)))
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
        anchor.setAttribute('download', 'corporate_data.pdf');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('PDF downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/corporate_data.pdf');
        await file.writeAsBytes(bytes);
        await Share.share(file.path, subject: 'Data Corporate Export');
        debugPrint('PDF file saved and shared');
      }
    }

    Future<void> _exportToCSV(List corporations) async {
      debugPrint('Exporting ${corporations.length} corporations to CSV');

      if (corporations.isEmpty) {
        debugPrint('No corporations data to export');
        return;
      }

      List<List<String>> csvData = [
        ['No', 'Nama Perusahaan', 'Alamat', 'No HP', 'Email']
      ];

      for (int i = 0; i < corporations.length; i++) {
        final corporation = corporations[i];
        debugPrint('Corporation $i: ${corporation.nama}');
        csvData.add([
          (i + 1).toString(),
          corporation.nama ?? '-',
          corporation.alamat ?? '-',
          corporation.hp ?? '-',
          corporation.user?.email ?? '-'
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      debugPrint('CSV data created with ${csvData.length} rows');

      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'corporate_data.csv');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('CSV downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/corporate_data.csv');
        await file.writeAsString(csv);
        await Share.share(file.path, subject: 'Data Corporate Export');
        debugPrint('CSV file saved and shared');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          corporatesProvider.getCorporations(),
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
          final user = userProvider.usersModel?.user?.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Perusahaan',
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
                        showTambahPerusahaanPopup(
                            user: user,
                            context: context,
                            onSubmit: (data, fileBytes, filePath) async {
                              await corporatesProvider
                                  .addCorporate(
                                      data: data, fileBytes: fileBytes)
                                  .then((value) {
                                // Refresh data setelah popup selesai
                                corporatesProvider.getCorporations();
                                // Perbarui UI
                                setState(() {});
                              });
                            });
                        // Refresh data setelah popup selesai
                        await corporatesProvider.getCorporations();
                        // Perbarui UI
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
                        final corporations =
                            corporatesProvider.corporationsModel?.corporation ??
                                [];

                        debugPrint('Export selected: $value');
                        debugPrint(
                            'Corporations count: ${corporations.length}');

                        if (corporations.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak ada data untuk diekspor'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        if (value == 'pdf') {
                          await _exportToPDF(corporations);
                        } else if (value == 'excel') {
                          await _exportToCSV(corporations);
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
                Consumer<CorporationsProvider?>(
                  builder: (context, provider, child) {
                    final corporate =
                        provider?.corporationsModel?.corporation ?? [];
                    if (corporate.isEmpty) {
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
                                      "Alamat".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Kuota Siswa".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Hari Mulai Kerja".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Hari Berakhir Kerja".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Jam Mulai".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Jam Berakhir".toUpperCase(),
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
                                      "Logo".toUpperCase(),
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
                                  corporate.length,
                                  (index) {
                                    final corporateData = corporate[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(
                                            corporateData.user?.email ?? '-')),
                                        DataCell(
                                            Text(corporateData.nama ?? '-')),
                                        DataCell(
                                            Text(corporateData.alamat ?? '-')),
                                        DataCell(Text(
                                            corporateData.quota?.toString() ??
                                                '-')),
                                        DataCell(Text(
                                            corporateData.mulaiHariKerja ??
                                                '-')),
                                        DataCell(Text(
                                            corporateData.akhirHariKerja ??
                                                '-')),
                                        DataCell(Text(
                                            corporateData.jamMulai ?? '-')),
                                        DataCell(Text(
                                            corporateData.jamBerakhir ?? '-')),
                                        DataCell(Text(corporateData.hp ?? '-')),
                                        DataCell(
                                            Text(corporateData.foto ?? '-')),
                                        DataCell(
                                            Text(corporateData.logo ?? '-')),
                                        DataCell(
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final userModel =
                                                      user?.firstWhere((u) =>
                                                          u.id ==
                                                          corporateData.userId);
                                                  final perusahaan = corporate
                                                      .firstWhere((u) =>
                                                          u.id ==
                                                          corporateData.id);
                                                  final id = corporateData.id;
                                                  showEditPerusahaanPopup(
                                                      user: userModel,
                                                      perusahaan: perusahaan,
                                                      context: context,
                                                      onSubmit: (data, fileByte,
                                                          fileName) async {
                                                        await corporatesProvider
                                                            .editCorporate(
                                                                id: id!,
                                                                data: data,
                                                                fileBytes:
                                                                    fileByte,
                                                                fileName:
                                                                    fileName)
                                                            .then((value) {
                                                          corporatesProvider
                                                              .getCorporations();
                                                          setState(() {});
                                                        });
                                                      });
                                                  await corporatesProvider
                                                      .getCorporations();
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
                                                  showDeleteDialog(context,
                                                      corporateData.id!);
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
