// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/login_page.dart';
import 'package:si_pkl/Views/siswa/dashboard.dart';
import 'package:si_pkl/Views/siswa/evaluasi_page.dart';
import 'package:si_pkl/Views/siswa/logbook.dart';
import 'package:si_pkl/Views/siswa/pkl.dart';
import 'package:si_pkl/Views/siswa/profile.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/provider/siswa/profile_provider.dart';

class DashboardSide extends StatefulWidget {
  const DashboardSide({super.key});

  @override
  _DashboardSideState createState() => _DashboardSideState();
}

class _DashboardSideState extends State<DashboardSide> {
  String _currentPage = 'Dashboard';

  // Daftar halaman yang tersedia
  final Map<String, Widget> _pages = {
    'Dashboard': const Dashboard(),
    'Profile': const Profile(),
    'PKL': const Pkl(),
    'Riwayat Logbook': const Logbook(),
    'Penilaian dan Sertifikat': const EvaluasiPage(),
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    profileProvider.getProfileSiswa();
    if(profileProvider.currentSiswa?.nama == '' && profileProvider.currentSiswa?.hpSiswa == '' && profileProvider.currentSiswa?.nama == null &&
        profileProvider.currentSiswa?.hpSiswa == null){
      _currentPage = 'Profile';
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
                  // Menutup drawer
                  Navigator.pop(context);
                  // Memperbarui halaman yang ditampilkan
                  setState(() {
                    _currentPage = pageName;
                  });
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
                          child: Text('Logout', style: GoogleFonts.poppins(color: Colors.white),),
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
      body: _pages[_currentPage],
    );
  }

  IconData _getIconForPage(String pageName) {
    switch (pageName) {
      case 'Dashboard':
        return Icons.home;
      case 'Profile':
        return Icons.person;
      case 'PKL':
        return Icons.settings;
      case 'Riwayat Logbook':
        return Icons.info;
      case 'Penilaian dan Sertifikat':
        return Icons.info;
      default:
        return Icons.pages;
    }
  }
}

// Halaman Pengaturan
class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Pengaturan',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Halaman Tentang
class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Tentang',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
