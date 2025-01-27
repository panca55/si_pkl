class BimbinganIndexModel {
  Internship? internship;
  double? attendancePercentage;
  BimbinganIndexModel({this.internship, this.attendancePercentage});
  factory BimbinganIndexModel.fromJson(Map<String, dynamic> json) {
    return BimbinganIndexModel(
      internship: json['internship'] != null
          ? Internship.fromJson(json['internship'])
          : null,
      attendancePercentage: json['attendancePercentage'],
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
  List<Absents>? absents;
  Student? student;
  Corporation? corporation;
  Instructor? instructor;
  List<Logbook>? logbook;
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
      this.absents,
      this.student,
      this.corporation,
      this.instructor,
      this.logbook});

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
      absents: json['absents'] != null
          ? (json['absents'] as List)
              .map((absent) => Absents.fromJson(absent as Map<String, dynamic>))
              .toList()
          : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      corporation: json['corporation'] != null
          ? Corporation.fromJson(json['corporation'])
          : null,
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
      logbook: json['logbook'] != null
          ? List<Logbook>.from(
              json['logbook'].map((item) => Logbook.fromJson(item)))
          : null,
    );
  }
}

class Absents {
  int? id;
  int? internshipId;
  String? tanggal;
  String? keterangan;
  String? deskripsi;
  String? photo;
  String? createdAt;
  String? updatedAt;
  Absents(
      {this.id,
      this.internshipId,
      this.tanggal,
      this.keterangan,
      this.deskripsi,
      this.photo,
      this.createdAt,
      this.updatedAt});
  factory Absents.fromJson(Map<String, dynamic> json) {
    return Absents(
      id: json['id'],
      internshipId: json['internship_id'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      deskripsi: json['deskripsi'],
      photo: json['photo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
  List<Note>? note;

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
    this.note,
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
      note: json['note'] != null
          ? List<Note>.from(json['note'].map((item) => Note.fromJson(item)))
          : [],
    );
  }
}

class Note {
  // Properti note jika tersedia
  Note();

  factory Note.fromJson(Map<String, dynamic> json) {
    // Parsing properti note
    return Note();
  }
}

class Instructor {
  int? id;
  String? nip;
  String? nama;
  String? jenisKelamin;
  String? tempatLahir;
  String? tanggalLahir;
  String? alamat;
  String? hp;
  String? foto;
  String? createdAt;
  String? updatedAt;

  Instructor(
      {this.id,
      this.nama,
      this.nip,
      this.jenisKelamin,
      this.tempatLahir,
      this.tanggalLahir,
      this.alamat,
      this.hp,
      this.foto,
      this.createdAt,
      this.updatedAt});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      nama: json['nama'],
      nip: json['nip'],
      jenisKelamin: json['jenis_kelamin'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      alamat: json['alamat'],
      hp: json['hp'],
      foto: json['foto'],
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
