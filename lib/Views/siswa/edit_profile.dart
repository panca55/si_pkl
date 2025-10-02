import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/models/admin/mayors_model.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
import 'package:si_pkl/provider/siswa/profile_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _tahunMasukController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatSiswaController = TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();
  final TextEditingController _noHpSiswaController = TextEditingController();
  final TextEditingController _noHpOrtuController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedJenisKelamin;
  String? _selectedJurusan;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isLoading = false;
  bool _isSaving = false;
  List<String> _jurusanOptions = [];
  List<Mayor> _mayors = [];

  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMayors();
    });
  }

  Future<void> _loadMayors() async {
    final mayorsProvider = Provider.of<MayorsProvider>(context, listen: false);
    await mayorsProvider.getMayors();
    if (mounted) {
      setState(() {
        _mayors = mayorsProvider.mayors;
        _jurusanOptions = _mayors.map((mayor) => mayor.nama ?? '').toList();

        // Set selected jurusan if it matches one of the loaded options
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        final siswa = profileProvider.currentSiswa;
        if (siswa?.mayor?.nama != null &&
            _jurusanOptions.contains(siswa!.mayor!.nama)) {
          _selectedJurusan = siswa.mayor!.nama;
        }
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisnController.dispose();
    _tahunMasukController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatSiswaController.dispose();
    _alamatOrtuController.dispose();
    _noHpSiswaController.dispose();
    _noHpOrtuController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final authProvider = Provider.of<AuthController>(context);
    final mayorsProvider = Provider.of<MayorsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: profileProvider.getProfileSiswa(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !_isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Initialize form data
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _initializeFormData(profileProvider, authProvider);
                  });

                  return _buildForm();
                }
              },
            ),
    );
  }

  void _initializeFormData(
      ProfileProvider profileProvider, AuthController authProvider) {
    final siswa = profileProvider.currentSiswa;
    final user = authProvider.currentUser?.user;

    if (siswa != null && !_isLoading) {
      _namaController.text = siswa.nama ?? '';
      _nisnController.text = siswa.nisn ?? '';
      _tahunMasukController.text = siswa.tahunMasuk ?? '';
      _tempatLahirController.text = siswa.tempatLahir ?? '';
      _selectedJenisKelamin = siswa.jenisKelamin == 'PRIA'
          ? 'Laki-laki'
          : siswa.jenisKelamin == 'WANITA'
              ? 'Perempuan'
              : siswa.jenisKelamin;
      _alamatSiswaController.text = siswa.alamatSiswa ?? '';
      _alamatOrtuController.text = siswa.alamatOrtu ?? '';
      _noHpSiswaController.text = siswa.hpSiswa ?? '';
      _noHpOrtuController.text = siswa.hpOrtu ?? '';

      if (siswa.tanggalLahir != null) {
        try {
          DateTime tanggalLahir = DateTime.parse(siswa.tanggalLahir!);
          _tanggalLahirController.text =
              DateFormat('yyyy-MM-dd').format(tanggalLahir);
        } catch (e) {
          debugPrint('Error parsing tanggal lahir: $e');
        }
      }

      // Note: _selectedJurusan is now set in _loadMayors after mayors data is loaded
    }

    if (user != null) {
      _usernameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
    }

    _isLoading = false;
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                      image: _selectedImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_selectedImageBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImageBytes == null
                        ? Consumer<ProfileProvider>(
                            builder: (context, profileProvider, child) {
                              final siswa = profileProvider.currentSiswa;
                              return siswa?.foto != null
                                  ? ClipOval(
                                      child: Image.network(
                                        '${BaseApi.studentImageUrl}/${siswa!.foto}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    );
                            },
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap untuk mengubah foto',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),

            // User Information Section
            _buildSectionTitle('Informasi Akun'),
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Student Information Section
            _buildSectionTitle('Informasi Siswa'),
            _buildTextField(
              controller: _namaController,
              label: 'Nama Lengkap',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nisnController,
              label: 'NISN',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Jenis Kelamin',
              value: _selectedJenisKelamin,
              items: _jenisKelaminOptions,
              onChanged: (value) {
                setState(() {
                  _selectedJenisKelamin = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Jurusan',
              value: _jurusanOptions.contains(_selectedJurusan)
                  ? _selectedJurusan
                  : null,
              items: _jurusanOptions.isEmpty ? ['Loading...'] : _jurusanOptions,
              onChanged: (value) {
                setState(() {
                  _selectedJurusan = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _tempatLahirController,
                    label: 'Tempat Lahir',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    controller: _tanggalLahirController,
                    label: 'Tanggal Lahir',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _tahunMasukController,
              label: 'Tahun Masuk',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _alamatSiswaController,
              label: 'Alamat Siswa',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _alamatOrtuController,
              label: 'Alamat Orang Tua',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _noHpSiswaController,
                    label: 'No HP Siswa',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _noHpOrtuController,
                    label: 'No HP Orang Tua',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () => _saveProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Simpan Perubahan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.indigo),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: GoogleFonts.poppins()),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.indigo),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pilih $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1990),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            }
          },
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.indigo),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageName = image.name;
      });
    }
  }

  Future<void> _saveProfile() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation for required fields
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if required data is loaded
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AuthController>();
    final siswa = profileProvider.currentSiswa;
    final user = authProvider.currentUser?.user;

    if (user == null || user.name == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Data user belum dimuat. Silakan tunggu sebentar dan coba lagi.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (siswa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Data siswa belum dimuat. Silakan tunggu sebentar dan coba lagi.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (siswa.id == null) {
        throw Exception('Data siswa tidak ditemukan');
      }

      // Debug prints
      debugPrint('Username: ${_usernameController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Nama: ${_namaController.text}');
      debugPrint('User from auth: ${user.name}, ${user.email}');

      // Get mayor_id from selected jurusan
      int? mayorId;
      if (_selectedJurusan != null && _mayors.isNotEmpty) {
        final selectedMayor = _mayors.firstWhere(
          (mayor) => mayor.nama == _selectedJurusan,
          orElse: () => Mayor(id: null, nama: null),
        );
        mayorId = selectedMayor.id;
      }

      // Prepare data for API (exclude username and email to avoid validation errors)
      final data = {
        'user_id': siswa.userId,
        'nama': _namaController.text.trim(),
        'nisn': _nisnController.text.trim(),
        'jenis_kelamin': _selectedJenisKelamin == 'Laki-laki'
            ? 'PRIA'
            : _selectedJenisKelamin == 'Perempuan'
                ? 'WANITA'
                : _selectedJenisKelamin,
        'tempat_lahir': _tempatLahirController.text.trim(),
        'tanggal_lahir': _tanggalLahirController.text.trim(),
        'tahun_masuk': _tahunMasukController.text.trim(),
        'alamat_siswa': _alamatSiswaController.text.trim(),
        'alamat_ortu': _alamatOrtuController.text.trim(),
        'hp_siswa': _noHpSiswaController.text.trim(),
        'hp_ortu': _noHpOrtuController.text.trim(),
        if (mayorId != null) 'mayor_id': mayorId,
        // Keep existing photo if no new photo selected
        if (_selectedImageBytes == null) 'oldImage': siswa.foto,
      };

      debugPrint('Data to send (UPDATED - no username/email): $data');

      await profileProvider.updateStudentProfile(
        id: siswa.id!,
        data: data,
        fileBytes: _selectedImageBytes,
        fileName: _selectedImageName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Go back to profile page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
