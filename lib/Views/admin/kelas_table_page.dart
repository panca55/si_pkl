import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Views/admin/widgets/edit/show_edit_kelas.dart';
import 'package:si_pkl/Views/admin/widgets/show_tambah_kelas.dart';
import 'package:si_pkl/provider/admin/departments_provider.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';

class KelasTablePage extends StatefulWidget {
  const KelasTablePage({super.key});

  @override
  State<KelasTablePage> createState() => _KelasTablePageState();
}

class _KelasTablePageState extends State<KelasTablePage> {
  @override
  Widget build(BuildContext context) {
    final mayorsProvider =
        Provider.of<MayorsProvider>(context, listen: false);
    final departmentsProvider = Provider.of<DepartmentsProvider>(context, listen:false);
    void showDeleteDialog(BuildContext context, int id) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  await mayorsProvider.deleteUser(id: id);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  mayorsProvider.getMayors();
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              )
            ],
          );
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([
          mayorsProvider.getMayors(),
          departmentsProvider.getDepartments(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final department = departmentsProvider.departmentsModel?.department?.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Kelas',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async{
                        showTambahKelasPopup(department: department, context: context, onSubmit: (data)async{
                          await mayorsProvider.addMayor(data: data).then((value){
                            mayorsProvider.getMayors();
                            setState(() {});
                          });
                        });
                        await mayorsProvider.getMayors();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.indigo.shade700,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<MayorsProvider?>(
                  builder: (context, provider, child) {
                    final kelas =
                        provider?.mayorsModel?.mayor ?? [];
                    if (kelas.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada data kelas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(1, 1),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(-1, -1),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                clipBehavior: Clip.hardEdge,
                                dataRowMinHeight: 45,
                                horizontalMargin: 30,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      "No".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Nama Jurusan".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Nama Kelas".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "aksi".toUpperCase(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  kelas.length,
                                  (index) {
                                    final kelasData = kelas[index];
                                    final nomor = index + 1;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(nomor.toString())),
                                        DataCell(Text(kelasData.nama ?? '-')),
                                        DataCell(Text(kelasData.department?.nama ?? '-')),
                                        DataCell(
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final mayor = kelas.firstWhere((k)=> k.id == kelasData.id);
                                                  final id = kelasData.id;
                                                  showEditKelasPopup(department: department, mayor: mayor, context: context, onSubmit: (data)async{
                                                    mayorsProvider.editKelas(id:id! , data: data).then((value){
                                                    mayorsProvider.getMayors();
                                                    setState(() {});
                                                    });
                                                  });
                                                  await mayorsProvider.getMayors();
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 5),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo.shade700,
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit_document,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  showDeleteDialog(context, kelasData.id!);
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 5),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: GlobalColorTheme
                                                        .errorColor,
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
