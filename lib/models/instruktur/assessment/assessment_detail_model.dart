class AssessmentDetailModel {
  Assessment? assessment;
  AssessmentDetailModel({this.assessment});
  factory AssessmentDetailModel.fromJson(Map<String, dynamic> json) {
    return AssessmentDetailModel(
      assessment: json['assessment'] != null
          ? Assessment.fromJson(json['assessment'])
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
  Instructor? instructor;
  Teacher? teacher;

  Internship(
      {this.id,
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
      this.instructor,
      this.teacher});

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
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      corporation: json['corporation'] != null
          ? Corporation.fromJson(json['corporation'])
          : null,
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
    );
  }
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

class Assessment {
  int? id;
  int? internshipId;
  String? nama;
  int? softSkill;
  int? norma;
  int? teknis;
  int? pemahaman;
  String? catatan;
  int? score;
  String? deskripsiSoftSkill;
  String? deskripsiNorma;
  String? deskripsiTeknis;
  String? deskripsiPemahaman;
  String? deskripsiCatatan;
  String? createdAt;
  String? updatedAt;
  Internship? internship;
  Assessment(
      {this.id,
      this.internshipId,
      this.nama,
      this.softSkill,
      this.norma,
      this.teknis,
      this.pemahaman,
      this.catatan,
      this.score,
      this.deskripsiSoftSkill,
      this.deskripsiNorma,
      this.deskripsiTeknis,
      this.deskripsiPemahaman,
      this.deskripsiCatatan,
      this.createdAt,
      this.updatedAt,
      this.internship
      });
  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      internshipId: json['internship_id'],
      nama: json['nama'],
      softSkill: json['softskill'],
      norma: json['norma'],
      teknis: json['teknis'],
      pemahaman: json['pemahaman'],
      catatan: json['catatan'],
      score: json['score'],
      deskripsiSoftSkill: json['deskripsi_softskill'],
      deskripsiNorma: json['deskripsi_norma'],
      deskripsiTeknis: json['deskripsi_teknis'],
      deskripsiPemahaman: json['deskripsi_pemahaman'],
      deskripsiCatatan: json['deskripsi_catatan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      internship: json['internship'] != null
          ? Internship.fromJson(json['internship'])
          : null,
    );
  }
}

class Instructor {
  int? id;
  String? nama;
  String? spesialisasi;

  Instructor({this.id, this.nama, this.spesialisasi});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      nama: json['nama'],
      spesialisasi: json['spesialisasi'],
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
    this.mayor,
    this.createdAt,
    this.updatedAt,
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
  Mayor? mayor;
  DateTime? createdAt;
  DateTime? updatedAt;

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
      mayor: json['mayor'] != null ? Mayor.fromJson(json['mayor']) : null,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]));

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
