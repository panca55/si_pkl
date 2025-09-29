import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_info.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_info.dart';
import 'package:si_pkl/provider/admin/informations_provider.dart';
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

class InformationTablePage extends StatefulWidget {
  const InformationTablePage({super.key});

  @override
  State<InformationTablePage> createState() => _InformationTablePageState();
}

class _InformationTablePageState extends State<InformationTablePage> {
  @override
  Widget build(BuildContext context) {
    final informationsProvider =
        Provider.of<InformationsProvider>(context, listen: false);
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
                  await informationsProvider.deleteUser(id: id);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  informationsProvider.getInformations();
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
      );
    }

    Future<void> _exportToPDF(List informations) async {
      debugPrint('Exporting ${informations.length} informations to PDF');

      if (informations.isEmpty) {
        debugPrint('No informations data to export');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada data untuk diekspor'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      List<List<String>> tableData = [
        ['No', 'Judul', 'Isi', 'Tanggal Mulai', 'Tanggal Berakhir']
      ];

      for (int i = 0; i < informations.length; i++) {
        final information = informations[i];
        debugPrint('Processing information ${i + 1}: ${information.nama}');
        final DateTime dateMulai = DateTime.parse(information.tanggalMulai!);
        String tanggalMulai =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateMulai);
        final DateTime dateAkhir = DateTime.parse(information.tanggalBerakhir!);
        String tanggalBerakhir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateAkhir);
        String removeHtmlTags(String htmlString) {
          final RegExp exp =
              RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
          return htmlString.replaceAll(exp, '').trim();
        }

        tableData.add([
          (i + 1).toString(),
          information.nama ?? '-',
          removeHtmlTags(information.isi ?? '-'),
          tanggalMulai,
          tanggalBerakhir
        ]);
      }

      debugPrint('Table data created with ${tableData.length} rows');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> children = [
              pw.Text('Data Informasi',
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
        anchor.setAttribute('download', 'information_data.pdf');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('PDF downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/information_data.pdf');
        await file.writeAsBytes(bytes);
        await Share.share(file.path, subject: 'Data Informasi Export');
        debugPrint('PDF file saved and shared');
      }
    }

    Future<void> _exportToCSV(List informations) async {
      debugPrint('Exporting ${informations.length} informations to CSV');

      if (informations.isEmpty) {
        debugPrint('No informations data to export');
        return;
      }

      List<List<String>> csvData = [
        ['No', 'Judul', 'Isi', 'Tanggal Mulai', 'Tanggal Berakhir']
      ];

      for (int i = 0; i < informations.length; i++) {
        final information = informations[i];
        debugPrint('Information $i: ${information.nama}');
        final DateTime dateMulai = DateTime.parse(information.tanggalMulai!);
        String tanggalMulai =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateMulai);
        final DateTime dateAkhir = DateTime.parse(information.tanggalBerakhir!);
        String tanggalBerakhir =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateAkhir);
        String removeHtmlTags(String htmlString) {
          final RegExp exp =
              RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
          return htmlString.replaceAll(exp, '').trim();
        }

        csvData.add([
          (i + 1).toString(),
          information.nama ?? '-',
          removeHtmlTags(information.isi ?? '-'),
          tanggalMulai,
          tanggalBerakhir
        ]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      debugPrint('CSV data created with ${csvData.length} rows');

      if (kIsWeb) {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url);
        anchor.setAttribute('download', 'information_data.csv');
        anchor.click();
        html.Url.revokeObjectUrl(url);
        debugPrint('CSV downloaded to browser');
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/information_data.csv');
        await file.writeAsString(csv);
        await Share.share(file.path, subject: 'Data Informasi Export');
        debugPrint('CSV file saved and shared');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: informationsProvider.getListInformations(),
        builder: (context, snapshot) {
          debugPrint(
              "GET data info: ${informationsProvider.informations.length}");
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
                      'Data Informasi',
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
                        await showTambahInfoPopup(
                          context: context,
                          onSubmit: (data) async {
                            await informationsProvider
                                .addInfo(
                              data: data,
                            )
                                .then((value) {
                              // Refresh data setelah popup selesai
                              informationsProvider.getInformations();
                              // Perbarui UI
                              setState(() {});
                            });
                          },
                        );

                        // Refresh data setelah popup selesai
                        await informationsProvider.getInformations();

                        // Perbarui UI
                        setState(() {});
                      },
                      child: Icon(
                        Icons.add_comment_outlined,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        final informations = informationsProvider
                                .informationsModel?.information ??
                            [];
                        if (value == 'PDF') {
                          await _exportToPDF(informations);
                        } else if (value == 'Excel') {
                          await _exportToCSV(informations);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'PDF',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Export to PDF'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Excel',
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
                            Icon(Icons.download, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Export',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<InformationsProvider?>(
                  builder: (context, provider, child) {
                    String removeHtmlTags(String htmlString) {
                      final RegExp exp = RegExp(r"<[^>]*>",
                          multiLine: true, caseSensitive: true);
                      return htmlString.replaceAll(exp, '').trim();
                    }

                    final informasi = provider?.informations ?? [];
                    if (informasi.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data informasi',
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
                                      "Judul".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Isi".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tanggal Mulai".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tanggal Berakhir".toUpperCase(),
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
                                  informasi.length,
                                  (index) {
                                    final informasiData = informasi[index];
                                    final nomor = index + 1;
                                    final DateTime dateMulai = DateTime.parse(
                                        informasiData.tanggalMulai!);
                                    String tanggalMulai = DateFormat(
                                            'EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(dateMulai);
                                    final DateTime dateAkhir = DateTime.parse(
                                        informasiData.tanggalBerakhir!);
                                    String tanggalBerakhir = DateFormat(
                                            'EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(dateAkhir);
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(
                                            Text(informasiData.nama ?? '-')),
                                        DataCell(Text(removeHtmlTags(
                                            informasiData.isi ?? '-'))),
                                        DataCell(Text(tanggalMulai)),
                                        DataCell(Text(tanggalBerakhir)),
                                        DataCell(
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final info = informasi
                                                      .firstWhere((i) =>
                                                          i.id ==
                                                          informasiData.id);
                                                  final id = informasiData.id;
                                                  showEditInfoPopup(
                                                      context: context,
                                                      info: info,
                                                      onSubmit: (data) async {
                                                        await informationsProvider
                                                            .editInfo(
                                                                id: id!,
                                                                data: data)
                                                            .then((value) {
                                                          informationsProvider
                                                              .getListInformations();
                                                          setState(() {});
                                                        });
                                                      });
                                                  await informationsProvider
                                                      .getListInformations();
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
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () async {
                                                  showDeleteDialog(context,
                                                      informasiData.id!);
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
