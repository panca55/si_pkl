class EvaluationsModel {
  List<Internship>? internship;
  List<Evaluations>? evaluations;
  List<EvaluationDates>? evaluationsDates;
  EvaluationsModel({this.internship, this.evaluations, this.evaluationsDates});

  factory EvaluationsModel.fromJson(Map<String, dynamic> json) {
    final dates = json['evaluationDates'] != null
        ? List<EvaluationDates>.from(json['evaluationDates'].map(
                (evaluationDate) => EvaluationDates.fromJson(evaluationDate)))
            .cast<EvaluationDates>()
        : <EvaluationDates>[];
    return EvaluationsModel(
      internship: json['internships'] != null
          ? List<Internship>.from(json['internships']
              .map((internship) => Internship.fromJson(internship)))
          : [],
      evaluations: json['evaluations'] != null
          ? List<Evaluations>.from(json['evaluations']
              .map((evaluation) => Evaluations.fromJson(evaluation)))
          : [],
      evaluationsDates: dates,
    );
  }
}

class Evaluations {
  int? id;
  int? internshipId;
  int? monitoring;
  int? sertifikat;
  int? logbook;
  int? presentasi;
  int? nilaiAkhir;
  String? createdAt;
  String? updatedAt;
  Evaluations(
      {this.id,
      this.internshipId,
      this.monitoring,
      this.sertifikat,
      this.logbook,
      this.presentasi,
      this.nilaiAkhir,
      this.createdAt,
      this.updatedAt});
  factory Evaluations.fromJson(Map<String, dynamic> json) {
    return Evaluations(
      id: json['id'] as int,
      internshipId: json['internship_id'] as int,
      monitoring: json['monitoring'] as int,
      sertifikat: json['sertifikat'] as int,
      logbook: json['logbook'] as int,
      presentasi: json['presentasi'] as int,
      nilaiAkhir: json['nilai_akhir'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class EvaluationDates {
  int? id;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  EvaluationDates(
      {this.id, this.startDate, this.endDate, this.createdAt, this.updatedAt});
  factory EvaluationDates.fromJson(Map<String, dynamic> json) {
    return EvaluationDates(
      id: json['id'] as int?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
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
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Student? student;
  Teacher? teacher;
  Corporation? corporation;
  Evaluation? evaluation;
  List<Assessment>? assessment;
  Certificate? certificate;

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
    this.teacher,
    this.corporation,
    this.evaluation,
    this.assessment,
    this.certificate,
  });

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      id: json['id'],
      studentId: json['student_id'],
      teacherId: json['teacher_id'],
      corporationId: json['corporation_id'],
      instructorId: json['instructor_id'],
      tahunAjaran: json['tahun_ajaran'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalBerakhir: DateTime.parse(json['tanggal_berakhir']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      corporation: json['corporation'] != null
          ? Corporation.fromJson(json['corporation'])
          : null,
      evaluation: json['evaluation'] != null
          ? Evaluation.fromJson(json['evaluation'])
          : null,
      assessment: (json['assessment'] as List)
          .map((e) => Assessment.fromJson(e))
          .toList(),
      certificate: json['certificate'] != null
          ? Certificate.fromJson(json['certificate'])
          : null,
    );
  }
}

class Evaluation {
  int? id;
  int? internshipId;
  int? monitoring;
  int? sertifikat;
  int? logbook;
  int? presentasi;
  int? nilaiAkhir;
  DateTime? createdAt;
  DateTime? updatedAt;

  Evaluation({
    this.id,
    this.internshipId,
    this.monitoring,
    this.sertifikat,
    this.logbook,
    this.presentasi,
    this.nilaiAkhir,
    this.createdAt,
    this.updatedAt,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      internshipId: json['internship_id'],
      monitoring: json['monitoring'],
      sertifikat: json['sertifikat'],
      logbook: json['logbook'],
      presentasi: json['presentasi'],
      nilaiAkhir: json['nilai_akhir'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Assessment {
  int? id;
  int? internshipId;
  String? nama;
  int? softskill;
  int? norma;
  int? teknis;
  int? pemahaman;
  String? catatan;
  int? score;
  String? deskripsiSoftskill;
  String? deskripsiNorma;
  String? deskripsiTeknis;
  String? deskripsiPemahaman;
  String? deskripsiCatatan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Assessment({
    this.id,
    this.internshipId,
    this.nama,
    this.softskill,
    this.norma,
    this.teknis,
    this.pemahaman,
    this.catatan,
    this.score,
    this.deskripsiSoftskill,
    this.deskripsiNorma,
    this.deskripsiTeknis,
    this.deskripsiPemahaman,
    this.deskripsiCatatan,
    this.createdAt,
    this.updatedAt,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      internshipId: json['internship_id'],
      nama: json['nama'],
      softskill: json['softskill'],
      norma: json['norma'],
      teknis: json['teknis'],
      pemahaman: json['pemahaman'],
      catatan: json['catatan'],
      score: json['score'],
      deskripsiSoftskill: json['deskripsi_softskill'],
      deskripsiNorma: json['deskripsi_norma'],
      deskripsiTeknis: json['deskripsi_teknis'],
      deskripsiPemahaman: json['deskripsi_pemahaman'],
      deskripsiCatatan: json['deskripsi_catatan'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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

class Certificate {
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

  Certificate({
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

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
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
        updatedAt: DateTime.parse(json["updated_at"]),
      );

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
