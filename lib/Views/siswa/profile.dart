import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/Views/perusahaan/edit_profile_page.dart';
import 'package:si_pkl/Views/siswa/edit_profile.dart';
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

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.getProfileSiswa();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

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
    final authProvider = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $_error',
                        style: GoogleFonts.poppins(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfileData,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    // Ambil data siswa
                    final siswa = profileProvider.currentSiswa;
                    if (siswa == null) {
                      return const Center(
                          child: Text('Data siswa tidak ditemukan.'));
                    }
                    debugPrint(
                      'foto: ${BaseApi.profileStudentImageUrl}/${siswa.foto}',
                    );
                    DateTime tanggalLahir = DateTime.parse(siswa.tanggalLahir!);
                    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID')
                        .format(tanggalLahir);
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
                          // Profile image
                          Center(
                            child: ClipOval(
                              child:
                                  siswa.foto != null 
                                      ? Image.network(
                                          '${BaseApi.profileStudentImageUrl}/${siswa.foto}',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 100,
                                              color: Colors.grey,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _namaController,
                            label: 'Nama Lengkap',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _jurusanController,
                                  label: 'Jurusan',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _kelasController,
                                  label: 'Kelas',
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
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _tempatTanggalLahirController,
                                  label: 'Tempat Tanggal Lahir',
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
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _alamatOrtuController,
                                  label: 'Alamat Orang Tua',
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
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _noHpOrtuController,
                                  label: 'No HP Orang Tua',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _noHpSiswaController,
                            label: 'No HP Siswa',
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const EditProfile(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  } // Fungsi untuk membuat TextField dengan konfigurasi yang sering digunakan

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
