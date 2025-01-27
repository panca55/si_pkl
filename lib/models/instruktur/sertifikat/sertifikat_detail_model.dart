class SertifikatDetailModel {
  Internship? internship;
  List<Data>? data;
  SertifikatDetailModel({this.data, this.internship});
  factory SertifikatDetailModel.fromJson(Map<String, dynamic> json) {
    return SertifikatDetailModel(
      internship: Internship.fromJson(json['internship']),
      data: json["data"] is List
          ? (json["data"] as List)
              .map((item) => Data.fromJson(item as Map<String, dynamic>))
              .toList()
          : json["data"] != null
              ? [
                  Data.fromJson(
                      json["data"] as Map<String, dynamic>)
                ]
              : null,
    );
  }
}
class Internship {
  int? id;
  int? studentId;
  int? teacherId;
  int? corporationId;
  int? instructorId;
  String? tahunAjaran;
  String? tanggalMulai;
  String? tanggalBerakhir;
  String? status;
  String? createdAt;
  String? updatedAt;
  Student? student;
  Corporation? corporation;
  Internship({
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
    this.corporation,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      id: json['id'],
      studentId: json['student_id'],
      teacherId: json['teacher_id'],
      corporationId: json['corporation_id'],
      instructorId: json['instructor_id'],
      tahunAjaran: json['tahun_ajaran'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalBerakhir: json['tanggal_berakhir'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      student: Student.fromJson(json['student']),
      corporation: Corporation.fromJson(json['corporation']),
    );
  }
}
class Student {
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
  String? createdAt;
  String? updatedAt;
  Mayor? mayor;

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

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      userId: json['user_id'],
      mayorId: json['mayor_id'],
      nisn: json['nisn'],
      nama: json['nama'],
      konsentrasi: json['konsentrasi'],
      tahunMasuk: json['tahun_masuk'],
      jenisKelamin: json['jenis_kelamin'],
      statusPkl: json['status_pkl'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      alamatSiswa: json['alamat_siswa'],
      alamatOrtu: json['alamat_ortu'],
      hpSiswa: json['hp_siswa'],
      hpOrtu: json['hp_ortu'],
      foto: json['foto'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      mayor: Mayor.fromJson(json['mayor']),
    );
  }
}

class Mayor {
  int? id;
  int? departmentId;
  String? nama;
  String? createdAt;
  String? updatedAt;
  Department? department;

  Mayor({
    this.id,
    this.departmentId,
    this.nama,
    this.createdAt,
    this.updatedAt,
    this.department,
  });

  factory Mayor.fromJson(Map<String, dynamic> json) {
    return Mayor(
      id: json['id'],
      departmentId: json['department_id'],
      nama: json['nama'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      department: Department.fromJson(json['department']),
    );
  }
}

class Department {
  int? id;
  String? nama;
  String? createdAt;
  String? updatedAt;

  Department({
    this.id,
    this.nama,
    this.createdAt,
    this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      nama: json['nama'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Corporation {
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
  String? deskripsi;
  String? hp;
  String? emailPerusahaan;
  String? website;
  String? instagram;
  String? tiktok;
  String? logo;
  String? foto;
  String? createdAt;
  String? updatedAt;

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

  factory Corporation.fromJson(Map<String, dynamic> json) {
    return Corporation(
      id: json['id'],
      userId: json['user_id'],
      nama: json['nama'],
      slug: json['slug'],
      alamat: json['alamat'],
      quota: json['quota'],
      mulaiHariKerja: json['mulai_hari_kerja'],
      akhirHariKerja: json['akhir_hari_kerja'],
      jamMulai: json['jam_mulai'],
      jamBerakhir: json['jam_berakhir'],
      deskripsi: json['deskripsi'],
      hp: json['hp'],
      emailPerusahaan: json['email_perusahaan'],
      website: json['website'],
      instagram: json['instagram'],
      tiktok: json['tiktok'],
      logo: json['logo'],
      foto: json['foto'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
class Data {
  int? id;
  int? internshipId;
  String? category;
  String? nama;
  int? score;
  String? predikat;
  String? file;
  String? namaPimpinan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.internshipId,
    this.category,
    this.nama,
    this.score,
    this.predikat,
    this.file,
    this.namaPimpinan,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for JSON parsing
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      internshipId: json['internship_id'],
      category: json['category'],
      nama: json['nama'],
      score: json['score'],
      predikat: json['predikat'],
      file: json['file'],
      namaPimpinan: json['nama_pimpinan'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'internship_id': internshipId,
      'category': category,
      'nama': nama,
      'score': score,
      'predikat': predikat,
      'file': file,
      'nama_pimpinan': namaPimpinan,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
