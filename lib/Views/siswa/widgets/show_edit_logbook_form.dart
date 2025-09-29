import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/siswa/intern_provider.dart';
import 'dart:typed_data';

Future<void> showEditLogbookForm({
  required int id,
  required BuildContext context,
  required Function(
          Map<String, dynamic> data, Uint8List? fileBytes, String? fileName)
      onSubmit,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController officerController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String? selectedCategory;
  String? selectedStatus;
  String? selectedBentukKegiatan;
  String? selectedPenugasanPekerjaan;
  DateTime selectedDate = DateTime.now(); // Otomatis today
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  Uint8List? fileBytes;
  String? fileName;
  String? fileError;

  // Fetch existing logbook data
  final internProvider = Provider.of<InternProvider>(context, listen: false);
  final existingLogbook = internProvider.currentIntern?.logbook?.firstWhere(
    (logbook) => logbook.id == id,
    orElse: () => throw Exception('Logbook not found'),
  );

  if (existingLogbook != null) {
    titleController.text = existingLogbook.judul ?? '';
    officerController.text = existingLogbook.petugas ?? '';
    contentController.text = existingLogbook.isi ?? '';
    selectedCategory = existingLogbook.category;
    selectedStatus = existingLogbook.keterangan;
    selectedDate = DateTime.parse(
        existingLogbook.tanggal ?? DateTime.now().toIso8601String());
    if (existingLogbook.mulai != null) {
      final startParts = existingLogbook.mulai!.split(':');
      selectedStartTime = TimeOfDay(
          hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
    }
    if (existingLogbook.selesai != null) {
      final endParts = existingLogbook.selesai!.split(':');
      selectedEndTime = TimeOfDay(
          hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
    }
    // For bentuk_kegiatan or penugasan_pekerjaan, assume it's stored in the model or set based on category
    // If category is KOMPETENSI, set selectedBentukKegiatan, else selectedPenugasanPekerjaan
    if (selectedCategory == "KOMPETENSI") {
      selectedBentukKegiatan =
          existingLogbook.bentukKegiatan ?? "MANDIRI"; // Default or from model
    } else if (selectedCategory == "LAINNYA") {
      selectedPenugasanPekerjaan = existingLogbook.penugasanPekerjaan ??
          "DITUGASKAN"; // Default or from model
    }
    // Note: fileBytes and fileName are not pre-filled as editing file might be optional
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
      final bytes = result.files.single.bytes;
      if (bytes != null && bytes.length > 5 * 1024 * 1024) {
        fileError = "Ukuran gambar maksimal 5MB.";
        fileBytes = null;
        fileName = null;
      } else {
        fileBytes = bytes;
        fileName = result.files.single.name;
        fileError = null;
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
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Center(
                        child: Text(
                          'Tambah Logbook',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF696cff),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Kategori Pekerjaan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.category,
                              color: Color(0xFF696cff)),
                        ),
                        items: ["KOMPETENSI", "LAINNYA"]
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child:
                                      Text(item, style: GoogleFonts.poppins()),
                                ))
                            .toList(),
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                            selectedBentukKegiatan = null;
                            selectedPenugasanPekerjaan = null;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Nama Pekerjaan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon:
                              const Icon(Icons.work, color: Color(0xFF696cff)),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama pekerjaan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Conditional Field: Bentuk Kegiatan or Penugasan Pekerjaan
                      if (selectedCategory == "KOMPETENSI")
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: "Bentuk Kegiatan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color:
                                      const Color(0xFF696cff).withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF696cff), width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            prefixIcon: const Icon(Icons.event,
                                color: Color(0xFF696cff)),
                          ),
                          items: ["MANDIRI", "BIMBINGAN"]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item,
                                        style: GoogleFonts.poppins()),
                                  ))
                              .toList(),
                          value: selectedBentukKegiatan,
                          onChanged: (value) {
                            setState(() {
                              selectedBentukKegiatan = value;
                            });
                          },
                          validator: (value) {
                            if (selectedCategory == "KOMPETENSI" &&
                                value == null) {
                              return 'Bentuk kegiatan wajib diisi untuk kategori KOMPETENSI';
                            }
                            return null;
                          },
                        )
                      else if (selectedCategory == "LAINNYA")
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: "Penugasan Pekerjaan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color:
                                      const Color(0xFF696cff).withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF696cff), width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            prefixIcon: const Icon(Icons.assignment,
                                color: Color(0xFF696cff)),
                          ),
                          items: ["DITUGASKAN", "INISIATIF"]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item,
                                        style: GoogleFonts.poppins()),
                                  ))
                              .toList(),
                          value: selectedPenugasanPekerjaan,
                          onChanged: (value) {
                            setState(() {
                              selectedPenugasanPekerjaan = value;
                            });
                          },
                          validator: (value) {
                            if (selectedCategory == "LAINNYA" &&
                                value == null) {
                              return 'Penugasan pekerjaan wajib diisi untuk kategori LAINNYA';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16),
                      // Jam Mulai Pekerjaan
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Pilih Waktu Mulai",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.access_time,
                              color: Color(0xFF696cff)),
                        ),
                        controller: TextEditingController(
                          text: selectedStartTime != null
                              ? selectedStartTime!.format(context)
                              : null,
                        ),
                        onTap: () async {
                          await pickTime(context, true);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      // Jam Selesai Pekerjaan
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Pilih Waktu Selesai",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.access_time,
                              color: Color(0xFF696cff)),
                        ),
                        controller: TextEditingController(
                          text: selectedEndTime != null
                              ? selectedEndTime!.format(context)
                              : null,
                        ),
                        onTap: () async {
                          await pickTime(context, false);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                      // Officer
                      TextFormField(
                        controller: officerController,
                        decoration: InputDecoration(
                          labelText: "Staf Yang Menugaskan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xFF696cff)),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Staf tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Content
                      TextFormField(
                        controller: contentController,
                        decoration: InputDecoration(
                          labelText: "Uraian Proses Kerja",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.description,
                              color: Color(0xFF696cff)),
                        ),
                        style: GoogleFonts.poppins(),
                        minLines: 3,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.length < 10) {
                            return 'Uraian minimal 10 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Keterangan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color:
                                    const Color(0xFF696cff).withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF696cff), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: const Icon(Icons.check_circle,
                              color: Color(0xFF696cff)),
                        ),
                        items: ["TUNTAS", "BELUM TUNTAS"]
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child:
                                      Text(item, style: GoogleFonts.poppins()),
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
                      const SizedBox(height: 16),
                      // File Picker
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              await pickFile();
                              setState(() {});
                            },
                            icon: const Icon(Icons.image),
                            label: const Text("Pilih Gambar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF696cff),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (fileName != null)
                            Expanded(
                              child: Text(
                                fileName!,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      if (fileError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            fileError!,
                            style: GoogleFonts.poppins(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Batal",
                              style:
                                  GoogleFonts.poppins(color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  selectedStartTime != null &&
                                  selectedEndTime != null &&
                                  fileError == null) {
                                onSubmit({
                                  "judul": titleController.text,
                                  "category": selectedCategory,
                                  if (selectedCategory == "KOMPETENSI")
                                    "bentuk_kegiatan": selectedBentukKegiatan,
                                  if (selectedCategory == "LAINNYA")
                                    "penugasan_pekerjaan":
                                        selectedPenugasanPekerjaan,
                                  "tanggal": selectedDate.toIso8601String(),
                                  "mulai":
                                      "${selectedStartTime!.hour}:${selectedStartTime!.minute}:00",
                                  "selesai":
                                      "${selectedEndTime!.hour}:${selectedEndTime!.minute}:00",
                                  "petugas": officerController.text,
                                  "isi": contentController.text,
                                  "keterangan": selectedStatus,
                                }, fileBytes, fileName);
                                Navigator.of(context).pop();
                              } else {
                                // Feedback jika gagal
                                String errorMessage =
                                    "Harap lengkapi semua field yang diperlukan.";
                                if (selectedStartTime == null) {
                                  errorMessage = "Pilih waktu mulai.";
                                } else if (selectedEndTime == null) {
                                  errorMessage = "Pilih waktu selesai.";
                                } else if (fileError != null) {
                                  errorMessage = fileError!;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF696cff),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: Text(
                              "Simpan",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
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
