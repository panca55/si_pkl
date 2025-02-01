import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:si_pkl/models/admin/informations_model.dart';

Future<void> showEditInfoPopup(
    {required BuildContext context,
    required Information info,
    required Function(Map<String, dynamic> data) onSubmit}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController isiController = TextEditingController();
  final TextEditingController tanggalMulaiController = TextEditingController();
  final TextEditingController tanggalBerakhirController =
      TextEditingController();
  nameController.text = info.nama ?? '';
  String removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }
  isiController.text = removeHtmlTags(info.isi ?? '');
  DateTime? tanggalMulai = DateTime.parse(info.tanggalMulai!);
  DateTime? tanggalBerakhir = DateTime.parse(info.tanggalBerakhir!);
  tanggalMulaiController.text = tanggalMulai.toString();
  tanggalBerakhirController.text = tanggalBerakhir.toString();
  Future<void> pickDate(BuildContext context, {bool isMulai = true}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      if (isMulai) {
        tanggalMulai = pickedDate;
      } else {
        tanggalBerakhir = pickedDate;
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
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "NAMA",
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
                        controller: isiController,
                        decoration: const InputDecoration(
                          labelText: "ISI",
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
                        readOnly: true,
                        controller: tanggalMulaiController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: "Tanggal Mulai",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          await pickDate(context);
                          setState(() {
                            tanggalMulaiController.text = tanggalMulai!.toLocal().toString().split(' ')[0];
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        controller: tanggalBerakhirController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: "Tanggal Berakhir",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          await pickDate(context, isMulai: false);
                          setState(() {
                            tanggalBerakhirController.text = tanggalBerakhir!
                                .toLocal()
                                .toString()
                                .split(' ')[0];
                          });
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
                                  "nama": nameController.text,
                                  "isi": isiController.text,
                                  "tanggal_mulai":
                                      tanggalMulai?.toIso8601String(),
                                  "tanggal_berakhir":
                                      tanggalBerakhir?.toIso8601String(),
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
