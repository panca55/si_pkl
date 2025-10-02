import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/admin/mayors_model.dart' as mayor;
import 'package:si_pkl/models/admin/students_model.dart';
import 'package:si_pkl/models/admin/users_model.dart' as user;

Future<void> showEditStudentPopup(
    {required user.User? user,
    required Student student,
    required List<mayor.Mayor>? listKelas,
    required mayor.Mayor kelas,
    required BuildContext context,
    required Function(
            Map<String, dynamic> data, Uint8List? fileBytes, String? fileName)
        onSubmit}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController konsentrasiController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController alamatSiswaController = TextEditingController();
  final TextEditingController alamatOrtuController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController noHpSiswaController = TextEditingController();
  final TextEditingController noHpOrtuController = TextEditingController();

  String? selectedJenisKelamin = student.jenisKelamin;
  konsentrasiController.text = student.konsentrasi ?? '';
  nisnController.text = student.nisn ?? '';
  alamatSiswaController.text = student.alamatSiswa ?? '';
  alamatOrtuController.text = student.alamatOrtu ?? '';
  tempatLahirController.text = student.tempatLahir ?? '';
  noHpSiswaController.text = student.hpSiswa ?? '';
  noHpOrtuController.text = student.hpOrtu ?? '';

  final username = user?.name ?? '';
  userNameController.text = username;
  nameController.text = username;
  final kelasList = listKelas?.toList();
  final int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
  const int startYear = 2000;
  List<String> tahunAjaranList = [];
  for (int i = startYear; i <= currentYear; i++) {
    tahunAjaranList.add('$i/${i + 1}');
  }
  int? selectedKelas = kelas.id;

  String? tahunAjaran = student.tahunMasuk;
  DateTime? selectedDate = DateTime.parse(student.tanggalLahir!);
  tanggalLahirController.text = student.tanggalLahir ?? '';
  Uint8List? fileBytes;
  String? fileName = student.foto;
  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
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
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<int>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "KELAS",
                          border: OutlineInputBorder(),
                        ),
                        items: kelasList!
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
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nisnController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "NISN",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NISN tidak boleh kosong';
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
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: konsentrasiController,
                        decoration: const InputDecoration(
                          labelText: "KONSENTRASI",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'konsentrasi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
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
                            return 'Golongan harus dipilih';
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
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: alamatSiswaController,
                        decoration: const InputDecoration(
                          labelText: "ALAMAT LENGKAP",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: alamatOrtuController,
                        decoration: const InputDecoration(
                          labelText: "ALAMAT ORTU",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'alamat ortu tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: noHpSiswaController,
                        decoration: const InputDecoration(
                          labelText: "NO HP SISWA",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: noHpOrtuController,
                        decoration: const InputDecoration(
                          labelText: "NO HP ORTU",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
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
                              '${BaseApi.studentImageUrl}/$fileName',
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
                              debugPrint(selectedDate.toString());
                              if (formKey.currentState!.validate() &&
                                  selectedDate != null &&
                                  fileName != null) {
                                onSubmit({
                                  "mayor_id": selectedKelas,
                                  "nisn": nisnController.text,
                                  "nama": nameController.text,
                                  "konsentrasi": konsentrasiController.text,
                                  "tahun_masuk": tahunAjaran,
                                  "jenis_kelamin": selectedJenisKelamin,
                                  "status_pkl": student.statusPkl,
                                  "tanggal_lahir":
                                      selectedDate?.toIso8601String(),
                                  "tempat_lahir": tempatLahirController.text,
                                  "alamat_siswa": alamatSiswaController.text,
                                  "alamat_ortu": alamatOrtuController.text,
                                  "hp_siswa": noHpSiswaController.text,
                                  "hp_ortu": noHpOrtuController.text,
                                }, fileBytes, fileName);
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
