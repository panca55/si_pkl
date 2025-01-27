import 'package:flutter/material.dart';
import 'package:si_pkl/models/perusahaan/dashboard_model.dart';

Future<void> showAddInstrukturPopup({
  List<Instructors>? instruktur,
  required BuildContext context,
  required Function(int) onSubmit,
}) async {


  int?
      selectedInstrukturId; // Variabel untuk menyimpan ID instruktur yang dipilih
  final instrukturs = instruktur!.toList();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Form Absensi"),
            content: DropdownButton<int>(
              isExpanded: true,
              hint: const Text("Pilih Instruktur"),
              items: instrukturs
                  .map((instruktur) => DropdownMenuItem<int>(
                        value: instruktur.id,
                        child: Text(instruktur.nama ?? '-'), // Nama 
                      ))
                  .toList(),
              value: selectedInstrukturId,
              onChanged: (value) {
                setState(() {
                  selectedInstrukturId = value;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedInstrukturId != null) {
                    onSubmit(
                        selectedInstrukturId!); // Mengirim ID instruktur yang dipilih
                    Navigator.pop(context);
                  } else {
                    // Anda dapat menampilkan pesan error jika diperlukan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Harap pilih instruktur!")),
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      );
    },
  );
}
