class SertifikatModel {
  List<Sertifikat>? sertifikat;
  SertifikatModel({this.sertifikat});
  factory SertifikatModel.fromJson(Map<String, dynamic> json) {
    return SertifikatModel(
      sertifikat: List<Sertifikat>.from(json['sertifikat']
          .map((sertifikat) => Sertifikat.fromJson(sertifikat))),
    );
  }
}

class Sertifikat {
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
  Teacher? teacher;
  Certificate? certificate;
  Sertifikat({
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
    this.teacher,
    this.certificate,
  });

  factory Sertifikat.fromJson(Map<String, dynamic> json) {
    return Sertifikat(
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
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      certificate: json['certificate'] != null
          ? Certificate.fromJson(json['certificate'])
          : null,
    );
  }
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
  String? createdAt;
  String? updatedAt;
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      mayor: json['mayor'] != null ? Mayor.fromJson(json['mayor']) : null,
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
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
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

class Teacher {
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
  String? createdAt;
  String? updatedAt;

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

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      userId: json['user_id'],
      nip: json['nip'],
      nama: json['nama'],
      jenisKelamin: json['jenis_kelamin'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      alamat: json['alamat'],
      hp: json['hp'],
      golongan: json['golongan'],
      bidangStudi: json['bidang_studi'],
      pendidikanTerakhir: json['pendidikan_terakhir'],
      jabatan: json['jabatan'],
      foto: json['foto'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
