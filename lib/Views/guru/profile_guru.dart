import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/Views/guru/edit_profile_guru.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/provider/guru/profile_guru_provider.dart';

class ProfileGuru extends StatefulWidget {
  const ProfileGuru({super.key});

  @override
  State<ProfileGuru> createState() => _ProfileGuruState();
}

class _ProfileGuruState extends State<ProfileGuru> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _golonganController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _bidangStudiController = TextEditingController();
  final TextEditingController _pendidikanTerakhirController =
      TextEditingController();
  final TextEditingController _tempatTanggalLahirController =
      TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  // Add refresh key to force FutureBuilder to rebuild
  Key _futureKey = UniqueKey();

  void _refreshProfile() {
    setState(() {
      _futureKey = UniqueKey();
    });
    // Also refresh from provider
    final profileProvider =
        Provider.of<ProfileGuruProvider>(context, listen: false);
    profileProvider.refreshProfile();
  }

  @override
  void initState() {
    super.initState();
    // Clear any cached data when entering profile page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileGuruProvider>(context, listen: false);
      // Clear cached data to ensure fresh data on page load
      profileProvider.clearProfileData();
    });
  }

  @override
  void dispose() {
    _nipController.dispose();
    _namaController.dispose();
    _golonganController.dispose();
    _jabatanController.dispose();
    _bidangStudiController.dispose();
    _pendidikanTerakhirController.dispose();
    _tempatTanggalLahirController.dispose();
    _jenisKelaminController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileGuruProvider>(context, listen: false);
    final authProvider = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        key: _futureKey, // Add key to force rebuild
        future: profileProvider.getProfileguru(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Ambil data siswa
            final guru = profileProvider.currentguru?.teacher;
            if (guru == null) {
              return const Center(child: Text('Data guru tidak ditemukan.'));
            }
            debugPrint('url: ${BaseApi.base}');
            DateTime tanggalLahir = DateTime.parse(guru.tanggalLahir!);
            String formattedDate =
                DateFormat('dd MMMM yyyy', 'id_ID').format(tanggalLahir);
            _nipController.text = guru.nip ?? '';
            _namaController.text = guru.nama ?? '';
            _golonganController.text = guru.golongan ?? '';
            _jabatanController.text = guru.jabatan ?? '';
            _bidangStudiController.text = guru.bidangStudi ?? '';
            _pendidikanTerakhirController.text = guru.pendidikanTerakhir ?? '';
            _tempatTanggalLahirController.text =
                '${guru.tempatLahir ?? ''}, $formattedDate';
            _jenisKelaminController.text = guru.jenisKelamin ?? '';
            _alamatController.text = guru.alamat ?? '';
            _noHpController.text = guru.hp ?? '';
            final emailSiswa = authProvider.currentUser?.user?.email;

            return RefreshIndicator(
              onRefresh: () async {
                _refreshProfile();
                // Wait a bit for the new FutureBuilder to complete
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Image.network(
                      '${BaseApi.teacherImageUrl}/${guru.foto}',
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
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
                      controller: _nipController,
                      label: 'NIP',
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
                            controller: _golonganController,
                            label: 'Golongan',
                            // enabled: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _jabatanController,
                            label: 'Jabatan',
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _alamatController,
                            label: 'Alamat Guru',
                            // enabled: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _noHpController,
                      label: 'No HP Guru',
                      // enabled: false,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        debugPrint('Edit Profile Tapped. ID: ${guru.id}');
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute<bool>(
                            builder: (BuildContext context) => EditProfileGuru(
                              profileId: guru.id,
                              userId: authProvider.currentUser?.user?.id,
                            ),
                          ),
                        );

                        // Refresh profile data if edit was successful
                        if (result == true) {
                          _refreshProfile();
                        }
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
