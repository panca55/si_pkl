import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/Services/base_api.dart';
import 'package:si_pkl/models/siswa/internship_model.dart';
import 'package:universal_io/io.dart' as universal_io;

class InternProvider extends BaseApi with ChangeNotifier {
  final List<InternshipModel> _intern = [];
  List<InternshipModel> get intern => _intern;
  InternshipModel? _currentIntern;
  InternshipModel? get currentIntern => _currentIntern;
  final AuthController authController;

  InternProvider({required this.authController});

  // Mendapatkan data internship siswa
  Future<void> getInternSiswa() async {
    final tokenUser = authController.authToken;
    try {
      http.Response response = await http.get(
        super.internPath,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _currentIntern = InternshipModel.fromJson(responseData);
        notifyListeners();
        debugPrint('Berhasil mendapatkan data internship siswa');
        debugPrint('Data: ${response.body}');
      } else {
        debugPrint('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getInternSiswa: $e');
    }
  }

  // Submit absensi siswa
  Future<void> submitAttendance({
    required String keterangan,
    required Uint8List fileBytes,
    String? filePath,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.internPath;
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(super.getMultipartHeaders(tokenUser))
        ..fields['keterangan'] = keterangan;

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: 'logbook.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      } else if (universal_io.Platform.isAndroid ||
          universal_io.Platform.isIOS) {
        if (filePath != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file',
              filePath,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        } else {
          throw Exception("File path is required for mobile platform.");
        }
      }

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        _currentIntern?.kehadiranHariIni = true;
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);
        notifyListeners();
        debugPrint('Berhasil submit absensi');
        debugPrint('Response headers: ${response.headers}');
        debugPrint('Response body: $responseBody');
        debugPrint('Response data: $responseData');
      } else {
        debugPrint('Gagal submit absensi: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error submitAttendance: $e');
    }
  }

  // Submit logbook siswa
  Future<void> submitLogbook({
    required String judul,
    required String category,
    String? bentukKegiatan,
    String? penugasanPekerjaan,
    required String tanggal,
    required String mulai,
    required String selesai,
    required String petugas,
    required String isi,
    required String keterangan,
    required Uint8List fileBytes,
    String? filePath,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.logbookPostPath;
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(super.getHeaders(tokenUser))
        ..fields.addAll({
          'judul': judul,
          'category': category,
          if (bentukKegiatan != null) 'bentuk_kegiatan': bentukKegiatan,
          if (penugasanPekerjaan != null)
            'penugasan_pekerjaan': penugasanPekerjaan,
          'tanggal': tanggal,
          'mulai': mulai,
          'selesai': selesai,
          'petugas': petugas,
          'isi': isi,
          'keterangan': keterangan,
        });

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'foto_kegiatan',
            fileBytes,
            filename: 'attendance_photo.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      } else if (universal_io.Platform.isAndroid ||
          universal_io.Platform.isIOS) {
        if (filePath != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto_kegiatan',
              filePath,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        } else {
          throw Exception("File path is null for mobile platform.");
        }
      }

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil submit logbook');
        final newLogbook = Logbook(
          judul: judul,
          category: category,
          tanggal: tanggal,
          mulai: mulai,
          selesai: selesai,
          petugas: petugas,
          isi: isi,
          keterangan: keterangan,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        _currentIntern?.logbook?.add(newLogbook);
        notifyListeners();
      } else {
        debugPrint('Gagal submit logbook: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error submitLogbook: $e');
    }
  }

  Future<void> editLogbook({
    required int id,
    required String judul,
    required String category,
    String? bentukKegiatan,
    String? penugasanPekerjaan,
    required String tanggal,
    required String mulai,
    required String selesai,
    required String petugas,
    required String isi,
    required String keterangan,
    Uint8List? fileBytes,
    String? filePath,
  }) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.editLogbookPath(id);
      debugPrint('Edit logbook URL: $uri');
      debugPrint(
          'Edit logbook data: judul=$judul, category=$category, isi=$isi, keterangan=$keterangan');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(super.getHeaders(tokenUser))
        ..fields.addAll({
          'judul': judul,
          'category': category,
          if (bentukKegiatan != null) 'bentuk_kegiatan': bentukKegiatan,
          if (penugasanPekerjaan != null)
            'penugasan_pekerjaan': penugasanPekerjaan,
          'tanggal': tanggal,
          'mulai': mulai,
          'selesai': selesai,
          'petugas': petugas,
          'isi': isi,
          'keterangan': keterangan,
        });

      debugPrint('Fields being sent: ${request.fields}');

      if (kIsWeb) {
        if (fileBytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto_kegiatan',
              fileBytes,
              filename: 'attendance_photo.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      } else if (universal_io.Platform.isAndroid ||
          universal_io.Platform.isIOS) {
        if (filePath != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto_kegiatan',
              filePath,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        } else {
          throw Exception("File path is null for mobile platform.");
        }
      }

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Berhasil edit logbook');
        // Update existing logbook
        final logbookIndex =
            _currentIntern?.logbook?.indexWhere((lb) => lb.id == id);
        if (logbookIndex != null && logbookIndex >= 0) {
          final updatedLogbook = Logbook(
            id: id,
            judul: judul,
            category: category,
            bentukKegiatan: bentukKegiatan,
            penugasanPekerjaan: penugasanPekerjaan,
            tanggal: tanggal,
            mulai: mulai,
            selesai: selesai,
            petugas: petugas,
            isi: isi,
            keterangan: keterangan,
            createdAt: _currentIntern!.logbook![logbookIndex].createdAt,
            updatedAt: DateTime.now().toString(),
          );
          _currentIntern!.logbook![logbookIndex] = updatedLogbook;
        }
        notifyListeners();
      } else {
        debugPrint('Gagal edit logbook: ${response.statusCode}');
        // Show error message
        throw Exception('Failed to edit logbook: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error editLogbook: $e');
      rethrow;
    }
  }

  Future<void> deleteLogbook({required int id}) async {
    final tokenUser = authController.authToken;
    try {
      final uri = super.deleteLogbookPath(id);
      final response = await http.delete(
        uri,
        headers: super.getHeaders(tokenUser),
      );
      if (response.statusCode == 200) {
        _currentIntern?.logbook
            ?.removeWhere((logbook) => logbook.id == id);
        notifyListeners();
        debugPrint('Berhasil menghapus logbook');
      } else {
        debugPrint('Gagal menghapus logbook: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleteLogbook: $e');
    }
  }
  // Periksa apakah hari ini dalam masa PKL
  bool isMasaPkl({
    required String tanggalMulai,
    required String tanggalBerakhir,
  }) {
    try {
      final DateTime startDate = DateTime.parse(tanggalMulai);
      final DateTime endDate = DateTime.parse(tanggalBerakhir);
      final DateTime today = DateTime.now();
      if (startDate.isAfter(endDate)) {
        throw ArgumentError(
            'Tanggal mulai tidak boleh lebih besar dari tanggal berakhir.');
      }
      return today.isAfter(startDate) && today.isBefore(endDate);
    } catch (e) {
      debugPrint('Error in isMasaPkl: $e');
      return false;
    }
  }

  // Periksa apakah saat ini dalam jam kerja
  bool isWithinWorkingHours({
    required String mulaiHariKerja,
    required String akhirHariKerja,
    required String? jamMulai,
    required String? jamBerakhir,
    required bool hasCheckedInToday,
  }) {
    try {
      if (hasCheckedInToday || jamMulai == null || jamBerakhir == null) {
        return false;
      }

      final now = DateTime.now();
      final TimeOfDay startTime = TimeOfDay(
        hour: int.parse(jamMulai.split(":")[0]),
        minute: int.parse(jamMulai.split(":")[1]),
      );
      final TimeOfDay endTime = TimeOfDay(
        hour: int.parse(jamBerakhir.split(":")[0]),
        minute: int.parse(jamBerakhir.split(":")[1]),
      );

      final DateTime startDateTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);
      final DateTime endDateTime =
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

      return now.isAfter(startDateTime) && now.isBefore(endDateTime);
    } catch (e) {
      debugPrint('Error in isWithinWorkingHours: $e');
      return false;
    }
  }

  // Getter untuk tombol kehadiran
  bool get canShowAttendanceButton {
    final intern = _currentIntern;
    return isWithinWorkingHours(
      mulaiHariKerja:
          intern?.internship?.corporation?.mulaiHariKerja ?? "Senin",
      akhirHariKerja:
          intern?.internship?.corporation?.akhirHariKerja ?? "Sabtu",
      jamMulai: intern?.internship?.corporation?.jamMulai,
      jamBerakhir: intern?.internship?.corporation?.jamBerakhir,
      hasCheckedInToday: intern?.kehadiranHariIni ?? false,
    );
  }

  // Getter untuk informasi PKL
  bool get canShowInternInfo {
    final intern = _currentIntern;
    debugPrint('tanggal mulai: ${intern?.internship?.tanggalMulai}');
    debugPrint('tanggal berakhir: ${intern?.internship?.tanggalBerakhir}');
    return intern?.internship?.tanggalMulai != null &&
        intern?.internship?.tanggalBerakhir != null &&
        isMasaPkl(
          tanggalMulai: intern!.internship!.tanggalMulai!,
          tanggalBerakhir: intern.internship!.tanggalBerakhir!,
        );
  }
}
