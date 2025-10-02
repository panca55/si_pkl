import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/Views/instruktur/detail_logbook.dart';
import 'package:si_pkl/models/instruktur/bimbingan/bimbingan_index_model.dart';
import 'package:si_pkl/provider/instruktur/bimbingan_instruktur_index_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BimbinganDetail extends StatefulWidget {
  static const String routname = '/bimbingan-siswa-detail';
  final int? bimbinganId;
  const BimbinganDetail({super.key, required this.bimbinganId});

  @override
  State<BimbinganDetail> createState() => _BimbinganDetailState();
}

class _BimbinganDetailState extends State<BimbinganDetail> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    if (widget.bimbinganId == null) {
      debugPrint('ID Siswa = ${widget.bimbinganId} / tidak ditemukan');
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('ID Siswa tidak ditemukan'),
        ),
      );
    }
    debugPrint('ID yang terpilih: ${widget.bimbinganId}');
    final bimbingan =
        Provider.of<BimbinganInstrukturIndexProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: bimbingan.getIndexBimbingan(widget.bimbinganId!),
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
            final bimbinganData = bimbingan.bimbinganIndexModel;
            final internship = bimbinganData?.internship;
            debugPrint(
                'Persentase hadir: ${bimbinganData?.attendancePercentage}%');
            loading = false;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: loading,
                    enableSwitchAnimation: true,
                    child: _buildInfoCard(
                      image:
                          '${BaseApi.studentImageUrl}/${internship?.student?.foto}',
                      colorHeader: GlobalColorTheme.primaryBlueColor,
                      title: 'Informasi Siswa',
                      property1: 'Nama',
                      value1: internship?.student?.nama,
                      property2: 'Nama Perusahaan',
                      value2: internship?.corporation?.nama,
                      property3: 'Alamat',
                      value3: internship?.corporation?.alamat,
                      property4: 'Nama Instruktur',
                      value4: internship?.instructor?.nama,
                      property5: 'No HP Instruktur',
                      value5: internship?.instructor?.hp,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: absentsList(internship)),
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: logbookGrid(internship)),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }

  StatefulBuilder absentsList(Internship? internship) {
    const int itemsPerPage = 6; // Jumlah item per halaman
    int currentPage = 0; // Halaman saat ini

    return StatefulBuilder(
      builder: (context, setState) {
        final absents = internship?.absents?.reversed.toList() ?? [];
        final totalPages = (absents.length / itemsPerPage).ceil();

        // Ambil absensi untuk halaman saat ini
        final currentPageItems = absents
            .skip(currentPage * itemsPerPage)
            .take(itemsPerPage)
            .toList();

        return Container(
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
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Absensi Siswa',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // DataTable untuk absensi
              Container(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    clipBehavior: Clip.hardEdge,
                    dataRowMinHeight: 45,
                    // horizontalMargin: 30,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          "Tanggal".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Keterangan".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Bukti".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      currentPageItems.length,
                      (index) {
                        final absentsData = currentPageItems[index];
                        final tanggalAbsent = absentsData.tanggal != null
                            ? DateTime.tryParse(absentsData.tanggal!)
                            : null;
                        final tanggal = tanggalAbsent != null
                            ? DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                .format(tanggalAbsent)
                            : '-';

                        final imageUrl = absentsData.keterangan == 'HADIR'
                            ? '${BaseApi.absenImageUrl}/${absentsData.photo}'
                            : '${BaseApi.suratIzinFileUrl}/${absentsData.photo}';

                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(tanggal,
                                style: GoogleFonts.poppins(fontSize: 10))),
                            DataCell(Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: absentsData.keterangan == 'HADIR'
                                      ? GlobalColorTheme.successColor
                                      : absentsData.keterangan == 'IZIN'
                                          ? Colors.amber
                                          : GlobalColorTheme.errorColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  absentsData.keterangan ?? '-',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                            DataCell(
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Pagination buttons
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.green.shade800
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  StatefulBuilder logbookGrid(Internship? internship) {
    const int itemsPerPage = 6; // Jumlah item per halaman
    int currentPage = 0; // Halaman saat ini

    return StatefulBuilder(
      builder: (context, setState) {
        final logbooks = internship?.logbook?.reversed.toList() ?? [];
        final totalPages = (logbooks.length / itemsPerPage).ceil();

        // Ambil logbook untuk halaman saat ini
        final currentPageItems = logbooks
            .skip(currentPage * itemsPerPage)
            .take(itemsPerPage)
            .toList();

        return Container(
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
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Jurnal Siswa',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // GridView untuk logbook
              Container(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: currentPageItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final logbook = currentPageItems[i];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            logbook.judul ?? '-',
                            style: GoogleFonts.poppins(
                              color: GlobalColorTheme.primaryBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            logbook.tanggal ?? '-',
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bentuk Kegiatan:',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            logbook.bentukKegiatan ?? '-',
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keterangan:',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            logbook.keterangan ?? '-',
                            style: GoogleFonts.poppins(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Foto Kegiatan:',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${BaseApi.logbookImageUrl}/${logbook.fotoKegiatan}',
                                fit: BoxFit.cover,
                                height: 80,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                final logbookId = logbook.id;
                                debugPrint('ID yang dipilih: $logbookId: ');
                                // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        DetailLogbook(
                                      logbookId: logbookId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
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
                                  'Lihat Detail',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Pagination buttons
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? Colors.amber
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
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
      String? value1,
      String? value2,
      String? value3,
      String? value4,
      String? value5}) {
    return Container(
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              _buildInfoRow(property1, value1 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property2, value2 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property3, value3 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property4!, value4 ?? '-'),
              const SizedBox(height: 12),
              _buildInfoRow(property5!, value5 ?? '-'),
              const SizedBox(width: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/pencil-rocket.png',
                  height: 180,
                ),
              ),
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
            ': $value',
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
