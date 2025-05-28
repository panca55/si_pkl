import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/login_page.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        'NAMA LENGKAP',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 12),
                      ),
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Lengkap',
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
                      Text(
                        'CONFIRM PASSWORD',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 12),
                      ),
                      TextFormField(
                        controller: _passwordConfirmController,
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
                                    'Sign Up',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                                ),
                                onTap: () async {
                                  if (_formKey.currentState!.validate() &&
                                      _passwordController.text ==
                                          _passwordConfirmController.text && (_passwordController.text.length >= 8 && _passwordConfirmController.text.length >= 8)) {
                                    try {
                                      await authProvider
                                          .register(
                                              name: _namaController.text,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              passwordConfirmation:
                                                  _passwordConfirmController
                                                      .text)
                                          .then((value) {
                                        toastification.show(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          type: ToastificationType.success,
                                          style:
                                              ToastificationStyle.fillColored,
                                          autoCloseDuration:
                                              const Duration(seconds: 5),
                                          title: Text(
                                            'Berhasil register',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                          alignment: Alignment.topRight,
                                          direction: TextDirection.ltr,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          icon: const Icon(Icons.error_outline),
                                          primaryColor:
                                              GlobalColorTheme.successColor,
                                          backgroundColor: Colors.white,
                                          showIcon: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x07000000),
                                              blurRadius: 16,
                                              offset: Offset(0, 16),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        );
                                        debugPrint('Register successful');
                                        Navigator.push(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      });
                                    } catch (e) {
                                      toastification.show(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        autoCloseDuration:
                                            const Duration(seconds: 5),
                                        title: Text(
                                          'Gagal Register',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                        alignment: Alignment.topRight,
                                        direction: TextDirection.ltr,
                                        animationDuration:
                                            const Duration(milliseconds: 300),
                                        icon: const Icon(Icons.error_outline),
                                        primaryColor:
                                            GlobalColorTheme.errorColor,
                                        backgroundColor: Colors.white,
                                        showIcon: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
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
                                      debugPrint('Error login: $e');
                                    }
                                  }
                                }),
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
                            'Sudah punya akun? ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                            },
                            child: Text(
                              'Masuk',
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
