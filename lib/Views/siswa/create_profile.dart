import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/siswa/dashboard_side.dart';
import 'package:si_pkl/models/admin/mayors_model.dart';
import 'package:si_pkl/provider/siswa/profile_provider.dart';

class CreateProfile extends StatefulWidget {
  final List<Mayor>? kelasList;
  const CreateProfile({super.key, required this.kelasList});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _konsentrasiController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _tahunMasukController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _alamatOrtuController = TextEditingController();
  final TextEditingController _alamatSiswaController = TextEditingController();
  final TextEditingController _noHpOrtuController = TextEditingController();
  final TextEditingController _noHpSiswaController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nisnController.dispose();
    _namaController.dispose();
    _konsentrasiController.dispose();
    _kelasController.dispose();
    _tahunMasukController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
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
    Uint8List? fileBytes;
    String? fileName;
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

    int? selectedKelas;
    final kelasList = widget.kelasList?.toList() ?? [];
    final int currentYear =
        int.parse(DateFormat('yyyy').format(DateTime.now()));
    const int startYear = 2000;
    List<String> tahunAjaranList = [];
    for (int i = startYear; i <= currentYear; i++) {
      tahunAjaranList.add('$i/${i + 1}');
    }
    String? tahunAjaran;
    String? selectedJenisKelamin;
    DateTime? selectedDate;

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

    debugPrint('List kelas: $kelasList');

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
                  'Isi Data Diri Anda',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _namaController,
                    label: 'Nama Lengkap',
                    validator: 'nama lengkap harus diisi'
                    // enabled: false,
                    ),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _nisnController,
                    label: 'NISN',
                    validator: 'nisn harus diisi'
                    // enabled: false,
                    ),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _konsentrasiController,
                    label: 'Konsentrasi',
                    validator: 'konsentrasi harus diisi'
                    // enabled: false,
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
                              'Tahun Ajaran',
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
                              labelText: "TAHUN AJARAN",
                              border: OutlineInputBorder(),
                            ),
                            value: tahunAjaran,
                            onChanged: (newValue) {
                              setState(() {
                                tahunAjaran = newValue;
                              });
                            },
                            items: tahunAjaranList.map((tahunAjaran) {
                              return DropdownMenuItem<String>(
                                value: tahunAjaran,
                                child: Text(tahunAjaran),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'tahun ajaran harus dipilih';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Kelas',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: "KELAS",
                              border: OutlineInputBorder(),
                            ),
                            items: kelasList
                                .map((kelas) => DropdownMenuItem<int>(
                                      value: kelas.id,
                                      child: Text(kelas.nama ?? ''),
                                    ))
                                .toList(),
                            value: selectedKelas,
                            onChanged: (value) {
                              setState(() {
                                selectedKelas = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Kelas harus dipilih';
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
                          // enabled: false,
                          validator: 'tempat lahir harus diisi'),
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
                const SizedBox(width: 16),
                _buildTextField(
                    controller: _alamatSiswaController,
                    label: 'Alamat Siswa',
                    // enabled: false,
                    validator: 'alamat siswa harus diisi'),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _alamatOrtuController,
                    label: 'Alamat Orang Tua',
                    validator: 'alamat orang tua harus diisi'
                    // enabled: false,
                    ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          controller: _noHpOrtuController,
                          label: 'No HP Orang Tua',
                          validator: 'no hp ortu harus diisi'
                          // enabled: false,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                          controller: _noHpSiswaController,
                          label: 'No HP Siswa',
                          validator: 'no hp siswa harus diisi'
                          // enabled: false,
                          ),
                    ),
                  ],
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
                    final Map<String, dynamic> data = {
                      "mayor_id": selectedKelas,
                      "nisn": _nisnController.text,
                      "nama": _namaController.text,
                      "konsentrasi": _konsentrasiController.text,
                      "tahun_masuk": tahunAjaran,
                      "jenis_kelamin": selectedJenisKelamin,
                      "tanggal_lahir": selectedDate?.toIso8601String(),
                      "tempat_lahir": _tempatLahirController.text,
                      "alamat_siswa": _alamatSiswaController.text,
                      "alamat_ortu": _alamatOrtuController.text,
                      "hp_siswa": _noHpSiswaController.text,
                      "hp_ortu": _noHpOrtuController.text,
                    };
                    debugPrint('data: ${data.entries.toList()}');
                    try {
                      if (formKey.currentState!.validate() &&
                          selectedDate != null &&
                          fileBytes != null) {
                        await profileProvider.createProfile(
                            data: data,
                            fileBytes: fileBytes!,
                            fileName: fileName!,
                            filePath: fileName!
                            );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DashboardSide()),
                        );
                      }
                    } catch (e) {
                      debugPrint('gagal menyimpan profile: $e');
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
          validator: (value) {
            if (value == null) {
              return validator;
            }
            return null;
          },
        ),
      ],
    );
  }
}
