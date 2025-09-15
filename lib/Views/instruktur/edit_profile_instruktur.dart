import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/guru/dashboard_side_guru.dart';
import 'package:si_pkl/provider/instruktur/profile_instruktur_provider.dart';

class EditProfileInstruktur extends StatefulWidget {
  final int id;

  const EditProfileInstruktur({
    super.key,
    required this.id,
  });

  @override
  State<EditProfileInstruktur> createState() => _EditProfileInstrukturState();
}

class _EditProfileInstrukturState extends State<EditProfileInstruktur> {
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
  int? selectedCorporationId;
  DateTime? selectedDate;
  Uint8List? fileBytes;
  String? fileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadProfileData();
      _loadInstrukturData();
    });
  }

  Future<void> _loadProfileData() async {
    final profileProvider =
        Provider.of<ProfileInstrukturProvider>(context, listen: false);
    try {
      await profileProvider.getProfileguru();
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }
  }

  void _loadInstrukturData() {
    final profileProvider =
        Provider.of<ProfileInstrukturProvider>(context, listen: false);
    final instruktur = profileProvider.currentInstruktur?.profile;

    if (instruktur != null) {
      setState(() {
        _nipController.text = instruktur.nip ?? '';
        _namaController.text = instruktur.nama ?? '';
        _tempatLahirController.text = instruktur.tempatLahir ?? '';
        _alamatController.text = instruktur.alamat ?? '';
        _noHpController.text = instruktur.hp ?? '';

        // Set dropdown values
        selectedJenisKelamin = instruktur.jenisKelamin;
        selectedCorporationId =
            instruktur.corporationId ?? 1; // Default to 1 if null

        if (instruktur.tanggalLahir != null &&
            instruktur.tanggalLahir!.isNotEmpty) {
          try {
            selectedDate = DateTime.parse(instruktur.tanggalLahir!);
            _tanggalLahirController.text =
                DateFormat('yyyy-MM-dd').format(selectedDate!);
          } catch (e) {
            debugPrint('Error parsing date: $e');
          }
        }
      });
    }
  }

  @override
  void dispose() {
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
        Provider.of<ProfileInstrukturProvider>(context, listen: false);
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

    final int currentYear =
        int.parse(DateFormat('yyyy').format(DateTime.now()));
    const int startYear = 2000;
    List<String> tahunAjaranList = [];
    for (int i = startYear; i <= currentYear; i++) {
      tahunAjaranList.add('$i/${i + 1}');
    }
    String? selectedJenisKelamin;
    int? selectedCorporationId;
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
                  'Isi Data Diri Instruktur',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          controller: _nipController,
                          label: 'NIP',
                          validator: 'nip harus diisi'
                          // enabled: false,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                          controller: _namaController,
                          label: 'Nama Lengkap',
                          validator: 'nama lengkap harus diisi'
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
                          controller: _tempatLahirController,
                          label: 'Tempat Lahir',
                          validator: 'tempat harus diisi'
                          // enabled: false,
                          ),
                    ),
                    const SizedBox(width: 16),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                          controller: _noHpController,
                          label: 'No HP',
                          validator: 'no hp harus diisi'
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
                      "corporation_id": selectedCorporationId,
                      "nip": _nipController.text,
                      "nama": _namaController.text,
                      "jenis_kelamin": selectedJenisKelamin,
                      "tanggal_lahir": selectedDate?.toIso8601String(),
                      "tempat_lahir": _tempatLahirController.text,
                      "alamat": _alamatController.text,
                      "hp": _noHpController.text,
                    };
                    debugPrint('data: ${data.entries.toList()}');
                    try {
                      if (formKey.currentState!.validate() &&
                          selectedDate != null) {
                        await profileProvider.editProfileInstruktur(
                            id: widget.id,
                            data: data,
                            fileBytes: fileBytes,
                            fileName: fileName,
                            filePath: fileName);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const DashboardSideGuru()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Silakan isi semua field dan pilih tanggal'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint('gagal menyimpan profile: $e');
                      // ignore: use_build_context_synchronously
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
