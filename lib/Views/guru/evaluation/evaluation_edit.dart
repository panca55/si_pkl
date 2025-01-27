// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/provider/guru/evaluation_guru_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class EvaluationEdit extends StatefulWidget {
  static const String routname = '/evaluation-edit';
  final int internshipId;
  const EvaluationEdit({super.key, required this.internshipId});

  @override
  State<EvaluationEdit> createState() => _EvaluationEditState();
}

class _EvaluationEditState extends State<EvaluationEdit> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _monitoringController = TextEditingController();
  final TextEditingController _sertifikatController = TextEditingController();
  final TextEditingController _logbookController = TextEditingController();
  final TextEditingController _presentasiController = TextEditingController();

  bool isSubmitting = false;
  

  @override
  Widget build(BuildContext context) {
    final evaluationProvider =
        Provider.of<EvaluationGuruProvider>(context, listen: false);
    Future<void> submitForm() async {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          isSubmitting = true;
        });

        try {
          // Panggil fungsi submitAssessment di sini
          await evaluationProvider.submitEvaluation(
            internshipId:
                widget.internshipId, 
            monitoring: int.parse(_monitoringController.text),
            sertifikat: int.parse(_sertifikatController.text),
            logbook: int.parse(_logbookController.text),
            presentasi: int.parse(_presentasiController.text),
          );

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
        future: evaluationProvider.getEvaluationSiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final evaluation = evaluationProvider.evaluation;
            _monitoringController.text = evaluation?.monitoring.toString() ?? '';
            _sertifikatController.text = evaluation?.sertifikat.toString() ?? '';
            _logbookController.text = evaluation?.logbook.toString() ?? '';
            _presentasiController.text = evaluation?.presentasi.toString() ?? '';
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _monitoringController,
                      decoration: const InputDecoration(labelText: 'Monitoring'),
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
                      controller: _sertifikatController,
                      decoration: const InputDecoration(labelText: 'Sertifikat'),
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
                      controller: _logbookController,
                      decoration: const InputDecoration(labelText: 'Logbook'),
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
                      controller: _presentasiController,
                      decoration: const InputDecoration(labelText: 'Presentasi'),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                      onTap: isSubmitting ? null : submitForm,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding:
                            const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                        const SizedBox(width: 15,),
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
