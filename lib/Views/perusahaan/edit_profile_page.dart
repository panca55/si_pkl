import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/perusahaan/profile_perusahaan_model.dart';
import 'package:si_pkl/provider/perusahaan/profile_perusahaan_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSubmitting = false;

  // Controllers untuk form fields
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _quotaController = TextEditingController();
  final _jamMulaiController = TextEditingController();
  final _jamBerakhirController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hpController = TextEditingController();
  final _emailPerusahaanController = TextEditingController();
  final _websiteController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();

  // State untuk foto
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  String? _currentImageUrl;

  // State untuk hari kerja
  String? _selectedMulaiHariKerja;
  String? _selectedAkhirHariKerja;

  final List<String> _hariKerjaOptions = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  ProfilePerusahaanModel? _profileData;

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _quotaController.dispose();
    _jamMulaiController.dispose();
    _jamBerakhirController.dispose();
    _deskripsiController.dispose();
    _hpController.dispose();
    _emailPerusahaanController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  void _populateFields(ProfilePerusahaanModel profile) {
    if (profile.profile != null) {
      final p = profile.profile!;
      _namaController.text = p.nama ?? '';
      _alamatController.text = p.alamat ?? '';
      _quotaController.text = p.quota?.toString() ?? '';
      _jamMulaiController.text = p.jamMulai ?? '';
      _jamBerakhirController.text = p.jamBerakhir ?? '';
      _deskripsiController.text = p.deskripsi ?? '';
      _hpController.text = p.hp ?? '';
      _emailPerusahaanController.text = p.emailPerusahaan ?? '';
      _websiteController.text = p.website ?? '';
      _instagramController.text = p.instagram ?? '';
      _tiktokController.text = p.tiktok ?? '';

      _selectedMulaiHariKerja = p.mulaiHariKerja;
      _selectedAkhirHariKerja = p.akhirHariKerja;

      if (p.foto != null) {
        _currentImageUrl =
            '${BaseApi.base}/storage/public/corporations-images/${p.foto}';
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedImageBytes = result.files.single.bytes;
          _selectedImageName = result.files.single.name;
        });
      }
    } catch (e) {
      _showSnackBar('Error memilih gambar: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_profileData?.profile?.id == null) {
      _showSnackBar('ID profile tidak ditemukan', isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final profileProvider =
          Provider.of<ProfilePerusahaanProvider>(context, listen: false);

      final data = {
        'nama': _namaController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'quota': int.tryParse(_quotaController.text.trim()) ?? 0,
        'mulai_hari_kerja': _selectedMulaiHariKerja ?? '',
        'akhir_hari_kerja': _selectedAkhirHariKerja ?? '',
        'jam_mulai': _jamMulaiController.text.trim(),
        'jam_berakhir': _jamBerakhirController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
        'hp': _hpController.text.trim(),
        'email_perusahaan': _emailPerusahaanController.text.trim(),
        'website': _websiteController.text.trim(),
        'instagram': _instagramController.text.trim(),
        'tiktok': _tiktokController.text.trim(),
      };

      await profileProvider.editProfilePerusahaan(
        id: _profileData!.profile!.id!,
        data: data,
        fileBytes: _selectedImageBytes,
        fileName: _selectedImageName,
      );

      _showSnackBar('Profile berhasil diupdate!');
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfilePerusahaanProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile Perusahaan',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF374151)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
        ],
      ),
      body: FutureBuilder(
        future: profileProvider.getProfilePerusahaan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            _isLoading = true;
          } else {
            _isLoading = false;
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data: ${snapshot.error}',
                      style: GoogleFonts.poppins(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          }

          final profile = profileProvider.profilePerusahaanModel;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Populate fields when data is loaded
          if (_profileData == null) {
            _profileData = profile;
            _populateFields(profile);
          }

          return Skeletonizer(
            enabled: _isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 20),
                    _buildFormCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.business,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            'Edit Profile Perusahaan',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Perbarui informasi perusahaan Anda',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            title: 'Foto Perusahaan',
            icon: Icons.photo_camera,
            child: _buildImagePicker(),
          ),
          const SizedBox(height: 32),
          _buildFormSection(
            title: 'Informasi Dasar',
            icon: Icons.info,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _namaController,
                  label: 'Nama Perusahaan',
                  placeholder: 'Masukkan nama perusahaan',
                  validator: (value) => value?.isEmpty == true
                      ? 'Nama perusahaan wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _alamatController,
                  label: 'Alamat',
                  placeholder: 'Masukkan alamat perusahaan',
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Alamat wajib diisi' : null,
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _emailPerusahaanController,
                  label: 'Email Perusahaan',
                  placeholder: 'company@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Email wajib diisi';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _hpController,
                  label: 'Nomor Telepon',
                  placeholder: '+62812345678',
                  keyboardType: TextInputType.phone,
                  validator: (value) => value?.isEmpty == true
                      ? 'Nomor telepon wajib diisi'
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildFormSection(
            title: 'Kapasitas & Jam Kerja',
            icon: Icons.schedule,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _quotaController,
                  label: 'Kuota Siswa',
                  placeholder: 'Masukkan jumlah kuota siswa',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value?.isEmpty == true)
                      return 'Kuota siswa wajib diisi';
                    if (int.tryParse(value!) == null)
                      return 'Masukkan angka yang valid';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Mulai Hari Kerja',
                        value: _selectedMulaiHariKerja,
                        items: _hariKerjaOptions,
                        onChanged: (value) =>
                            setState(() => _selectedMulaiHariKerja = value),
                        validator: (value) =>
                            value == null ? 'Pilih hari mulai kerja' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Akhir Hari Kerja',
                        value: _selectedAkhirHariKerja,
                        items: _hariKerjaOptions,
                        onChanged: (value) =>
                            setState(() => _selectedAkhirHariKerja = value),
                        validator: (value) =>
                            value == null ? 'Pilih hari akhir kerja' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        controller: _jamMulaiController,
                        label: 'Jam Mulai',
                        placeholder: '08:00',
                        validator: (value) => value?.isEmpty == true
                            ? 'Jam mulai wajib diisi'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextFormField(
                        controller: _jamBerakhirController,
                        label: 'Jam Berakhir',
                        placeholder: '17:00',
                        validator: (value) => value?.isEmpty == true
                            ? 'Jam berakhir wajib diisi'
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildFormSection(
            title: 'Media Sosial & Website',
            icon: Icons.public,
            child: Column(
              children: [
                _buildTextFormField(
                  controller: _websiteController,
                  label: 'Website',
                  placeholder: 'https://perusahaan.com',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _instagramController,
                  label: 'Instagram',
                  placeholder: '@perusahaan',
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _tiktokController,
                  label: 'TikTok',
                  placeholder: '@perusahaan',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildFormSection(
            title: 'Deskripsi Perusahaan',
            icon: Icons.description,
            child: _buildTextFormField(
              controller: _deskripsiController,
              label: 'Deskripsi',
              placeholder: 'Ceritakan tentang perusahaan Anda...',
              maxLines: 5,
              validator: (value) => value?.isEmpty == true
                  ? 'Deskripsi perusahaan wajib diisi'
                  : null,
            ),
          ),
          const SizedBox(height: 40),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF6366F1),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? placeholder,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
          validator: validator,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _selectedImageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _selectedImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : _currentImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _currentImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              size: 48,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.business,
                        size: 48,
                        color: Colors.grey,
                      ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_camera, size: 18),
            label: Text(
              _selectedImageBytes != null ? 'Ganti Foto' : 'Pilih Foto',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (_selectedImageName != null) ...[
            const SizedBox(height: 8),
            Text(
              'File dipilih: $_selectedImageName',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Menyimpan...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Simpan Perubahan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
