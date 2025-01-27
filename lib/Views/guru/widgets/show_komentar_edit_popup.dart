import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/guru/detail_logbook_provider.dart';

Future<void> showKomentarEditPopup({
  required BuildContext context,
  required Function(
          Map<String, dynamic> data)
      onSubmit,
  required Future<void> komentarProvider,
  required int id
}) async {
  debugPrint('komentar provider: $komentarProvider');
  debugPrint('ID: $id');

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController catatanController = TextEditingController();
  final notes = Provider.of<DetailLogbookProvider>(context, listen: false)
      .detailLogbookModel
      ?.logbook
      ?.note;

  if (notes == null || notes.isEmpty) {
    debugPrint('Tidak ada komentar yang tersedia');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Error'),
          content: Text('Tidak ada komentar yang tersedia.'),
        );
      },
    );
    return;
  }
  
  final note = notes.first;
  final catatan = note.catatan;
  final penilaian = note.penilaian;
  catatanController.text = catatan ?? '';
  String? selectedPenilaian = penilaian;
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
                        controller: catatanController,
                        decoration: const InputDecoration(
                          labelText: "KOMENTAR",
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
                        items: ["SUDAH BAGUS", "PERBAIKI"]
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        value: selectedPenilaian,
                        onChanged: (value) {
                          setState(() {
                            selectedPenilaian = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Penilaian harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Date Picker
                      
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
                                  "id": id,
                                  "catatan": catatanController.text,
                                  "penilaian": selectedPenilaian, 
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
