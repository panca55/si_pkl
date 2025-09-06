import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/guru/dashboard_side_guru.dart';
import 'package:si_pkl/controller/auth_controller.dart';
// import 'package:si_pkl/Views/siswa/dashboard_side.dart';
import 'package:si_pkl/provider/guru/profile_guru_provider.dart';

class EditProfileGuru extends StatefulWidget {
  static const String routeName = '/profile-guru-edit';
  final int? profileId;
  final int? userId;
  const EditProfileGuru({super.key, this.profileId, this.userId});

  @override
  State<EditProfileGuru> createState() => _EditProfileGuruState();
}

class _EditProfileGuruState extends State<EditProfileGuru> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _golonganController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _bidangStudiController = TextEditingController();
  final TextEditingController _pendidikanTerakhirController =
      TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedJenisKelamin;
  String? selectedStatus;
  String? selectedGolongan;
  DateTime? selectedDate;
  Uint8List? fileBytes;
  String? fileName;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
    _loadUserData();
  }

  void _loadUserData() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final user = authController.currentUser?.user;
    if (user != null) {
      setState(() {
        _usernameController.text = user.name ?? '';
        _emailController.text = user.email ?? '';
        // Don't pre-fill password for security reasons
        _passwordController.text = '';
      });
    }
  }

  void _loadTeacherData() {
    final profileProvider =
        Provider.of<ProfileGuruProvider>(context, listen: false);
    final teacher = profileProvider.currentguru?.teacher;
    if (teacher != null) {
      setState(() {
        _nipController.text = teacher.nip ?? '';
        _namaController.text = teacher.nama ?? '';
        _golonganController.text = teacher.golongan ?? '';
        _jabatanController.text = teacher.jabatan ?? '';
        _bidangStudiController.text = teacher.bidangStudi ?? '';
        _pendidikanTerakhirController.text = teacher.pendidikanTerakhir ?? '';
        _tempatLahirController.text = teacher.tempatLahir ?? '';
        _alamatController.text = teacher.alamat ?? '';
        _noHpController.text = teacher.hp ?? '';

        // Set dropdown values (sesuaikan dengan property yang ada di model Teacher)
        selectedGolongan = teacher.golongan;
        selectedJenisKelamin = teacher.jenisKelamin;

        // Determine status based on NIP (if NIP exists, likely PNS)
        if (teacher.nip != null && teacher.nip!.isNotEmpty) {
          selectedStatus = 'pns';
        } else {
          selectedStatus = 'non_pns';
        }

        if (teacher.tanggalLahir != null) {
          selectedDate = DateTime.parse(teacher.tanggalLahir!);
          _tanggalLahirController.text =
              DateFormat('yyyy-MM-dd').format(selectedDate!);
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nipController.dispose();
    _namaController.dispose();
    _golonganController.dispose();
    _jabatanController.dispose();
    _bidangStudiController.dispose();
    _pendidikanTerakhirController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _jenisKelaminController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileGuruProvider>(context, listen: false);
    // final authController = Provider.of<AuthController>(context, listen: false);
    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result != null) {
        // Validasi ukuran file (contoh: maksimum 2 MB)
        const maxFileSize = 2 * 1024 * 1024; // 2 MB dalam byte
        if (result.files.single.size > maxFileSize) {
          debugPrint(
              'File terlalu besar, pilih file yang lebih kecil dari 2MB');
          return;
        }

        fileBytes = result.files.single.bytes;
        fileName = result.files.single.name;

        // Pastikan format file benar
        final validExtensions = ['jpg', 'jpeg', 'png'];
        final extension = fileName!.split('.').last.toLowerCase();
        if (!validExtensions.contains(extension)) {
          debugPrint(
              'Format file tidak didukung. Pilih file JPG, JPEG, atau PNG.');
          return;
        }

        debugPrint('File dipilih: $fileName');
      }
    }

    final Map<String, String> status = {'non_pns': 'NON PNS', 'pns': 'PNS'};
    final int currentYear =
        int.parse(DateFormat('yyyy').format(DateTime.now()));
    const int startYear = 2000;
    List<String> tahunAjaranList = [];
    for (int i = startYear; i <= currentYear; i++) {
      tahunAjaranList.add('$i/${i + 1}');
    }

    Future<void> pickDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        selectedDate = pickedDate;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StatefulBuilder(
          builder: (context, void Function(void Function()) setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Text(
                  'Edit Data Diri Guru',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    _buildTextField(
                        controller: _usernameController,
                        label: 'Useraname',
                        validator: 'username harus diisi'
                        // enabled: false,
                        ),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        validator: 'email harus diisi'
                        // enabled: false,
                        ),
                    // _buildTextField(
                    //     controller: _passwordController,
                    //     label: 'Password',
                    //     validator: 'password harus diisi'
                    //     // enabled: false,
                    //     ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Status Kepegawaian',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "STATUS KEPEGAWAIAN",
                        border: OutlineInputBorder(),
                      ),
                      items: status.entries
                          .map((entry) => DropdownMenuItem(
                              value: entry.key, child: Text(entry.value)))
                          .toList(),
                      value: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Golongan harus dipilih';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (selectedStatus == 'pns') ...[
                  _buildTextField(
                      controller: _nipController,
                      label: 'NIP',
                      validator: 'nip harus diisi'
                      // enabled: false,
                      ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "GOLOGNGAN PNS",
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'I/a',
                      'I/b',
                      'I/c',
                      'I/d',
                      'II/a',
                      'II/b',
                      'II/c',
                      'II/d',
                      'III/a',
                      'III/b',
                      'III/c',
                      'III/d',
                      'IV/a',
                      'IV/b',
                      'IV/c',
                      'IV/d',
                      'IV/e'
                    ]
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    value: selectedGolongan,
                    onChanged: (value) {
                      setState(() {
                        selectedGolongan = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Golongan harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                _buildTextField(
                    controller: _namaController,
                    label: 'Nama Lengkap',
                    validator: 'nama harus diisi'
                    // enabled: false,
                    ),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _bidangStudiController,
                    label: 'Bidang Studi',
                    validator: 'nama harus diisi'
                    // enabled: false,
                    ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          controller: _pendidikanTerakhirController,
                          label: 'Pendidikan Terakhir',
                          validator: 'pendidikan terakhir harus diisi'
                          // enabled: false,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                          controller: _jabatanController,
                          label: 'Jabatan',
                          validator: 'jabatan harus diisi'
                          // enabled: false,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Tanggal lahir',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: _tanggalLahirController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.calendar_month,
                                color: Colors.black,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: "Pilih Tanggal",
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              await pickDate(context);
                              setState(() {
                                _tanggalLahirController.text = selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                          controller: _tempatLahirController,
                          label: 'Tempat Lahir',
                          validator: 'tempat harus diisi'
                          // enabled: false,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Jenis Kelamin',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: "JENIS KELAMIN",
                              border: OutlineInputBorder(),
                            ),
                            items: ['PRIA', 'WANITA']
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            value: selectedJenisKelamin,
                            onChanged: (value) {
                              setState(() {
                                selectedJenisKelamin = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'jenis kelamin harus dipilih';
                              }
                              return null;
                            },
                          ),
                        ],
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
                          validator: 'alamat harus diisi'
                          // enabled: false,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _noHpController,
                    label: 'No HP',
                    validator: 'no hp harus diisi'
                    // enabled: false,
                    ),
                const SizedBox(height: 16),
                if (fileBytes != null)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Image.memory(fileBytes!)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pickFile().then((value) {
                          setState(() {
                            debugPrint("UI diperbarui, fileName: $fileName");
                            fileName = fileName;
                            fileBytes = fileBytes;
                          });
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
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
                          'Pilih gambar',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (fileName != null)
                      Expanded(
                        child: Text(fileName!,
                            style: GoogleFonts.poppins(fontSize: 12)),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    debugPrint('Menyimpan perubahan profile guru...');
                    debugPrint('teacher ID: ${widget.profileId}');
                    debugPrint('user ID: ${widget.userId}');
                    final Map<String, dynamic> data = {
                      // Don't send username and email to avoid unique validation errors
                      // "username": _usernameController.text.trim(),
                      // "email": _emailController.text.trim(),
                      "status": selectedStatus ?? '',
                      "nip": _nipController.text,
                      "nama": _namaController.text,
                      "golongan": selectedGolongan ?? '',
                      "bidang_studi": _bidangStudiController.text,
                      "pendidikan_terakhir": _pendidikanTerakhirController.text,
                      "jabatan": _jabatanController.text,
                      "jenis_kelamin": selectedJenisKelamin ?? '',
                      "tanggal_lahir": selectedDate?.toIso8601String() ?? '',
                      "tempat_lahir": _tempatLahirController.text,
                      "alamat": _alamatController.text,
                      "hp": _noHpController.text,
                    };
                    debugPrint('data: ${data.entries.toList()}');
                    try {
                      if (formKey.currentState!.validate()) {
                        if (selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tanggal lahir harus dipilih')),
                          );
                          return;
                        }

                        // Additional validation for required fields
                        if (_namaController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Nama tidak boleh kosong')),
                          );
                          return;
                        }

                        if (selectedJenisKelamin == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Jenis kelamin harus dipilih')),
                          );
                          return;
                        }

                        debugPrint(
                            'Teacher ID yang akan diupdate: ${profileProvider.currentguru?.teacher?.id}');

                        // Make foto optional for edit
                        await profileProvider.editProfileGuru(
                            id: profileProvider.currentguru?.teacher?.id ?? 0,
                            data: data,
                            fileBytes: fileBytes,
                            fileName: fileName,
                            filePath: fileName);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile berhasil diupdate'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      debugPrint('gagal menyimpan profile: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menyimpan profile: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF04aa6d),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 4))
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Fungsi untuk membuat TextField dengan konfigurasi yang sering digunakan
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validator,
    bool enabled = false,
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
        TextFormField(
          textInputAction: TextInputAction.done,
          maxLines: 1,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validator;
            }
            return null;
          },
        ),
      ],
    );
  }
}
