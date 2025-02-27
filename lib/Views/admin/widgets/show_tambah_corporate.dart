import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:si_pkl/models/admin/users_model.dart';

Future<void> showTambahPerusahaanPopup(
    {required List<User>? user,
    required BuildContext context,
    required Function(
            Map<String, dynamic> data, Uint8List fileBytes, String? fileName)
        onSubmit}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quotaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  String? mulaiHariKerja;
  String? akhirHariKerja;
  final corporate = user?.where((u) => u.role == "PERUSAHAAN").toList() ?? [];
  int? selectedUserId;
  Uint8List? fileBytes;
  String? fileName;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

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
  Future<void> pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      if (isStartTime) {
        selectedStartTime = pickedTime;
      } else {
        selectedEndTime = pickedTime;
      }
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
                      DropdownButtonFormField<int>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "PERUSAHAAN",
                          border: OutlineInputBorder(),
                        ),
                        items: corporate
                            .map((user) => DropdownMenuItem<int>(
                                  value: user.id,
                                  child: Text(user.name ?? ''),
                                ))
                            .toList(),
                        value: selectedUserId,
                        onChanged: (value) {
                          setState(() {
                            selectedUserId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Username harus dipilih';
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
                      // Title
                      TextFormField(
                        controller: quotaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "QUOTA",
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
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Mulai Hari Kerja",
                          border: OutlineInputBorder(),
                        ),
                        items: ['Senin', 'Selasa','Rabu', 'Kamis', 'Jumat','Sabtu','Minggu']
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        value: mulaiHariKerja,
                        onChanged: (value) {
                          setState(() {
                            mulaiHariKerja = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Mulai Hari Kerja harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Akhir Hari Kerja",
                          border: OutlineInputBorder(),
                        ),
                        items: ['Senin', 'Selasa','Rabu', 'Kamis', 'Jumat','Sabtu','Minggu']
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        value: akhirHariKerja,
                        onChanged: (value) {
                          setState(() {
                            akhirHariKerja = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Mulai Hari Kerja harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.access_time_outlined,
                                  color: Colors.black,
                                ),
                                labelText: selectedStartTime != null
                                    ? selectedStartTime!.format(context)
                                    : "Pilih Waktu Mulai",
                                border: const OutlineInputBorder(),
                              ),
                              onTap: () async {
                                await pickTime(context, true);
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.access_time_outlined,
                                  color: Colors.black,
                                ),
                                labelText: selectedEndTime != null
                                    ? selectedEndTime!.format(context)
                                    : "Pilih Waktu Selesai",
                                border: const OutlineInputBorder(),
                              ),
                              onTap: () async {
                                await pickTime(context, false);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
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
                            return 'Username tidak boleh kosong';
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
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                            Text(fileName!,
                                style: GoogleFonts.poppins(fontSize: 12)),
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
                              debugPrint("jam_mulai: ${selectedStartTime!.hour.toString()}:${selectedStartTime!.minute.toString()}:00");
                              debugPrint("jam_berakhir: ${selectedEndTime!.hour.toString()}:${selectedEndTime!.minute.toString()}:00");
                              if (formKey.currentState!.validate() &&
                                  selectedEndTime != null && selectedStartTime != null && selectedEndTime != null &&
                                  fileBytes != null) {
                                onSubmit({
                                  "user_id": selectedUserId,
                                  "quota": quotaController.text,
                                  "nama": nameController.text,
                                  "slug": nameController.text,
                                  "jam_mulai": "${selectedStartTime!.hour.toString()}:${selectedStartTime!.minute.toString()}:00",
                                  "jam_berakhir": "${selectedEndTime!.hour.toString()}:${selectedEndTime!.minute.toString()}:00",
                                  "mulai_hari_kerja": mulaiHariKerja,
                                  "akhir_hari_kerja": akhirHariKerja,
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
