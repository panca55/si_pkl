import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/admin/corporations_model.dart';
import 'package:si_pkl/models/admin/students_model.dart';
import 'package:si_pkl/models/admin/teachers_model.dart';
import 'package:si_pkl/models/admin/users_model.dart';
import 'package:si_pkl/provider/admin/corporations_provider.dart';
import 'package:si_pkl/provider/admin/students_provider.dart';
import 'package:si_pkl/provider/admin/teachers_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final studentsProvider =
        Provider.of<StudentsProvider>(context, listen: false);
    final corporationsProvider =
        Provider.of<CorporationsProvider>(context, listen: false);
    final teachersProvider =
        Provider.of<TeachersProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Future.wait([
            usersProvider.getUsers(),
            studentsProvider.getStudents(),
            corporationsProvider.getCorporations(),
            teachersProvider.getTeachers(),
          ]),
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
            final user = usersProvider.usersModel;
            final student = studentsProvider.studentsModel;
            final teachers = teachersProvider.teachersModel;
            final corporations = corporationsProvider.corporationsModel;
            return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (user != null)
                          Expanded(child: userCard(user))
                          else
                          const SizedBox.shrink(),
                          const SizedBox(width: 10),
                          if (student != null)
                          Expanded(child: siswaCard(student))
                          else
                          const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (teachers != null)
                          Expanded(child: guruCard(teachers))
                          else
                          const SizedBox.shrink(),
                          const SizedBox(width: 10),
                          if (corporations != null)
                          Expanded(child: perusahaanCard(corporations))
                          else
                          const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  Container userCard(UsersModel user) {
    final totalUser = user.user?.length;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person,
                color: GlobalColorTheme.primaryBlueColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Total Users',
                style: GoogleFonts.poppins(color: Colors.black38),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            totalUser.toString(),
            style: GoogleFonts.poppins(color: Colors.black),
          )
        ],
      ),
    );
  }

  Container siswaCard(StudentsModel student) { 
          final totalSiswa = student.student?.length;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person_pin_sharp,
                      color: GlobalColorTheme.successColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Total Siswa',
                      style: GoogleFonts.poppins(color: Colors.black38),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  totalSiswa.toString(),
                  style: GoogleFonts.poppins(color: Colors.black),
                )
              ],
            ),
          );
  }

  Container perusahaanCard(CorporationsModel corporate) {
          final totalCorporate =
              corporate.corporation?.length;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.corporate_fare,
                      color: GlobalColorTheme.primaryBlueColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        'Total Perusahaan',
                        style: GoogleFonts.poppins(color: Colors.black38),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  totalCorporate.toString(),
                  style: GoogleFonts.poppins(color: Colors.black),
                )
              ],
            ),
          );
  }

  Container guruCard(TeachersModel teachers) {
          final totalGuru = teachers.teachers?.length;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.co_present_sharp,
                      color: Colors.blue.shade400,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Total Guru',
                      style: GoogleFonts.poppins(color: Colors.black38),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  totalGuru.toString(),
                  style: GoogleFonts.poppins(color: Colors.black),
                )
              ],
            ),
          );
  }
}
