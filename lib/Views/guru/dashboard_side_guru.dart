// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_input.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_show.dart';
import 'package:si_pkl/Views/guru/assessment/assessment_siswa.dart';
import 'package:si_pkl/Views/guru/bimbingan/bimbingan_detail.dart';
import 'package:si_pkl/Views/guru/bimbingan/bimbingan_siswa.dart';
import 'package:si_pkl/Views/guru/create_profile_guru.dart';
import 'package:si_pkl/Views/guru/dashboard.dart';
import 'package:si_pkl/Views/guru/detail_logbook.dart';
import 'package:si_pkl/Views/guru/evaluation/evaluation_input.dart';
import 'package:si_pkl/Views/guru/evaluation/evaluation_page.dart';
import 'package:si_pkl/Views/guru/evaluation/evaluation_show.dart';
import 'package:si_pkl/Views/guru/profile_guru.dart';
import 'package:si_pkl/Views/login_page.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/provider/guru/profile_guru_provider.dart';

class DashboardSideGuru extends StatefulWidget {
  const DashboardSideGuru({super.key});

  @override
  _DashboardSideGuruState createState() => _DashboardSideGuruState();
}

class _DashboardSideGuruState extends State<DashboardSideGuru> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _currentPage = 'Dashboard';

  // Daftar halaman yang tersedia
  final Map<String, Widget> _pages = {
    'Dashboard': const Dashboard(),
    'Profile': const ProfileGuru(),
    'Bimbingan Siswa': const BimbinganSiswa(),
    'Penilaian Monitoring Siswa': const AssessmentSiswa(),
    'Penilaian Akhir Siswa': const EvaluationPage(),
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    final profileProvider = Provider.of<ProfileGuruProvider>(context, listen: false);
    return FutureBuilder(
      future: profileProvider.getProfileguru(),
      builder: (context, snapshot) {
        final guru = profileProvider.currentguru?.teacher;
        if ((guru?.nama?.isEmpty ?? true) &&
            (guru?.hp?.isEmpty ?? true)) {
          Future.microtask(() {
            if (mounted) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const CreateProfileGuru()),
              );
            }
          });

          return Scaffold(
            backgroundColor: Colors.red,
            body: Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ), // Tambahkan loading sementara
          );
        }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/SMKN2.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'SIM-PKL',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              // Membuat item drawer untuk setiap halaman
              ..._pages.keys.map((String pageName) {
                return ListTile(
                  hoverColor: Colors.white,
                  title: Text(pageName),
                  // Menambahkan warna latar belakang saat halaman dipilih
                  tileColor: _currentPage == pageName
                      ? Colors.blue.withOpacity(0.1)
                      : null,
                  // Menambahkan leading icon yang berubah saat dipilih
                  leading: Icon(
                    _getIconForPage(pageName),
                    color: _currentPage == pageName ? Colors.blue : Colors.grey,
                  ),
                  selected: _currentPage == pageName,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentPage = pageName;
                    });
                    _navigatorKey.currentState!.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => _pages[pageName]!,
                      ),
                    );
                  },
                );
              }),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                onTap: () {
                  // Konfirmasi logout
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Konfirmasi Logout'),
                        content: const Text('Apakah Anda yakin ingin logout?'),
                        actions: [
                          TextButton(
                            child: const Text('Batal'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              if (authProvider.currentUser?.token == null) {
                                  return; // Hindari error jika user sudah logout sebelumnya
                                }
                              await authProvider
                                    .logout(authProvider.currentUser!.token!)
                                    .then((value) {
                                  profileProvider.clearProfileData();
                                });
                              // Kembali ke halaman login
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              'Logout',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (RouteSettings settings) {
            Widget page = _pages[_currentPage]!;
            if (settings.name == BimbinganDetail.routname) {
              page = BimbinganDetail(
                bimbinganId: ModalRoute.of(context)?.settings.arguments as int,
              );
            }
            if (settings.name == DetailLogbook.routname) {
              page = DetailLogbook(
                logbookId: ModalRoute.of(context)?.settings.arguments as int,
              );
            }
            if (settings.name == AssessmentInput.routname) {
              page = AssessmentInput(
                internshipId: ModalRoute.of(context)?.settings.arguments as int,
              );
            }
            if (settings.name == AssessmentShow.routname) {
              page = AssessmentShow(
                assessmentId: ModalRoute.of(context)?.settings.arguments as int,
              );
            }
            if (settings.name == EvaluationInput.routname) {
              page = EvaluationInput(
                internshipId: ModalRoute.of(context)?.settings.arguments as int,
              );
            }
            if (settings.name == EvaluationShow.routname) {
              page = EvaluationShow(
                internshipId: ModalRoute.of(context)?.settings.arguments as int,
              );
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        ),
      );
      },
    );
  }

  IconData _getIconForPage(String pageName) {
    switch (pageName) {
      case 'Dashboard':
        return Icons.home;
      case 'Profile':
        return Icons.person;
      case 'Bimbingan siswa':
        return Icons.library_books_outlined;
      case 'Penilaian Monitoring Siswa':
        return Icons.assignment;
      case 'Penilaian Akhir Siswa':
        return Icons.assignment_turned_in_sharp;
      default:
        return Icons.pages;
    }
  }
}
