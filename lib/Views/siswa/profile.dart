import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/provider/siswa/profile_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _tahunMasukController = TextEditingController();
  final TextEditingController _tempatTanggalLahirController =
      TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();
  final TextEditingController _alamatSiswaController = TextEditingController();
  final TextEditingController _noHpOrtuController = TextEditingController();
  final TextEditingController _noHpSiswaController = TextEditingController();

  @override
  void dispose() {
    _nisnController.dispose();
    _namaController.dispose();
    _jurusanController.dispose();
    _kelasController.dispose();
    _tahunMasukController.dispose();
    _tempatTanggalLahirController.dispose();
    _jenisKelaminController.dispose();
    _alamatOrtuController.dispose();
    _alamatSiswaController.dispose();
    _noHpOrtuController.dispose();
    _noHpSiswaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final authProvider = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: profileProvider.getProfileSiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Ambil data siswa
            final siswa = profileProvider.currentSiswa;
            if (siswa == null) {
              return const Center(child: Text('Data siswa tidak ditemukan.'));
            }
            DateTime tanggalLahir = DateTime.parse(siswa.tanggalLahir!);
            String formattedDate =
                DateFormat('dd MMMM yyyy', 'id_ID').format(tanggalLahir);
            _nisnController.text = siswa.nisn ?? '';
            _namaController.text = siswa.nama ?? '';
            _jurusanController.text = siswa.mayor?.nama ?? '';
            _kelasController.text = siswa.konsentrasi ?? '';
            _tahunMasukController.text = siswa.tahunMasuk ?? '';
            _tempatTanggalLahirController.text =
                '${siswa.tempatLahir ?? ''}, $formattedDate';
            _jenisKelaminController.text = siswa.jenisKelamin ?? '';
            _alamatOrtuController.text = siswa.alamatOrtu ?? '';
            _alamatSiswaController.text = siswa.alamatSiswa ?? '';
            _noHpOrtuController.text = siswa.hpOrtu ?? '';
            _noHpSiswaController.text = siswa.hpSiswa ?? '';
            final emailSiswa = authProvider.currentUser?.user?.email;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Image.network(
                    'https://sigapkl-smkn2padang.com/storage/public/students-images/${siswa.foto}',
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                  Text(
                    emailSiswa ?? 'email error',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nisnController,
                    label: 'NISN',
                    // enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _namaController,
                    label: 'Nama Lengkap',
                    // enabled: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _jurusanController,
                          label: 'Jurusan',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _kelasController,
                          label: 'Kelas',
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
                          controller: _tahunMasukController,
                          label: 'Tahun Masuk',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _tempatTanggalLahirController,
                          label: 'Tempat Tanggal Lahir',
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
                          controller: _jenisKelaminController,
                          label: 'Jenis Kelamin',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _alamatOrtuController,
                          label: 'Alamat Orang Tua',
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
                          controller: _alamatSiswaController,
                          label: 'Alamat Siswa',
                          // enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _noHpOrtuController,
                          label: 'No HP Orang Tua',
                          // enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _noHpSiswaController,
                    label: 'No HP Siswa',
                    // enabled: false,
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
            label,
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
