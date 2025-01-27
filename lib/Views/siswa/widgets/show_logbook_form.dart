import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

Future<void> showLogbookForm({
  required BuildContext context,
  required Function(
          Map<String, dynamic> data, Uint8List fileBytes, String? fileName)
      onSubmit,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController officerController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String? selectedCategory;
  String? selectedStatus;
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
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

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      fileBytes = result.files.single.bytes;
      fileName = result.files.single.name;
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Dialog(
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
                      // Title
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Judul",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Category",
                          border: OutlineInputBorder(),
                        ),
                        items: ["KOMPETENSI", "LAINNYA"]
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Category harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Date Picker
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: selectedDate != null
                                    ? selectedDate!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                    : "Pilih Tanggal",
                                border: const OutlineInputBorder(),
                              ),
                              onTap: () async {
                                await pickDate(context);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Time Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
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
                      // Officer
                      TextFormField(
                        controller: officerController,
                        decoration: const InputDecoration(
                          labelText: "Petugas",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Petugas tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Content
                      TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          labelText: "Isi",
                          border: OutlineInputBorder(),
                        ),
                        minLines: 3,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.length < 10) {
                            return 'Isi minimal 10 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Keterangan",
                          border: OutlineInputBorder(),
                        ),
                        items: ["TUNTAS", "BELUM TUNTAS"]
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        value: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Keterangan harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // File Picker
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
                      const SizedBox(height: 20),
                      // Action buttons (Simpan and Batal)
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
                                  selectedStartTime != null &&
                                  selectedEndTime != null &&
                                  fileBytes != null) {
                                onSubmit({
                                  "judul": titleController.text,
                                  "category": selectedCategory,
                                  "tanggal": selectedDate!.toIso8601String(),
                                  "mulai":
                                      "${selectedStartTime!.hour}:${selectedStartTime!.minute}:00",
                                  "selesai":
                                      "${selectedEndTime!.hour}:${selectedEndTime!.minute}:00",
                                  "petugas": officerController.text,
                                  "isi": contentController.text,
                                  "keterangan": selectedStatus,
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
