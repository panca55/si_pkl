// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/dashboard_side_admin.dart';
import 'package:si_pkl/Views/admin_sekolah/dashboard_side_admin_sekolah.dart';
import 'package:si_pkl/Views/guru/dashboard_side_guru.dart';
import 'package:si_pkl/Views/instruktur/dashboard_side_instruktur.dart';
import 'package:si_pkl/Views/perusahaan/dashboard_side_perusahaan.dart';
import 'package:si_pkl/Views/pimpinan/dashboard_side_pimpinan.dart';
import 'package:si_pkl/Views/register_page.dart';
import 'package:si_pkl/Views/siswa/dashboard_side.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fungsi untuk menampilkan toast error
    void showErrorToast(BuildContext context, String message) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
        title: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300),
        icon: const Icon(Icons.error_outline),
        primaryColor: GlobalColorTheme.errorColor,
        backgroundColor: Colors.white,
        showIcon: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
      );
    }
    final authProvider = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/SMKN2.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    'assets/images/SIGAPKL.png',
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4))
                  ]),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Selamat Datang',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade800, fontSize: 14),
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sistem Informasi dan Manajemen PKL\nSMK NEGERI 2 PADANG',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                      Text(
                        'EMAIL',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 12),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade800,
                            fontSize: 12,
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'PASSWORD',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 12),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade800,
                            fontSize: 12,
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF696cff),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: const Offset(0, 4))
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Login',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;

                                      await authProvider
                                          .login(email, password)
                                          .then((value) {
                                        debugPrint('Login successful');
                                      });

                                      final currentUser =
                                          authProvider.currentUser?.user;
                                      if (currentUser == null) {
                                        showErrorToast(context,
                                            'Gagal Login: Akun tidak ditemukan');
                                        return;
                                      }

                                      if (currentUser.isActive != 1) {
                                        showErrorToast(context,
                                            'Gagal Login: Akun tidak aktif');
                                        return;
                                      }
                                      final ctx = context;
                                      switch (currentUser.role) {
                                        case 'PIMPINAN':
                                        case 'KEPSEK':
                                        case 'WAKASEK':
                                        case 'DAPODIK':
                                        case 'WAKAKURIKULUM':
                                          Navigator.of(ctx).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardSidePimpinan()));
                                          break;
                                        case 'SISWA':
                                          Navigator.of(ctx).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DashboardSide()));
                                          break;
                                        case 'ADMIN':
                                          Navigator.of(ctx).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardSideAdmin()));
                                          break;
                                        case 'PERUSAHAAN':
                                          Navigator.of(ctx).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardSidePerusahaan()));
                                          break;
                                        case 'INSTRUKTUR':
                                          Navigator.of(ctx).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardSideInstruktur()));
                                          break;
                                        case 'GURU':
                                          Navigator.of(ctx).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DashboardSideGuru()));
                                          break;
                                        case 'WAKAHUMAS':
                                          Navigator.of(ctx).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardSideAdminSekolah()));
                                          break;
                                        default:
                                          showErrorToast(ctx, 'Gagal Login');
                                          break;
                                      }
                                    } catch (e) {
                                      debugPrint('Error login: $e');
                                      showErrorToast(context,
                                          'Terjadi kesalahan saat login');
                                    }
                                  }
                                }
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                            },
                            child: Text(
                              'Daftar',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
