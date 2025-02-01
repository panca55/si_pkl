import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/perusahaan/widgets/show_add_instruktur_popup.dart';
import 'package:si_pkl/provider/perusahaan/dashboard_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardPerusahaan extends StatefulWidget {
  const DashboardPerusahaan({super.key});

  @override
  State<DashboardPerusahaan> createState() => _DashboardPerusahaanState();
}

class _DashboardPerusahaanState extends State<DashboardPerusahaan> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: dashboardProvider.getDashboardData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Aktifkan skeleton saat menunggu
                loading = true;
              } else {
                // Nonaktifkan skeleton saat data selesai dimuat
                loading = false;

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat data: ${snapshot.error}', // Tampilkan pesan error jika ada
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              }
              final userName =
                  dashboardProvider.dashboardModel?.corporation?.nama;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: _buildWelcomeCard(name: userName ?? 'null')),
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: siswaPKLCard(dashboardProvider)),
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: instrukturCard(dashboardProvider))
                ],
              );
            }),
      ),
    );
  }

  Container instrukturCard(DashboardProvider dashboardProvider) {
    final instructors =
        dashboardProvider.dashboardModel?.instructors?.toList() ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Instruktur'.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: GlobalColorTheme.primaryBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.monitor,
                size: 24,
                color: Color(0xff696cff),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final instruktur = instructors[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          instruktur.nama ?? '',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: GlobalColorTheme.successColor, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            instruktur.studentsCount.toString(),
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: instructors.length),
          )
        ],
      ),
    );
  }

  Container siswaPKLCard(DashboardProvider dashboardProvider) {
    final siswaPKL =
        dashboardProvider.dashboardModel?.internships?.toList() ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Siswa PKL'.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: GlobalColorTheme.primaryBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.person_pin_rounded,
                size: 24,
                color: Color(0xff696cff),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              clipBehavior: Clip.hardEdge,
              dataRowMinHeight: 45,
              dataRowMaxHeight: 85,
              horizontalMargin: 30,
              columns: <DataColumn>[
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Center(
                    child: Text(
                      "nama siswa".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Center(
                    child: Text(
                      "jurusan".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ),
                DataColumn(
                  headingRowAlignment: MainAxisAlignment.center,
                  label: Center(
                    child: Text(
                      "Instruktur".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                siswaPKL.length,
                (index) {
                  final siswaPklData = siswaPKL[index];
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(siswaPklData.student?.nama ?? '-')),
                      DataCell(Text(
                          siswaPklData.student?.mayor?.department?.nama ??
                              '-')),
                      DataCell(siswaPklData.instructor != null
                          ? Row(
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.all(10),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: GlobalColorTheme.successColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      siswaPklData.instructor?.nama ?? '-',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    )),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            offset: const Offset(2, 2))
                                      ],
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            offset: const Offset(2, 2))
                                      ],
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.edit_document,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                showAddInstrukturPopup(
                                  instruktur: dashboardProvider
                                          .dashboardModel?.instructors ??
                                      [],
                                  context: context,
                                  onSubmit: (instructorId) {
                                    dashboardProvider.submitInstruktur(
                                        studentId: siswaPklData.student!.id!,
                                        instructorId: instructorId);
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(10),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: const Offset(2, 2))
                                    ],
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Tugaskan Instruktur',
                                  textAlign: TextAlign.center,
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ),
                            )),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard({String? name}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff696cff),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, perusahaan $name!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Di sini Anda dapat mengelola magang, melihat kemajuan siswa, dan menginformasikan lowongan pekerjaan.',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/corporation-welcome.png',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}
