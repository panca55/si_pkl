import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/models/siswa/internship_model.dart';
import 'package:si_pkl/provider/siswa/intern_provider.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:http/http.dart' as http;

class AttendanceDetailPage extends StatefulWidget {
  static const String routname = '/attendanceDetail';
  const AttendanceDetailPage({super.key});

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  String _selectedFilter = 'semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<InternProvider>()
          .getAttendanceDetail(filter: _selectedFilter);
    });
  }

  void _onFilterChanged(String? filter) {
    if (filter != null) {
      setState(() {
        _selectedFilter = filter;
      });
      context
          .read<InternProvider>()
          .getAttendanceDetail(filter: filter == 'semua' ? null : filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<InternProvider>(
        builder: (context, provider, child) {
          final attendanceResponse = provider.attendanceResponse;

          if (attendanceResponse == null) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                ),
              ),
            );
          }

          final attendances = attendanceResponse.attendances ?? [];

          return Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Kehadiran',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pantau dan kelola catatan kehadiran PKL Anda',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Filter Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color(0xFF1976D2)),
                        style: const TextStyle(
                          color: Color(0xFF1976D2),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'semua',
                            child: Text('Semua Data'),
                          ),
                          const DropdownMenuItem(
                            value: 'per-minggu',
                            child: Text('Per Minggu'),
                          ),
                          const DropdownMenuItem(
                            value: 'per-bulan',
                            child: Text('Per Bulan'),
                          ),
                        ],
                        onChanged: _onFilterChanged,
                      ),
                    ),
                  ],
                ),
              ),

              // Attendance Table
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: attendances.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada data absensi',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(120),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(80),
                              3: FixedColumnWidth(120),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1976D2),
                                ),
                                children: const [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Tanggal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Jam',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Berkas',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Data Rows
                              ...attendances.map((attendance) => TableRow(
                                    decoration: BoxDecoration(
                                      color:
                                          attendances.indexOf(attendance).isEven
                                              ? Colors.grey.shade50
                                              : Colors.white,
                                    ),
                                    children: [
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            _formatDate(attendance.tanggal),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF1976D2),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                  attendance.keterangan),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              attendance.keterangan ?? '-',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            _formatTime(attendance.createdAt),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: _buildFileCell(attendance),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) return '-';
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '-';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'HADIR':
        return Colors.green;
      case 'IZIN':
        return Colors.orange;
      case 'SAKIT':
        return Colors.red;
      case 'ALPHA':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildFileCell(Attendance attendance) {
    final keterangan = attendance.keterangan?.toUpperCase();
    debugPrint(
        'Building file cell for attendance: ${attendance.tanggal}, keterangan: $keterangan, photo: ${attendance.photo}, deskripsi: ${attendance.deskripsi}');

    if (keterangan == 'IZIN' || keterangan == 'SAKIT') {
      final fileUrl =
          attendance.deskripsi != null && attendance.deskripsi!.isNotEmpty
              ? '${BaseApi.suratIzinFileUrl}/${attendance.deskripsi}'
              : null;

      debugPrint('File URL for IZIN/SAKIT: $fileUrl');

      if (fileUrl != null) {
        return ElevatedButton.icon(
          onPressed: () {
            // Open file viewer or download
            _showFileDialog(fileUrl, 'Surat ${keterangan!.toLowerCase()}');
          },
          icon: const Icon(Icons.visibility, size: 16),
          label: const Text(
            'Lihat Berkas',
            style: TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        return const Text(
          'Berkas tidak tersedia',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        );
      }
    } else {
      // For HADIR status, show photo
      final photoUrl = attendance.photo != null && attendance.photo!.isNotEmpty
          ? '${BaseApi.absenImageUrl}/${attendance.photo}'
          : null;

      debugPrint('BaseApi.absenImageUrl: ${BaseApi.absenImageUrl}');
      debugPrint('attendance.photo: ${attendance.photo}');
      debugPrint('Photo URL for HADIR: $photoUrl');

      if (photoUrl != null) {
        return GestureDetector(
          onTap: () => _showImageDialog(photoUrl, 'Foto Absensi'),
          child: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FutureBuilder<http.Response>(
                future: http.get(Uri.parse(photoUrl)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1976D2)),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError ||
                      snapshot.data?.statusCode != 200 ||
                      snapshot.data?.bodyBytes.isEmpty == true) {
                    debugPrint(
                        'Error loading image: $photoUrl, Error: ${snapshot.error}, Status: ${snapshot.data?.statusCode}, Body length: ${snapshot.data?.bodyBytes.length}');
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 24,
                      ),
                    );
                  } else {
                    return Image.memory(
                      snapshot.data!.bodyBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                            'Error displaying image: $photoUrl, Error: $error');
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 24,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      } else {
        return Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 24,
          ),
        );
      }
    }
  }

  void _showImageDialog(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Image
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<http.Response>(
                      future: http.get(Uri.parse(imageUrl)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1976D2)),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError ||
                            snapshot.data?.statusCode != 200 ||
                            snapshot.data?.bodyBytes.isEmpty == true) {
                          debugPrint(
                              'Error loading full image: $imageUrl, Error: ${snapshot.error}, Status: ${snapshot.data?.statusCode}, Body length: ${snapshot.data?.bodyBytes.length}');
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 48,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Foto tidak dapat dimuat',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Image.memory(
                            snapshot.data!.bodyBytes,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                  'Error displaying full image: $imageUrl, Error: $error');
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 48,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Foto tidak dapat dimuat',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFileDialog(String fileUrl, String title) {
    // Check if it's an image file
    final isImage = fileUrl.toLowerCase().endsWith('.jpg') ||
        fileUrl.toLowerCase().endsWith('.jpeg') ||
        fileUrl.toLowerCase().endsWith('.png') ||
        fileUrl.toLowerCase().endsWith('.gif');

    if (isImage) {
      // Show image in dialog
      _showImageDialog(fileUrl, title);
    } else {
      // For non-image files, show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: const Text('Apakah Anda ingin membuka berkas ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openFile(fileUrl, title);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                ),
                child: const Text('Buka'),
              ),
            ],
          );
        },
      );
    }
  }

  void _openFile(String fileUrl, String title) {
    // Show snackbar with URL for user to manually open
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Berkas $title siap dibuka'),
            Text(
              fileUrl,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1976D2),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Salin URL',
          textColor: Colors.white,
          onPressed: () {
            // For web, we can't easily copy to clipboard without additional packages
            // Just show the URL in another snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(fileUrl),
                backgroundColor: Colors.grey[800],
                duration: const Duration(seconds: 5),
              ),
            );
          },
        ),
      ),
    );
  }
}
