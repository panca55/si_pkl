import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:si_pkl/models/admin/instructors_model.dart';
import 'package:si_pkl/models/admin/users_model.dart' as user;
import 'package:si_pkl/models/admin/corporations_model.dart' as corporation;

Future<void> showEditInstrukturPopup(
    {required user.User? user,
    required corporation.Corporations? perusahaan,
    required Instructor instructor,
    required BuildContext context,
    required Function(
            Map<String, dynamic> data, Uint8List fileBytes, String? fileName)
        onSubmit}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController namaPerusahaanController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  String? selectedJenisKelamin = instructor.jenisKelamin;
  nameController.text = instructor.nama ?? '';
  nipController.text = instructor.nip ?? '';
  alamatController.text = instructor.alamat ?? '';
  tempatLahirController.text = instructor.tempatLahir ?? '';
  noHpController.text = instructor.hp ?? '';
  tanggalLahirController.text = instructor.tanggalLahir ?? '';
  int? selectedCorporationId = perusahaan?.id;
  int? selectedUserId = user?.id;
  userNameController.text = user?.name ?? '';
  namaPerusahaanController.text = perusahaan?.nama ?? '';
  DateTime? selectedDate = DateTime.parse(instructor.tanggalLahir!);
  Uint8List? fileBytes;
  String? fileName;
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
        debugPrint('File terlalu besar, pilih file yang lebih kecil dari 2MB');
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

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 50), // Margin around dialog
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding inside the dialog
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        enabled: false,
                        readOnly: true,
                        style: GoogleFonts.poppins(color: Colors.white),
                        controller: userNameController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "USERNAME",
                            floatingLabelStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            border: const OutlineInputBorder(),
                            fillColor: const Color.fromARGB(255, 161, 169, 177),
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: false,
                        readOnly: true,
                        style: GoogleFonts.poppins(color: Colors.white),
                        controller: namaPerusahaanController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "PERUSAHAAN",
                            floatingLabelStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            border: const OutlineInputBorder(),
                            fillColor: const Color.fromARGB(255, 161, 169, 177),
                            filled: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'perusahaan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Title
                      TextFormField(
                        controller: nipController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "NIP",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'nip tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Title
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "NAMA LENGKAP",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        controller: tanggalLahirController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: "Tanggal Lahir",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          await pickDate(context);
                          setState(() {
                            tanggalLahirController.text = selectedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0];
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: tempatLahirController,
                        decoration: const InputDecoration(
                          labelText: "TEMPAT LAHIR",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'tempat lahir tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: alamatController,
                        decoration: const InputDecoration(
                          labelText: "ALAMAT LENGKAP",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: noHpController,
                        decoration: const InputDecoration(
                          labelText: "NO HP",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'no hp tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      if (fileBytes != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Image.memory(fileBytes!))
                      else if (fileName != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Image.network(
                              'https://sigapkl-smkn2padang.com/storage/public/instructors-images/$fileName',
                              height: 40,
                              width: 40,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.image,
                                size: 40,
                              ),
                            )),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await pickFile();
                              setState(() {});
                            },
                            child: const Text("Pilih Gambar"),
                          ),
                          const SizedBox(width: 10),
                          if (fileName != null)
                            Expanded(
                              child: Text(fileName!,
                                  style: GoogleFonts.poppins(fontSize: 12)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Batal", style: GoogleFonts.poppins()),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  selectedDate != null &&
                                  fileBytes != null) {
                                onSubmit({
                                  "user_id": selectedUserId,
                                  "corporation_id": selectedCorporationId,
                                  "nip": nipController.text,
                                  "nama": nameController.text,
                                  "jenis_kelamin": selectedJenisKelamin,
                                  "tanggal_lahir":
                                      selectedDate?.toIso8601String(),
                                  "tempat_lahir": tempatLahirController.text,
                                  "alamat": alamatController.text,
                                  "hp": noHpController.text,
                                }, fileBytes!, fileName);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Simpan", style: GoogleFonts.poppins()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
