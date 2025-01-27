import 'dart:convert';

// Fungsi untuk parse dari JSON ke Model
SiswaModel siswaModelFromJson(String str) {
  final jsonData = json.decode(str);
  return SiswaModel.fromJson(jsonData);
}

// Fungsi untuk parse dari Model ke JSON
String siswaModelToJson(SiswaModel data) => json.encode(data.toJson());

// Model Utama
class SiswaModel {
  SiswaModel({
    required this.data,
    this.message,
    this.status,
  });

  final dynamic data;
  final String? message;
  final int? status;

  factory SiswaModel.fromJson(Map<String, dynamic> json) => SiswaModel(
        data: json["data"] is List
            ? List<DataSiswa>.from(
                json["data"].map((x) => DataSiswa.fromJson(x)))
            : DataSiswa.fromJson(json["data"]),
        message: json["message"] as String?,
        status: json["status"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "data": data is List<DataSiswa>
            ? List<dynamic>.from(
                (data as List<DataSiswa>).map((x) => x.toJson()))
            : (data as DataSiswa).toJson(),
        "message": message,
        "status": status,
      };
}

class DataSiswa {
  DataSiswa({
    this.id,
    this.studentId,
    this.teacherId,
    this.corporationId,
    this.instructorId,
    this.tahunAjaran,
    this.tanggalMulai,
    this.tanggalBerakhir,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.student,
    this.teacher,
    this.corporation,
    this.instructor,
  });

  final int? id;
  final int? studentId;
  final int? teacherId;
  final int? corporationId;
  final dynamic instructorId;
  final String? tahunAjaran;
  final String? tanggalMulai;
  final String? tanggalBerakhir;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Student? student;
  final Teacher? teacher;
  final Corporation? corporation;
  final dynamic instructor;

  factory DataSiswa.fromJson(Map<String, dynamic> json) => DataSiswa(
        id: json["id"] as int?,
        studentId: json["student_id"] as int?,
        teacherId: json["teacher_id"] as int?,
        corporationId: json["corporation_id"] as int?,
        instructorId: json["instructor_id"],
        tahunAjaran: json["tahun_ajaran"] as String?,
        tanggalMulai: json["tanggal_mulai"] as String?,
        tanggalBerakhir: json["tanggal_berakhir"] as String?,
        status: json["status"] as String?,
        createdAt: _parseDateTime(json["created_at"]),
        updatedAt: _parseDateTime(json["updated_at"]),
        student: json["student"] != null
            ? Student.fromJson(json["student"] as Map<String, dynamic>)
            : null,
        teacher: json["teacher"] != null
            ? Teacher.fromJson(json["teacher"] as Map<String, dynamic>)
            : null,
        corporation: json["corporation"] != null
            ? Corporation.fromJson(json["corporation"] as Map<String, dynamic>)
            : null,
        instructor: json["instructor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "teacher_id": teacherId,
        "corporation_id": corporationId,
        "instructor_id": instructorId,
        "tahun_ajaran": tahunAjaran,
        "tanggal_mulai": tanggalMulai,
        "tanggal_berakhir": tanggalBerakhir,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "student": student?.toJson(),
        "teacher": teacher?.toJson(),
        "corporation": corporation?.toJson(),
        "instructor": instructor,
      };
}

// Helper untuk parsing DateTime dengan aman
DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value as String);
  } catch (e) {
    return null; // Return null jika parsing gagal
  }
}

class Student {
  Student({
    this.id,
    this.userId,
    this.mayorId,
    this.nisn,
    this.nama,
    this.konsentrasi,
    this.tahunMasuk,
    this.jenisKelamin,
    this.statusPkl,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamatSiswa,
    this.alamatOrtu,
    this.hpSiswa,
    this.hpOrtu,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.mayor,
  });

  int? id;
  int? userId;
  int? mayorId;
  String? nisn;
  String? nama;
  String? konsentrasi;
  String? tahunMasuk;
  String? jenisKelamin;
  String? statusPkl;
  String? tempatLahir;
  String? tanggalLahir;
  String? alamatSiswa;
  String? alamatOrtu;
  String? hpSiswa;
  String? hpOrtu;
  String? foto;
  DateTime? createdAt;
  DateTime? updatedAt;
  Mayor? mayor;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
      id: json["id"],
      userId: json["user_id"],
      mayorId: json["mayor_id"],
      nisn: json["nisn"],
      nama: json["nama"],
      konsentrasi: json["konsentrasi"],
      tahunMasuk: json["tahun_masuk"],
      jenisKelamin: json["jenis_kelamin"],
      statusPkl: json["status_pkl"],
      tempatLahir: json["tempat_lahir"],
      tanggalLahir: json["tanggal_lahir"],
      alamatSiswa: json["alamat_siswa"],
      alamatOrtu: json["alamat_ortu"],
      hpSiswa: json["hp_siswa"],
      hpOrtu: json["hp_ortu"],
      foto: json["foto"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      mayor: Mayor.fromJson(json["mayor"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "mayor_id": mayorId,
        "nisn": nisn,
        "nama": nama,
        "konsentrasi": konsentrasi,
        "tahun_masuk": tahunMasuk,
        "jenis_kelamin": jenisKelamin,
        "status_pkl": statusPkl,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "alamat_siswa": alamatSiswa,
        "alamat_ortu": alamatOrtu,
        "hp_siswa": hpSiswa,
        "hp_ortu": hpOrtu,
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "mayor": mayor?.toJson(),
      };
}

class Mayor {
  int? id;
  int? departmentId;
  String? nama;
  DateTime? createdAt;
  DateTime? updatedAt;
  Department? department;

  Mayor(
      {this.id,
      this.departmentId,
      this.nama,
      this.createdAt,
      this.updatedAt,
      this.department});

  factory Mayor.fromJson(Map<String, dynamic> json) => Mayor(
      id: json["id"],
      departmentId: json["department_id"],
      nama: json["nama"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      department: Department.fromJson(json["department"]));
  Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "department": department?.toJson(),
      };
}

class Department {
  int? id;
  String? nama;
  DateTime? createdAt;
  DateTime? updatedAt;

  Department({this.id, this.nama, this.createdAt, this.updatedAt});
  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        nama: json["nama"],
        createdAt: DateTime.parse(json["created_at"]),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Teacher {
  Teacher({
    this.id,
    this.userId,
    this.nip,
    this.nama,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamat,
    this.hp,
    this.golongan,
    this.bidangStudi,
    this.pendidikanTerakhir,
    this.jabatan,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? nip;
  String? nama;
  String? jenisKelamin;
  String? tempatLahir;
  String? tanggalLahir;
  String? alamat;
  String? hp;
  String? golongan;
  String? bidangStudi;
  String? pendidikanTerakhir;
  String? jabatan;
  String? foto;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        userId: json["user_id"],
        nip: json["nip"],
        nama: json["nama"],
        jenisKelamin: json["jenis_kelamin"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        alamat: json["alamat"],
        hp: json["hp"],
        golongan: json["golongan"],
        bidangStudi: json["bidang_studi"],
        pendidikanTerakhir: json["pendidikan_terakhir"],
        jabatan: json["jabatan"],
        foto: json["foto"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nip": nip,
        "nama": nama,
        "jenis_kelamin": jenisKelamin,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "alamat": alamat,
        "hp": hp,
        "golongan": golongan,
        "bidang_studi": bidangStudi,
        "pendidikan_terakhir": pendidikanTerakhir,
        "jabatan": jabatan,
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Corporation {
  Corporation({
    this.id,
    this.userId,
    this.nama,
    this.slug,
    this.alamat,
    this.quota,
    this.mulaiHariKerja,
    this.akhirHariKerja,
    this.jamMulai,
    this.jamBerakhir,
    this.deskripsi,
    this.hp,
    this.emailPerusahaan,
    this.website,
    this.instagram,
    this.tiktok,
    this.logo,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? nama;
  String? slug;
  String? alamat;
  int? quota;
  String? mulaiHariKerja;
  String? akhirHariKerja;
  String? jamMulai;
  String? jamBerakhir;
  dynamic deskripsi; // Bisa null
  String? hp;
  dynamic emailPerusahaan; // Bisa null
  dynamic website; // Bisa null
  dynamic instagram; // Bisa null
  dynamic tiktok; // Bisa null
  dynamic logo; // Bisa null
  String? foto;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Corporation.fromJson(Map<String, dynamic> json) => Corporation(
        id: json["id"],
        userId: json["user_id"],
        nama: json["nama"],
        slug: json["slug"],
        alamat: json["alamat"],
        quota: json["quota"],
        mulaiHariKerja: json["mulai_hari_kerja"],
        akhirHariKerja: json["akhir_hari_kerja"],
        jamMulai: json["jam_mulai"],
        jamBerakhir: json["jam_berakhir"],
        deskripsi: json["deskripsi"],
        hp: json["hp"],
        emailPerusahaan: json["email_perusahaan"],
        website: json["website"],
        instagram: json["instagram"],
        tiktok: json["tiktok"],
        logo: json["logo"],
        foto: json["foto"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nama": nama,
        "slug": slug,
        "alamat": alamat,
        "quota": quota,
        "mulai_hari_kerja": mulaiHariKerja,
        "akhir_hari_kerja": akhirHariKerja,
        "jam_mulai": jamMulai,
        "jam_berakhir": jamBerakhir,
        "deskripsi": deskripsi,
        "hp": hp,
        "email_perusahaan": emailPerusahaan,
        "website": website,
        "instagram": instagram,
        "tiktok": tiktok,
        "logo": logo,
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
