import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mixin untuk menangani back button behavior di dashboard
mixin BackButtonHandlerMixin<T extends StatefulWidget> on State<T> {
  /// Override method ini di setiap dashboard untuk mendefinisikan halaman default
  String get defaultPage => 'Dashboard';

  /// Override method ini untuk mendapatkan current page
  String get currentPage;

  /// Override method ini untuk mengubah current page
  void setCurrentPage(String page);

  /// Method untuk konfirmasi keluar aplikasi
  Future<bool> showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Keluar Aplikasi',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Keluar',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Method untuk menangani back button
  Future<void> handleBackButton(BuildContext context) async {
    // Cek apakah sedang berada di halaman default (Dashboard)
    if (currentPage == defaultPage) {
      // Jika di halaman default, tanyakan konfirmasi untuk keluar aplikasi
      final shouldExit = await showExitConfirmation(context);
      if (shouldExit) {
        // Keluar dari aplikasi
        Navigator.of(context).pop();
      }
    } else {
      // Jika tidak di halaman default, kembali ke halaman default
      setCurrentPage(defaultPage);
    }
  }

  /// Widget wrapper untuk menangani PopScope
  Widget buildWithBackButtonHandler(Widget child) {
    return PopScope(
      canPop: false, // Mencegah pop otomatis
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        await handleBackButton(context);
      },
      child: child,
    );
  }
}
