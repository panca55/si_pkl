// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_detail_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class AssessmentEdit extends StatefulWidget {
  static const String routname = '/assessment-input';
  final int internshipId;
  const AssessmentEdit({super.key, required this.internshipId});

  @override
  State<AssessmentEdit> createState() => _AssessmentEditState();
}

class _AssessmentEditState extends State<AssessmentEdit> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _softskillController = TextEditingController();
  final TextEditingController _normaController = TextEditingController();
  final TextEditingController _teknisController = TextEditingController();
  final TextEditingController _pemahamanController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _deskripsiSoftskillController =
      TextEditingController();
  final TextEditingController _deskripsiNormaController =
      TextEditingController();
  final TextEditingController _deskripsiTeknisController =
      TextEditingController();
  final TextEditingController _deskripsiPemahamanController =
      TextEditingController();
  final TextEditingController _deskripsiCatatanController =
      TextEditingController();

  bool isSubmitting = false;
  

  @override
  Widget build(BuildContext context) {
    final assessmentProvider =
        Provider.of<AssessmentDetailProvider>(context, listen: false);
    Future<void> submitForm() async {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          isSubmitting = true;
        });

        try {
          // Panggil fungsi submitAssessment di sini
          // await assessmentProvider.submitAssessment(
          //   internshipId:
          //       widget.internshipId, // Ganti sesuai dengan ID internship yang diinginkan
          //   nama: _namaController.text,
          //   softskill: int.parse(_softskillController.text),
          //   norma: int.parse(_normaController.text),
          //   teknis: int.parse(_teknisController.text),
          //   pemahaman: int.parse(_pemahamanController.text),
          //   catatan: _catatanController.text,
          //   score: int.parse(_scoreController.text),
          //   deskripsiSoftskill: _deskripsiSoftskillController.text,
          //   deskripsiNorma: _deskripsiNormaController.text,
          //   deskripsiTeknis: _deskripsiTeknisController.text,
          //   deskripsiPemahaman: _deskripsiPemahamanController.text,
          //   deskripsiCatatan: _deskripsiCatatanController.text,
          // );

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penilaian berhasil disimpan')),
          );

          // Reset form setelah sukses
          _formKey.currentState?.reset();
        } catch (e) {
          // Tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan: $e')),
          );
        } finally {
          setState(() {
            isSubmitting = false;
          });
        }
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: assessmentProvider.getShowAssessments(widget.internshipId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final assessment = assessmentProvider.assessmentsModel?.assessment;
            _namaController.text = assessment?.nama ?? '';
            _softskillController.text = assessment?.softSkill.toString() ?? '';
            _normaController.text = assessment?.norma.toString() ?? '';
            _teknisController.text = assessment?.teknis.toString() ?? '';
            _pemahamanController.text = assessment?.pemahaman.toString() ?? '';
            _catatanController.text = assessment?.catatan ?? '';
            _scoreController.text = assessment?.score.toString() ?? '';
            _deskripsiSoftskillController.text = assessment?.deskripsiSoftSkill ?? '';
            _deskripsiNormaController.text = assessment?.deskripsiNorma ?? '';
            _deskripsiTeknisController.text = assessment?.deskripsiTeknis ?? '';
            _deskripsiPemahamanController.text = assessment?.deskripsiPemahaman ?? '';
            _deskripsiCatatanController.text = assessment?.deskripsiCatatan ?? '';
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nama tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _softskillController,
                      decoration: const InputDecoration(labelText: 'Softskill'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, 
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nilai tidak boleh kosong';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return 'Masukkan nilai angka';
                        }
                        if (intValue > 100) {
                          return 'Nilai tidak boleh lebih dari 100';
                        }
                        return null; // Tidak ada error
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _normaController,
                      decoration: const InputDecoration(labelText: 'Norma'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nilai tidak boleh kosong';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return 'Masukkan nilai angka';
                        }
                        if (intValue > 100) {
                          return 'Nilai tidak boleh lebih dari 100';
                        }
                        return null; // Tidak ada error
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _teknisController,
                      decoration: const InputDecoration(labelText: 'Teknis'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nilai tidak boleh kosong';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return 'Masukkan nilai angka';
                        }
                        if (intValue > 100) {
                          return 'Nilai tidak boleh lebih dari 100';
                        }
                        return null; // Tidak ada error
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _pemahamanController,
                      decoration: const InputDecoration(labelText: 'Pemahaman'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nilai tidak boleh kosong';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return 'Masukkan nilai angka';
                        }
                        if (intValue > 100) {
                          return 'Nilai tidak boleh lebih dari 100';
                        }
                        return null; // Tidak ada error
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _scoreController,
                      decoration: const InputDecoration(labelText: 'Score'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nilai tidak boleh kosong';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return 'Masukkan nilai angka';
                        }
                        if (intValue > 100) {
                          return 'Nilai tidak boleh lebih dari 100';
                        }
                        return null; // Tidak ada error
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _catatanController,
                      decoration: const InputDecoration(labelText: 'Catatan'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _deskripsiSoftskillController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi Softskill'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _deskripsiNormaController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi Norma'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _deskripsiTeknisController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi Teknis'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _deskripsiPemahamanController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi Pemahaman'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _deskripsiCatatanController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi Catatan'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: isSubmitting ? null : submitForm,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(2, 2))
                                  ]),
                              child: isSubmitting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      'Submit',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(2, 2))
                                  ]),
                              child: Text(
                                'Kembali',
                                style: GoogleFonts.poppins(
                                    color: GlobalColorTheme.primaryBlueColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
