import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/pimpinan/siswa_pkl_detail.dart';
import 'package:si_pkl/Views/siswa/widgets/show_edit_logbook_form.dart';
import 'package:si_pkl/provider/siswa/intern_provider.dart';
import 'package:si_pkl/Views/siswa/widgets/show_logbook_form.dart';
import 'package:si_pkl/Views/siswa/widgets/show_attendance_popup.dart';

class Pkl extends StatefulWidget {
  const Pkl({super.key});

  @override
  State<Pkl> createState() => _PklState();
}

class _PklState extends State<Pkl> with RouteAware {
  late Future<void> _dataFuture;
  final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when returning to this page
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _dataFuture =
          Provider.of<InternProvider>(context, listen: false).getInternSiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Tampilkan pesan error jika terjadi kesalahan
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
              ),
            );
          }
          final canShowInternInfo = internProvider.canShowInternInfo;
          final canShowAttendanceButton =
              internProvider.canShowAttendanceButton;
          debugPrint('can show intern info? $canShowInternInfo');

          return Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Informasi motivasi
                  buildMotivationCard(),

                  const SizedBox(height: 16),
                  if (canShowInternInfo) ...[
                    // Tampilkan informasi kehadiran jika dalam masa PKL
                    buildAttendanceCard(context, canShowAttendanceButton),
                    const SizedBox(height: 16),
                    logbookTable(context),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Tampilkan widget Text jika tidak dalam masa PKL
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Masa PKL belum terlaksana atau telah berakhir.',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container logbookTable(BuildContext context) {
    final internProvider = Provider.of<InternProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      clipBehavior: Clip.hardEdge,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Jurnal Harian',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          internProvider.currentIntern?.kehadiranHariIni == true
              ? GestureDetector(
                  onTap: () {
                    showLogbookForm(
                        context: context,
                        onSubmit: (data, fileBytes, imageFile) async {
                          try {
                            await Provider.of<InternProvider>(context,
                                    listen: false)
                                .submitLogbook(
                              judul: data['judul'],
                              category: data['category'],
                              bentukKegiatan: data['bentuk_kegiatan'],
                              penugasanPekerjaan: data['penugasan_pekerjaan'],
                              tanggal: data['tanggal'],
                              mulai: data['mulai'],
                              selesai: data['selesai'],
                              petugas: data['petugas'],
                              isi: data['isi'],
                              keterangan: data['keterangan'],
                              fileBytes: fileBytes,
                              filePath: imageFile,
                            );
                            // Refresh data after successful submission
                            _refreshData();
                          } catch (e) {
                            // Refresh data even if submission failed
                            _refreshData();
                            // Re-throw to let the form handle the error display
                            rethrow;
                          }
                        });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF71dd37),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'Tambah Jurnal',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const Divider(),
          Consumer<InternProvider>(
            builder: (context, provider, child) {
              final intern = provider.currentIntern;
              if (intern == null ||
                  intern.logbook == null ||
                  intern.logbook!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Belum ada jurnal harian yang ditambahkan.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    clipBehavior: Clip.hardEdge,
                    dataRowMinHeight: 45,
                    horizontalMargin: 30,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          "No".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Tanggal".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Kategori Kegiatan".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Judul Kegiatan".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Aksi".toUpperCase(),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      intern.logbook!.length,
                      (index) {
                        final logbook = intern.logbook![index];
                        final DateTime tanggalDateTime =
                            DateTime.parse(logbook.tanggal!);
                        String tanggal =
                            DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                .format(tanggalDateTime);
                        final nomor = index + 1;
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(nomor.toString())),
                            DataCell(Text(tanggal)),
                            DataCell(Text(logbook.category ?? '-')),
                            DataCell(Text(logbook.judul ?? '-')),
                            DataCell(
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Aksi untuk tombol edit
                                      showEditLogbookForm(
                                        context: context,
                                        id: logbook.id!,
                                        onSubmit:
                                            (data, fileBytes, fileName) async {
                                          debugPrint(
                                              'Form data being submitted: $data');
                                          try {
                                            await Provider.of<InternProvider>(
                                                    context,
                                                    listen: false)
                                                .editLogbook(
                                              id: logbook.id!,
                                              judul: data['judul'],
                                              category: data['category'],
                                              bentukKegiatan:
                                                  data['bentuk_kegiatan'],
                                              penugasanPekerjaan:
                                                  data['penugasan_pekerjaan'],
                                              tanggal: data['tanggal'],
                                              mulai: data['mulai'],
                                              selesai: data['selesai'],
                                              petugas: data['petugas'],
                                              isi: data['isi'],
                                              keterangan: data['keterangan'],
                                              fileBytes: fileBytes,
                                              filePath: fileName,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Logbook berhasil diedit'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            // Refresh data after successful edit
                                            _refreshData();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Gagal edit logbook: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            // Refresh data even if edit failed
                                            _refreshData();
                                          }
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      // Aksi untuk tombol delete
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Hapus Jurnal',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              'Apakah Anda yakin ingin menghapus jurnal ini?',
                                              style: GoogleFonts.poppins(),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Batal',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.grey),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    await Provider.of<
                                                                InternProvider>(
                                                            context,
                                                            listen: false)
                                                        .deleteLogbook(
                                                            id: logbook.id!);
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Logbook berhasil dihapus'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Gagal hapus logbook: $e'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'Hapus',
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF3E1D),
                                        borderRadius: BorderRadius.circular(8),
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
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan kartu motivasi
  Widget buildMotivationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(1, 1)),
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(-1, -1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/bulb-light.png',
            height: 180,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text.rich(
              textAlign: TextAlign.justify,
              TextSpan(
                children: [
                  TextSpan(
                      text:
                          'Laksanakan PRAKTEK KERJA LAPANGAN dengan JUJUR, KREATIF, INOVATIF ',
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 18)),
                  TextSpan(
                      text: 'All in one place.',
                      style: GoogleFonts.poppins(
                          color: Colors.blue, fontSize: 18)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
                'Tumbuhkan keterampilanmu dengan semangat, kejujuran, kreativitas, dan inovasi melalui pelaksanaan praktek kerja lapangan industri yang terpercaya dan berkualitas.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade700, fontSize: 15)),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/pencil-rocket.png',
              height: 180,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan persentase kehadiran dan tombol input
  Widget buildAttendanceCard(
    BuildContext context,
    bool canShowAttendanceButton,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(1, 1)),
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(-1, -1))
        ],
      ),
      child:
          Consumer<InternProvider>(builder: (context, internProvider, child) {
        return Column(
          children: [
            Text(
              'Persentase Kehadiran',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade700, fontSize: 18),
            ),
            StreamBuilder<String>(
              stream: Stream.periodic(const Duration(seconds: 1), (count) {
                DateTime now = DateTime.now();
                String tanggalHariIni =
                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
                String jamSekarang = DateFormat.jms('id_ID').format(now);
                return '$tanggalHariIni\n$jamSekarang';
              }),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade700, fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/3d-fluency-pencil-and-ruler.png',
              height: 180,
            ),
            internProvider.canShowAttendanceButton
                ? GestureDetector(
                    onTap: () async {
                      await showAttendancePopup(
                        context: context,
                        onSubmit: (String status, Uint8List? fileBytes,
                            String? filePath) async {
                          try {
                            await Provider.of<InternProvider>(context,
                                    listen: false)
                                .submitAttendance(
                                    keterangan: status,
                                    fileBytes: fileBytes!,
                                    filePath: filePath);
                            internProvider.currentIntern?.kehadiranHariIni =
                                true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Absensi berhasil disimpan',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16),
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            // Refresh data after successful attendance
                            _refreshData();
                          } catch (e) {
                            // Refresh data even if attendance failed
                            _refreshData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal menyimpan absensi: $e',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16),
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF71dd37),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        'Input Kehadiran',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : const Divider(
                    thickness: 0,
                    color: Colors.white,
                  ),
            Text(
              '${internProvider.currentIntern?.presentaseKehadiran?.round() ?? 0}% Kehadiran ',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade700, fontSize: 18),
            ),
            Text(
              'Hadir: ${internProvider.currentIntern?.detailKehadiran?.hadir} ',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade700, fontSize: 18),
            ),
            Text(
              'Izin: ${internProvider.currentIntern?.detailKehadiran?.izin} ',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade700, fontSize: 18),
            ),
            Text(
              'Sakit: ${internProvider.currentIntern?.detailKehadiran?.sakit} ',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade700, fontSize: 18),
            ),
            Text(
              'Alpha: ${internProvider.currentIntern?.detailKehadiran?.alpha} ',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade700, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                final siswaId = internProvider.currentIntern?.internship
                    ?.studentId; // Ambil ID siswa dari objek siswa
                debugPrint('ID yang dipilih: $siswaId');

                // Navigasikan ke halaman SiswaPklDetail dengan menggunakan ID
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => SiswaPklDetail(
                      siswaId: siswaId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF71dd37),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Text(
                  'Lihat Detail Absensi',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/pencil-rocket.png',
                height: 180,
              ),
            ),
          ],
        );
      }),
    );
  }
}
