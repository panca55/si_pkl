import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_pkl/models/perusahaan/bursa_kerja_model.dart';

Future<void> showAddBursaKerjaPopup({
  required BuildContext context,
  required Function(Map<String, dynamic>, Uint8List?, String?) onSubmit,
  required List<String> jenisPekerjaanOptions,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController slugController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController persyaratanController = TextEditingController();
  final TextEditingController jenisPekerjaanController =
      TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController rentangGajiController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  DateTime? batasPengiriman;
  Uint8List? fileBytes;
  String? fileName;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Tambah Lowongan Pekerjaan'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: InputDecoration(labelText: 'Judul'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: slugController,
                  decoration: InputDecoration(labelText: 'Slug'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Slug tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: persyaratanController,
                  decoration: InputDecoration(labelText: 'Persyaratan'),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Persyaratan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: jenisPekerjaanController.text.isEmpty
                      ? null
                      : jenisPekerjaanController.text,
                  decoration: InputDecoration(labelText: 'Jenis Pekerjaan'),
                  items: jenisPekerjaanOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    jenisPekerjaanController.text = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis pekerjaan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: lokasiController,
                  decoration: InputDecoration(labelText: 'Lokasi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: rentangGajiController,
                  decoration:
                      InputDecoration(labelText: 'Rentang Gaji (angka)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Rentang gaji tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Rentang gaji harus berupa angka';
                    }
                    return null;
                  },
                ),
                StatefulBuilder(
                  builder: (context, setState) => GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          batasPengiriman = pickedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Batas Pengiriman',
                          hintText: batasPengiriman != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(batasPengiriman!)
                              : 'Pilih tanggal',
                        ),
                        validator: (value) {
                          if (batasPengiriman == null) {
                            return 'Batas pengiriman tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: contactEmailController,
                  decoration: InputDecoration(labelText: 'Contact Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) => Row(
                    children: [
                      Expanded(
                        child: Text(
                          fileName ?? 'Pilih Foto',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null) {
                            setState(() {
                              fileBytes = result.files.single.bytes;
                              fileName = result.files.single.name;
                            });
                          }
                        },
                        child: Text('Pilih File'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final data = {
                  "judul": judulController.text,
                  "slug": slugController.text,
                  "deskripsi": deskripsiController.text,
                  "persyaratan": persyaratanController.text,
                  "jenis_pekerjaan": jenisPekerjaanController.text,
                  "lokasi": lokasiController.text,
                  "rentang_gaji": rentangGajiController.text,
                  "batas_pengiriman":
                      DateFormat('yyyy-MM-dd').format(batasPengiriman!),
                  "contact_email": contactEmailController.text,
                  "status": 1
                };
                onSubmit(data, fileBytes, fileName);
                Navigator.of(context).pop();
              }
            },
            child: Text('Simpan'),
          ),
        ],
      );
    },
  );
}

Future<void> showEditBursaKerjaPopup({
  required BuildContext context,
  required Job job,
  required Function(Map<String, dynamic>, Uint8List?, String?) onSubmit,
  required List<String> jenisPekerjaanOptions,
}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController judulController =
      TextEditingController(text: job.judul);
  final TextEditingController slugController =
      TextEditingController(text: job.slug);
  final TextEditingController deskripsiController =
      TextEditingController(text: job.deskripsi);
  final TextEditingController persyaratanController =
      TextEditingController(text: job.persyaratan);
  final TextEditingController jenisPekerjaanController =
      TextEditingController(text: job.jenisPekerjaan);
  final TextEditingController lokasiController =
      TextEditingController(text: job.lokasi);
  final TextEditingController rentangGajiController =
      TextEditingController(text: job.rentangGaji);
  final TextEditingController contactEmailController =
      TextEditingController(text: job.contactEmail);
  DateTime? batasPengiriman = job.batasPengiriman != null
      ? DateTime.tryParse(job.batasPengiriman!)
      : null;
  Uint8List? fileBytes;
  String? fileName = job.foto;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Lowongan Pekerjaan'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: judulController,
                  decoration: InputDecoration(labelText: 'Judul'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: slugController,
                  decoration: InputDecoration(labelText: 'Slug'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Slug tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: persyaratanController,
                  decoration: InputDecoration(labelText: 'Persyaratan'),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Persyaratan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: jenisPekerjaanController.text.isEmpty
                      ? null
                      : jenisPekerjaanController.text,
                  decoration: InputDecoration(labelText: 'Jenis Pekerjaan'),
                  items: jenisPekerjaanOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    jenisPekerjaanController.text = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis pekerjaan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: lokasiController,
                  decoration: InputDecoration(labelText: 'Lokasi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: rentangGajiController,
                  decoration:
                      InputDecoration(labelText: 'Rentang Gaji (angka)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Rentang gaji tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Rentang gaji harus berupa angka';
                    }
                    return null;
                  },
                ),
                StatefulBuilder(
                  builder: (context, setState) => GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: batasPengiriman ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          batasPengiriman = pickedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Batas Pengiriman',
                          hintText: batasPengiriman != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(batasPengiriman!)
                              : 'Pilih tanggal',
                        ),
                        validator: (value) {
                          if (batasPengiriman == null) {
                            return 'Batas pengiriman tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: contactEmailController,
                  decoration: InputDecoration(labelText: 'Contact Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) => Row(
                    children: [
                      Expanded(
                        child: Text(
                          fileName ?? 'Pilih Foto',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (result != null) {
                            setState(() {
                              fileBytes = result.files.single.bytes;
                              fileName = result.files.single.name;
                            });
                          }
                        },
                        child: Text('Pilih File'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final data = {
                  "id": job.id,
                  "judul": judulController.text,
                  "slug": slugController.text,
                  "deskripsi": deskripsiController.text,
                  "persyaratan": persyaratanController.text,
                  "jenis_pekerjaan": jenisPekerjaanController.text,
                  "lokasi": lokasiController.text,
                  "rentang_gaji": rentangGajiController.text,
                  "batas_pengiriman":
                      DateFormat('yyyy-MM-dd').format(batasPengiriman!),
                  "contact_email": contactEmailController.text,
                  "status": job.status
                };
                onSubmit(data, fileBytes, fileName);
                Navigator.of(context).pop();
              }
            },
            child: Text('Simpan'),
          ),
        ],
      );
    },
  );
}
