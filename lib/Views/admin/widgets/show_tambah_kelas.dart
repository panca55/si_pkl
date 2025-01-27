import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:si_pkl/models/admin/departments_model.dart';

Future<void> showTambahKelasPopup(
    {required List<Department>? department,
    required BuildContext context,
    required Function(
            Map<String, dynamic> data)
        onSubmit}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final listJurusan = department?.toList() ?? [];
  int? selectedJurusan;
  

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
                          labelText: "JURUSAN",
                          border: OutlineInputBorder(),
                        ),
                        items: listJurusan
                            .map((listJurusan) => DropdownMenuItem<int>(
                                  value: listJurusan.id,
                                  child: Text(listJurusan.nama ?? ''),
                                ))
                            .toList(),
                        value: selectedJurusan,
                        onChanged: (value) {
                          setState(() {
                            selectedJurusan = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Jurusan harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "NAMA KELAS",
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
                              if (formKey.currentState!.validate()) {
                                onSubmit({
                                  "department_id": selectedJurusan,
                                  "nama": nameController.text, 
                                });
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
