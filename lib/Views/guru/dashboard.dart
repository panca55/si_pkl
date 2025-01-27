import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/guru/profile_guru_provider.dart';
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
    final profileGuruProvider =
        Provider.of<ProfileGuruProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: profileGuruProvider.getProfileguru(),
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
              final userNameGuru = profileGuruProvider.currentguru?.user?.name;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: _buildWelcomeCard(name: userNameGuru ?? 'null')),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildWelcomeCard({String? name}) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, $name!',
                  style: GoogleFonts.poppins(
                    color: GlobalColorTheme.primaryBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tetap semangat dan teruslah berkarya! Ingat, setiap langkah kecilmu membawa perubahan besar.',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/man-with-laptop-light.png',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}
