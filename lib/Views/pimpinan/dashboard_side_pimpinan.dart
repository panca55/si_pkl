import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/login_page.dart';
import 'package:si_pkl/Views/pimpinan/dashboard.dart';
import 'package:si_pkl/Views/pimpinan/siswa_pkl.dart';
import 'package:si_pkl/Views/pimpinan/siswa_pkl_detail.dart';
import 'package:si_pkl/controller/auth_controller.dart';

class DashboardSidePimpinan extends StatefulWidget {
  const DashboardSidePimpinan({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardSidePimpinanState createState() => _DashboardSidePimpinanState();
}

class _DashboardSidePimpinanState extends State<DashboardSidePimpinan> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  String _currentPage = 'Dashboard';

  final Map<String, Widget> _pages = {
    'Dashboard': const Dashboard(),
    'Siswa PKL': const SiswaPkl(),
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          _currentPage,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 20),
                  Text(
                    'SIM-PKL',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ..._pages.keys.map((String pageName) {
              return ListTile(
                hoverColor: Colors.white,
                title: Text(pageName),
                tileColor: _currentPage == pageName
                    ? Colors.blue.withOpacity(0.1)
                    : null,
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
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text('Logout'),
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
          if (settings.name == SiswaPklDetail.routname) {
            page = SiswaPklDetail(siswaId: ModalRoute.of(context)?.settings.arguments as int,);
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
      case 'Siswa PKL':
        return Icons.people;
      default:
        return Icons.pages;
    }
  }
}

