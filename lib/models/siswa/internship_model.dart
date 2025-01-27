class InternshipModel {
  Internship? internship;
  String? status;
  double? presentaseKehadiran;
  AttendanceDetail? detailKehadiran;
  bool? kehadiranHariIni;
  bool? cekHadir;
  bool? jamKerja;
  List<Logbook>? logbook;

  InternshipModel({
    this.internship,
    this.status,
    this.presentaseKehadiran,
    this.detailKehadiran,
    this.kehadiranHariIni,
    this.cekHadir,
    this.jamKerja,
    this.logbook,
  });

  factory InternshipModel.fromJson(Map<String, dynamic> json) {
    return InternshipModel(
      internship: json['intership'] != null
          ? Internship.fromJson(json['intership'])
          : null,
      status: json['status'],
      presentaseKehadiran: (json['presentase_kehadiran'] as num?)?.toDouble(),
      detailKehadiran: json['detail_kehadiran'] != null
          ? AttendanceDetail.fromJson(json['detail_kehadiran'])
          : null,
      kehadiranHariIni: json['kehadiran_hari_ini'],
      cekHadir: json['cek_hadir'],
      jamKerja: json['jam_kerja'],
      logbook: json['logbook'] != null
          ? List<Logbook>.from(
              json['logbook'].map((item) => Logbook.fromJson(item)))
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
      corporation: json['corporation'] != null
          ? Corporation.fromJson(json['corporation'])
          : null,
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

class AttendanceDetail {
  int? hadir;
  int? izin;
  int? sakit;
  int? alpha;

  AttendanceDetail({
    this.hadir,
    this.izin,
    this.sakit,
    this.alpha,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      hadir: json['HADIR'],
      izin: json['IZIN'],
      sakit: json['SAKIT'],
      alpha: json['ALPHA'],
    );
  }
}
