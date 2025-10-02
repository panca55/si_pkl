import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/Views/instruktur/edit_profile_instruktur.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/provider/instruktur/profile_instruktur_provider.dart';

class ProfileInstruktur extends StatefulWidget {
  const ProfileInstruktur({super.key});

  @override
  State<ProfileInstruktur> createState() => _ProfileInstrukturState();
}

class _ProfileInstrukturState extends State<ProfileInstruktur> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tempatTanggalLahirController =
      TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  @override
  void dispose() {
    _nipController.dispose();
    _namaController.dispose();
    _tempatTanggalLahirController.dispose();
    _jenisKelaminController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileInstrukturProvider>(context, listen: false);
    final authProvider = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: profileProvider.getProfileguru(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Ambil data siswa
            final instruktur = profileProvider.currentInstruktur?.profile;
            if (instruktur == null) {
              return const Center(
                  child: Text('Data instruktur tidak ditemukan.'));
            }
            dynamic tanggalLahirNull = instruktur.tanggalLahir == 'Belum diisi'
                ? 'Belum diisi'
                : DateFormat('dd MMMM yyyy', 'id_ID')
                    .format(DateTime.parse(instruktur.tanggalLahir!));
            // DateTime tanggalLahir = DateTime.parse(instruktur.tanggalLahir!);
            // String formattedDate =
            //     DateFormat('dd MMMM yyyy', 'id_ID').format(tanggalLahir);
            _nipController.text = instruktur.nip ?? 'Belum diiisi';
            _namaController.text = instruktur.nama ?? 'Belum diisi';
            _tempatTanggalLahirController.text =
                '${instruktur.tempatLahir ?? 'Belum diisi'}, $tanggalLahirNull';
            _jenisKelaminController.text =
                instruktur.jenisKelamin ?? 'Belum diisi';
            _alamatController.text = instruktur.alamat ?? 'Belum diisi';
            _noHpController.text = instruktur.hp ?? 'Belum diisi';
            final emailInstruktur =
                authProvider.currentUser?.user?.email ?? 'Belum diisi';
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Image.network(
                    '${BaseApi.instructorImageUrl}/${instruktur.foto}',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    emailInstruktur,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _nipController,
                          label: 'NIP',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _namaController,
                          label: 'Nama Lengkap',
                          // enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _tempatTanggalLahirController,
                          label: 'Tempat Tanggal Lahir',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _jenisKelaminController,
                          label: 'Jenis Kelamin',
                          // enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _alamatController,
                          label: 'Alamat',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _noHpController,
                          label: 'No HP',
                          // enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      debugPrint('Edit Profile Tapped. ID: ${instruktur.id}');
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => EditProfileInstruktur(
                            id: instruktur.id!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membuat TextField dengan konfigurasi yang sering digunakan
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextField(
          scrollController: ScrollController(),
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          scrollPadding: const EdgeInsets.all(10),
          textInputAction: TextInputAction.done,
          maxLines: 1,
          expands: false,
          controller: controller,
          style: GoogleFonts.poppins(color: Colors.black),
          readOnly: enabled,
          decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: label,
            labelStyle: GoogleFonts.poppins(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
