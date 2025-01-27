import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/user_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: userProvider.getUser(),
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

          final namaUser = userProvider.currentUser?.name ?? 'Pengguna';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeletonizer(
                  enabled: loading,
                  enableSwitchAnimation: true,
                  child: _buildProfileCard(name: namaUser),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard({String? name}) {
    return Container(
      clipBehavior: Clip.hardEdge,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'Selamat datang, $name!',
                style: GoogleFonts.poppins(
                  color: GlobalColorTheme.primaryBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
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
    );
  }
}
