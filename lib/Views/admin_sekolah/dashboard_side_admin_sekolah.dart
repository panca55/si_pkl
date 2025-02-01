// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/corporate_table_page.dart';
import 'package:si_pkl/Views/admin/dashboard_admin.dart';
import 'package:si_pkl/Views/admin/instructors_table_page.dart';
import 'package:si_pkl/Views/admin/students_table_page.dart';
import 'package:si_pkl/Views/admin/teachers_table_page.dart';
import 'package:si_pkl/Views/admin_sekolah/abesnts_table_page.dart';
import 'package:si_pkl/Views/admin_sekolah/penilaian_show.dart';
import 'package:si_pkl/Views/admin_sekolah/penilaian_table_page.dart';
import 'package:si_pkl/Views/admin_sekolah/pkl_table_page.dart';
import 'package:si_pkl/Views/login_page.dart';
import 'package:si_pkl/controller/auth_controller.dart';

class DashboardSideAdminSekolah extends StatefulWidget {
  const DashboardSideAdminSekolah({super.key});

  @override
  _DashboardSideAdminSekolahState createState() =>
      _DashboardSideAdminSekolahState();
}

class _DashboardSideAdminSekolahState extends State<DashboardSideAdminSekolah> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _currentPage = 'Penilaian';

  // Daftar halaman yang tersedia
  final Map<String, Widget> _pages = {
    'Dashboard': const DashboardAdmin(),
    'Siswa': const StudentsTablePage(),
    'Guru': const TeachersTablePage(),
    'Mitra Sekolah': const CorporateTablePage(),
    'Instruktur': const InstructorsTablePage(),
    'PKL': const PklTablePage(),
    'Penilaian': const PenilaianTablePage(),
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
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
                            await authProvider
                                .logout(authProvider.currentUser!.token!);
                            // Kembali ke halaman login
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('Logout',
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
          if (settings.name == PenilaianShow.routname) {
            page = PenilaianShow(
              assessmentId: ModalRoute.of(context)?.settings.arguments as int,
            );
          }
          if (settings.name == AbesntsTablePage.routname) {
            page = const AbesntsTablePage();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
    );
  }

  IconData _getIconForPage(String pageName) {
    switch (pageName) {
      case 'Dashboard':
        return Icons.home;
      case 'Siswa':
        return Icons.person;
      case 'Guru':
        return Icons.co_present_sharp;
      case 'Mitra Sekolah':
        return Icons.corporate_fare;
      case 'Instruktur':
        return Icons.person;
      case 'PKL':
        return Icons.app_registration_outlined;
      case 'Penilaian':
        return Icons.check_box;
      default:
        return Icons.pages;
    }
  }
}
