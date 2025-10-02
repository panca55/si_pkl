import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/Views/guru/widgets/show_komentar_edit_popup.dart';
import 'package:si_pkl/Views/guru/widgets/show_komentar_popup.dart';
import 'package:si_pkl/provider/guru/detail_logbook_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailLogbook extends StatefulWidget {
  static const String routname = '/logbook-guru-detail';
  final int? logbookId;
  const DetailLogbook({super.key, required this.logbookId});

  @override
  State<DetailLogbook> createState() => _DetailLogbookState();
}

class _DetailLogbookState extends State<DetailLogbook> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.logbookId == null) {
      debugPrint('ID Siswa = ${widget.logbookId} / tidak ditemukan');
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('ID Logbook tidak ditemukan'),
        ),
      );
    }
    debugPrint('ID yang terpilih: ${widget.logbookId}');
    String removeHtmlTags(String htmlString) {
      final RegExp exp =
          RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '').trim();
    }

    final logbook = Provider.of<DetailLogbookProvider>(context, listen: false);
    final getIndexLogbook = logbook.getIndexLogbook(widget.logbookId!);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getIndexLogbook,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              loading = true;
            } else if (snapshot.hasError) {
              debugPrint('Terjadi kesalahan: ${snapshot.error}');
              return Center(
                child: Text(
                  'Terjadi kesalahan: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final logbookData = logbook.detailLogbookModel?.logbook;
            final noteId =
                (logbookData?.note != null && logbookData!.note!.isNotEmpty)
                    ? logbookData.note!.first.id
                    : null;
            debugPrint('noteID: $noteId');
            final isiLogbook = logbookData?.isi ?? '-';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Skeletonizer(
                enabled: loading,
                enableSwitchAnimation: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<DetailLogbookProvider>(
                        builder: (context, logbookDetail, child) {
                      debugPrint('noteID Consumer: $noteId');
                      final logbookDataDetail =
                          logbookDetail.detailLogbookModel?.logbook;
                      final logbookModel = logbookDetail.detailLogbookModel;
                      final komentarPembimbing =
                          logbookModel?.noteGuru?.catatan;
                      final penilaianPembimbing =
                          logbookModel?.noteGuru?.penilaian;
                      final penilaianInstruktur =
                          logbookModel?.noteInstruktur?.penilaian;
                      final komentarInstruktur =
                          logbookModel?.noteInstruktur?.catatan;
                      final isKomentarEmpty = logbookDataDetail?.note?.isEmpty;
                      debugPrint('Logbook ID: ${logbookDataDetail?.id}');
                      debugPrint(
                          'Bentuk Kegiatan: ${logbookDataDetail?.bentukKegiatan}');
                      final tanggalPekerjaan =
                          logbookDataDetail?.tanggal ?? '-';
                      String formattedDate;
                      loading = false;
                      try {
                        if (tanggalPekerjaan != '-') {
                          DateTime tanggal = DateTime.parse(tanggalPekerjaan);
                          formattedDate = DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(tanggal);
                        } else {
                          formattedDate = '-';
                        }
                      } catch (e) {
                        formattedDate = '-';
                      }
                      return _buildInfoCard(
                        komentarProvider: getIndexLogbook,
                        isKomentarEmpty: isKomentarEmpty ?? true,
                        noteId: noteId,
                        logbook: logbook,
                        logbookId: logbookData?.id,
                        image:
                            '${BaseApi.logbookImageUrl}/${logbookDataDetail?.fotoKegiatan}',
                        colorHeader: GlobalColorTheme.primaryBlueColor,
                        title: 'Detail Logbook',
                        property1: 'Judul Pekerjaan :',
                        value1: logbookData?.judul,
                        property2: 'Kategori :',
                        value2: logbookData?.category,
                        property3: 'Tanggal :',
                        value3: formattedDate,
                        property4: 'Bentuk Kegiatan :',
                        value4: logbookData?.bentukKegiatan,
                        property5: 'Waktu Pengerjaan :',
                        value5: logbookData?.mulai,
                        value6: logbookData?.selesai,
                        property6: 'Petugas :',
                        value7: logbookData?.petugas,
                        property7: 'Deskripsi Pekerjaan :',
                        value8: removeHtmlTags(isiLogbook),
                        property8: 'Keterangan :',
                        value9: logbookData?.keterangan,
                        property9: 'Komentar Pembimbing :',
                        value10: komentarPembimbing,
                        property10: 'Penilaian Pembimbing :',
                        value11: penilaianPembimbing,
                        property11: 'Komentar Instruktur :',
                        value12: komentarInstruktur,
                        property12: 'Penilaian Instruktur :',
                        value13: penilaianInstruktur,
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildInfoCard(
      {required Color colorHeader,
      required String title,
      required String property1,
      required String property2,
      required String property3,
      required String image,
      String? property4,
      String? property5,
      String? property6,
      String? property7,
      String? property8,
      String? property9,
      String? property10,
      String? property11,
      String? property12,
      String? value1,
      String? value2,
      String? value3,
      String? value4,
      String? value5,
      String? value6,
      String? value7,
      String? value8,
      String? value9,
      String? value10,
      String? value11,
      String? value12,
      String? value13,
      required int? logbookId,
      required int? noteId,
      required DetailLogbookProvider logbook,
      required Future<void> komentarProvider,
      required bool isKomentarEmpty}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(2, 2))
                        ]),
                    child: Text(
                      'Kembali',
                      style: GoogleFonts.poppins(
                          color: GlobalColorTheme.primaryBlueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoRow(property1, value1 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property2, value2 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property3, value3 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property4!, value4 ?? '-'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property5!,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${value5 ?? '-'} WIB',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '${value6 ?? '-'} WIB',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(property6!, value7 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property7!, value8 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property8!, value9 ?? '-'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Foto Kegiatan',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Image.network(
                image,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Komentar Logbook',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(property9!, value10 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property10!, value11 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property11!, value12 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property12!, value13 ?? '-'),
              const SizedBox(width: 12),
              if (isKomentarEmpty)
                GestureDetector(
                  onTap: () {
                    showKomentarPopup(
                        context: context,
                        onSubmit: (data) {
                          logbook.submitKomentar(
                            logbookId: data['logbook_id'],
                            noteType: data['note_type'],
                            catatan: data['catatan'],
                            penilaian: data['penilaian'],
                          );
                        },
                        logbookId: logbookId!);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(2, 2))
                        ]),
                    child: Text(
                      'Beri Komentar',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    try {
                      debugPrint('noteID: $noteId');
                      showKomentarEditPopup(
                          komentarProvider: komentarProvider,
                          context: context,
                          onSubmit: (data) {
                            logbook.editKomentar(
                              id: data['id'],
                              catatan: data['catatan'],
                              penilaian: data['penilaian'],
                            );
                          },
                          id: noteId!);
                    } catch (e) {
                      debugPrint('error: $e');
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(2, 2))
                        ]),
                    child: Text(
                      'Edit Komentar',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
