class SiswaIndexModel {
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
  Siswa? student;
  List<Logbook>? logbook;
  Evaluation? evaluation;
  dynamic certificate;
  List<Assessment>? assessment;
  Attendance? attendance;

  SiswaIndexModel({
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
    this.logbook,
    this.evaluation,
    this.certificate,
    this.assessment,
    this.attendance,
  });

  factory SiswaIndexModel.fromJson(Map<String, dynamic> json) {
    return SiswaIndexModel(
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
      student: json['student'] != null ? Siswa.fromJson(json['student']) : null,
      logbook: json['logbook'] != null
          ? List<Logbook>.from(json['logbook'].map((x) => Logbook.fromJson(x)))
          : null,
      evaluation: json['evaluation'],
      certificate: json['certificate'],
      assessment: json['assessment'] != null
          ? List<Assessment>.from(
              json['assessment'].map((x) => Assessment.fromJson(x)))
          : null,
      attendance:
          json['summary'] != null ? Attendance.fromJson(json['summary']) : null,
    );
  }
}

class Evaluation {
  double? monitoring;
  double? sertifikat;
  double? logbook;
  double? presentasi;
  double? nilaiAkhir;
  String? createdAt;
  String? updatedAt;
  Evaluation(
      {this.monitoring,
      this.sertifikat,
      this.logbook,
      this.presentasi,
      this.nilaiAkhir,
      this.createdAt,
      this.updatedAt});
  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
        monitoring: json['monitoring'],
        sertifikat: json['sertifikat'],
        logbook: json['logbook'],
        presentasi: json['presentasi'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class Siswa {
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
  Instructor? instructor;
  User? user;

  Siswa(
      {this.id,
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
      this.instructor,
      this.user});

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
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
      mayor: json['mayor'] != null ? Mayor.fromJson(json['mayor']) : null,
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? role;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Mayor {
  int? id;
  int? departmentId;
  String? nama;
  Department? department;

  Mayor({
    this.id,
    this.departmentId,
    this.nama,
    this.department,
  });

  factory Mayor.fromJson(Map<String, dynamic> json) {
    return Mayor(
      id: json['id'],
      departmentId: json['department_id'],
      nama: json['nama'],
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
    );
  }
}

class Department {
  int? id;
  String? nama;

  Department({this.id, this.nama});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      nama: json['nama'],
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


class Logbook {
  int? id;
  int? internshipId;
  String? category;
  String? tanggal;
  String? judul;
  String? bentukKegiatan;
  String? penugasanPekerjaan;
  String? mulai;
  String? selesai;
  String? petugas;
  String? isi;
  String? fotoKegiatan;
  String? keterangan;
  String? createdAt;
  String? updatedAt;

  Logbook({
    this.id,
    this.internshipId,
    this.category,
    this.tanggal,
    this.judul,
    this.bentukKegiatan,
    this.penugasanPekerjaan,
    this.mulai,
    this.selesai,
    this.petugas,
    this.isi,
    this.fotoKegiatan,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  factory Logbook.fromJson(Map<String, dynamic> json) {
    return Logbook(
      id: json['id'],
      internshipId: json['internship_id'],
      category: json['category'],
      tanggal: json['tanggal'],
      judul: json['judul'],
      bentukKegiatan: json['bentuk_kegiatan'],
      penugasanPekerjaan: json['penugasan_pekerjaan'],
      mulai: json['mulai'],
      selesai: json['selesai'],
      petugas: json['petugas'],
      isi: json['isi'],
      fotoKegiatan: json['foto_kegiatan'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Attendance {
  int? hadir;
  int? izin;
  int? sakit;
  int? alpha;
  int? percentage;

  Attendance({
    this.hadir,
    this.izin,
    this.sakit,
    this.alpha,
    this.percentage,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      hadir: json['hadir'],
      izin: json['izin'],
      sakit: json['sakit'],
      alpha: json['alpha'],
      percentage: json['percentage'],
    );
  }
}

class Assessment {
  // Define fields if necessary based on your data model
  // Example:
  int? id;
  String? assessmentName;
  int? score;

  Assessment({this.id, this.assessmentName, this.score});

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      assessmentName: json['assessment_name'],
      score: json['score'],
    );
  }
}
