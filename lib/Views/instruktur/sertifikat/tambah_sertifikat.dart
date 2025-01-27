import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/instruktur/sertifikat/sertifikat_provider.dart';

class TambahSertifikat extends StatefulWidget {
  final int id;
  const TambahSertifikat({super.key, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _TambahSertifikatState createState() => _TambahSertifikatState();
}

class _TambahSertifikatState extends State<TambahSertifikat> {
  final TextEditingController _namaPimpinanController = TextEditingController();
  final Map<String, List<TextEditingController>> umumControllers = {
    'KEDISIPLINAN': [TextEditingController()],
    'KERAJINAN': [TextEditingController()],
    'TANGGUNG JAWAB': [TextEditingController()],
    'KERJASAMA': [TextEditingController()],
    'KETELITIAN': [TextEditingController()],
  };

  List<Map<String, dynamic>> kompetensiUtama = [];
  List<Map<String, dynamic>> kompetensiPenunjang = [];

  void addKompetensiUtama() {
    setState(() {
      kompetensiUtama.add({
        'categoryController': TextEditingController(),
        'scoreController': TextEditingController(),
      });
    });
  }

  void addKompetensiPenunjang() {
    setState(() {
      kompetensiPenunjang.add({
        'categoryController': TextEditingController(),
        'scoreController': TextEditingController(),
      });
    });
  }

  String getPredikat(int score) {
    if (score > 85) return 'Baik Sekali';
    if (score > 70) return 'Baik';
    if (score > 50) return 'Cukup';
    return 'Kurang';
  }

  Future<void> handleSubmit() async {
    // Menyimpan data umum
    Map<String, dynamic> formData = {
      "internship_id": widget.id,
      "nama_pimpinan": _namaPimpinanController.text,
      "scores": {
        "UMUM": umumControllers.values
            .map((controllers) => int.tryParse(controllers[0].text) ?? 0)
            .toList(),
        "KOMPETENSI_UTAMA": kompetensiUtama
            .map((item) => int.tryParse(item['scoreController'].text) ?? 0)
            .toList(),
        "KOMPETENSI_PENUNJANG": kompetensiPenunjang
            .map((item) => int.tryParse(item['scoreController'].text) ?? 0)
            .toList(),
      },
      "categories": {
        "UMUM": umumControllers.keys.toList(),
        "KOMPETENSI_UTAMA": kompetensiUtama
            .map((item) => item['categoryController'].text)
            .toList(),
        "KOMPETENSI_PENUNJANG": kompetensiPenunjang
            .map((item) => item['categoryController'].text)
            .toList(),
      },
      "predikats": {
        "UMUM": umumControllers.values.map((controllers) {
          int score = int.tryParse(controllers[0].text) ?? 0;
          return getPredikat(score);
        }).toList(),
        "KOMPETENSI_UTAMA": kompetensiUtama.map((item) {
          int score = int.tryParse(item['scoreController'].text) ?? 0;
          return getPredikat(score);
        }).toList(),
        "KOMPETENSI_PENUNJANG": kompetensiPenunjang.map((item) {
          int score = int.tryParse(item['scoreController'].text) ?? 0;
          return getPredikat(score);
        }).toList(),
      }
    };
    await Provider.of<SertifikatProvider>(context, listen: false)
        .submitSertifikat(formData: formData).then((value){
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        });

    // Debug print untuk melihat data yang diisi
    debugPrint('Hasil Form: ${formData.toString()}');
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    for (var controllers in umumControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    for (var item in kompetensiUtama) {
      item['categoryController'].dispose();
      item['scoreController'].dispose();
    }
    for (var item in kompetensiPenunjang) {
      item['categoryController'].dispose();
      item['scoreController'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Input Sertifikat Siswa', style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Pimpinan'.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: _namaPimpinanController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Score',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const Text(
              'UMUM',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ...umumControllers.entries.map((entry) {
              String category = entry.key;
              TextEditingController scoreController = entry.value[0];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category),
                    TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Score',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    if (scoreController.text.isNotEmpty)
                      Text(
                        'Predikat: ${getPredikat(int.tryParse(scoreController.text) ?? 0)}',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'KOMPETENSI UTAMA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ...kompetensiUtama.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: item['categoryController'],
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: item['scoreController'],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Score',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    if (item['scoreController'].text.isNotEmpty)
                      Text(
                        'Predikat: ${getPredikat(int.tryParse(item['scoreController'].text) ?? 0)}',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              );
            }),
            GestureDetector(
              onTap: addKompetensiUtama,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(2, 2),
                          color: Colors.black.withOpacity(0.25))
                    ]),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Tambah Kompetensi Utama',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'KOMPETENSI PENUNJANG',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ...kompetensiPenunjang.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: item['categoryController'],
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: item['scoreController'],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Score',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    if (item['scoreController'].text.isNotEmpty)
                      Text(
                        'Predikat: ${getPredikat(int.tryParse(item['scoreController'].text) ?? 0)}',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              );
            }),
            GestureDetector(
              onTap: addKompetensiPenunjang,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(2, 2),
                          color: Colors.black.withOpacity(0.25))
                    ]),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Tambah Kompetensi Penunjang',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.green.shade900),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(2, 2),
                              color: Colors.black.withOpacity(0.25))
                        ]),
                    child: Center(
                      child: Text(
                        'Kembaili',
                        style: GoogleFonts.poppins(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: handleSubmit,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.green.shade900,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(2, 2),
                              color: Colors.black.withOpacity(0.25))
                        ]),
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
