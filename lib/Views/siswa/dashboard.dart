import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/provider/siswa/profile_provider.dart';
import 'package:si_pkl/themes/global_color_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: profileProvider.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Aktifkan skeleton saat menunggu
              loading = true;
            } else {
              // Nonaktifkan skeleton saat data selesai dimuat
              loading = false;

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat data: ${snapshot.error}', // Tampilkan pesan error jika ada
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            }
            final namaSiswa = profileProvider.currentSiswa?.nama;
            final foto =
                profileProvider.currentSiswa?.internship?.corporation?.foto;
            final logo =
                profileProvider.currentSiswa?.internship?.corporation?.logo;
            final fotoCorporate = (foto != null && foto.isNotEmpty)
                ? '${BaseApi.corporateImageUrl}/$foto'
                : '';
            final logoCorporate = (logo != null && logo.isNotEmpty)
                ? '${BaseApi.corporateLogoUrl}/${logo.contains('.') ? logo : '$logo.png'}'
                : '';
            debugPrint('Foto Corporate: $fotoCorporate');
            debugPrint('Logo Corporate: $logoCorporate');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                      enabled: loading,
                      enableSwitchAnimation: true,
                      child: _buildWelcomeCard(name: namaSiswa ?? 'null')),
                  const SizedBox(height: 20),
                  Skeletonizer(
                    enabled: loading,
                    enableSwitchAnimation: true,
                    child: _buildInfoCard(
                        image:
                            '${BaseApi.teacherImageUrl}/${profileProvider.currentSiswa?.internship?.teacher?.foto}',
                        colorHeader: GlobalColorTheme.primaryBlueColor,
                        title: 'Guru Pembimbing',
                        property1: 'NIP',
                        property2: 'Nama',
                        property3: 'Bidang Studi',
                        property4: 'Jabatan',
                        value1: profileProvider
                                .currentSiswa?.internship?.teacher?.nip ??
                            "-",
                        value2: profileProvider
                                .currentSiswa?.internship?.teacher?.nama ??
                            "-",
                        value3: profileProvider.currentSiswa?.internship
                                ?.teacher?.bidangStudi ??
                            "-",
                        value4: profileProvider
                                .currentSiswa?.internship?.teacher?.jabatan ??
                            "-"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Skeletonizer(
                    enabled: loading,
                    enableSwitchAnimation: true,
                    child: _buildInfoCard(
                        image:
                            '${BaseApi.instructorImageUrl}/${profileProvider.currentSiswa?.internship?.instructor?.foto}',
                        colorHeader: GlobalColorTheme.primaryBlueColor,
                        title: 'Instruktur',
                        property1: 'NIP',
                        property2: 'Nama',
                        property3: 'No HP',
                        property4: 'Alamat',
                        value1: profileProvider
                                .currentSiswa?.internship?.instructor?.nip ??
                            "-",
                        value2: profileProvider
                                .currentSiswa?.internship?.instructor?.nama ??
                            "-",
                        value3: profileProvider
                                .currentSiswa?.internship?.instructor?.hp ??
                            "-",
                        value4: profileProvider
                                .currentSiswa?.internship?.instructor?.alamat ??
                            "-"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Skeletonizer(
                    enabled: loading,
                    enableSwitchAnimation: true,
                    child: _buildInfoCard(
                      image: fotoCorporate,
                      fallbackImage: logoCorporate,
                      colorHeader: GlobalColorTheme.primaryBlueColor,
                      title: 'Mitra',
                      property1: 'Nama Perusahaan',
                      property2: 'No HP',
                      property3: 'Alamat',
                      value1: profileProvider
                              .currentSiswa?.internship?.corporation?.nama ??
                          "-",
                      value2: profileProvider
                              .currentSiswa?.internship?.corporation?.hp ??
                          "-",
                      value3: profileProvider
                              .currentSiswa?.internship?.corporation?.alamat ??
                          "-",
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildWelcomeCard({String? name}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, $name!',
                  style: GoogleFonts.poppins(
                    color: GlobalColorTheme.primaryBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tetap semangat dan teruslah berkarya! Ingat, setiap langkah kecilmu membawa perubahan besar.',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/man-with-laptop-light.png',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildInfoCard(
      {required Color colorHeader,
      required String title,
      required String property1,
      required String property2,
      required String property3,
      required String image,
      String? fallbackImage,
      String? property4,
      String? value1,
      String? value2,
      String? value3,
      String? value4}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: colorHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildImageWidget(image, fallbackImage),
                const Divider(),
                _buildInfoRow(property1, value1 ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow(property2, value2 ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow(property3, value3 ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow(property4 ?? '', value4 ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String image, String? fallbackImage) {
    if (image.isNotEmpty) {
      return FutureBuilder<Uint8List?>(
        future: _loadImageBytes(image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              errorBuilder: (context, error, stackTrace) {
                debugPrint(
                    'Failed to display primary image: $image, error: $error');
                if (fallbackImage != null && fallbackImage.isNotEmpty) {
                  return FutureBuilder<Uint8List?>(
                    future: _loadImageBytes(fallbackImage),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot2.hasData && snapshot2.data != null) {
                        return Image.memory(snapshot2.data!);
                      } else {
                        return const Icon(
                          Icons.business,
                          size: 100,
                          color: Colors.grey,
                        );
                      }
                    },
                  );
                } else {
                  return const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey,
                  );
                }
              },
            );
          } else {
            debugPrint('Failed to load primary image bytes: $image');
            if (fallbackImage != null && fallbackImage.isNotEmpty) {
              return FutureBuilder<Uint8List?>(
                future: _loadImageBytes(fallbackImage),
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot2.hasData && snapshot2.data != null) {
                    return Image.memory(snapshot2.data!);
                  } else {
                    return const Icon(
                      Icons.business,
                      size: 100,
                      color: Colors.grey,
                    );
                  }
                },
              );
            } else {
              return const Icon(
                Icons.person,
                size: 100,
                color: Colors.grey,
              );
            }
          }
        },
      );
    } else if (fallbackImage != null && fallbackImage.isNotEmpty) {
      return FutureBuilder<Uint8List?>(
        future: _loadImageBytes(fallbackImage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(snapshot.data!);
          } else {
            debugPrint('Failed to load fallback image bytes: $fallbackImage');
            return const Icon(
              Icons.business,
              size: 100,
              color: Colors.grey,
            );
          }
        },
      );
    } else {
      return const Icon(
        Icons.person,
        size: 100,
        color: Colors.grey,
      );
    }
  }

  Future<Uint8List?> _loadImageBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint(
            'Failed to load image: $url, status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error loading image: $url, error: $e');
      return null;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        Text(
          ': $value',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
