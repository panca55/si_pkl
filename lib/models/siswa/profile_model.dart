class ProfileModel {
  int? id;
  int? userId;
  int? mayorId;
  String? nisn;
  String? nama;
  String? konsentrasi;
  String? tahunMasuk;
  String? jenisKelamin;
  String? statusPKl;
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
  Internship? internship;

  ProfileModel(
      {this.id,
      this.userId,
      this.mayorId,
      this.nisn,
      this.nama,
      this.konsentrasi,
      this.tahunMasuk,
      this.jenisKelamin,
      this.statusPKl,
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
      this.internship});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      userId: json['user_id'] != null
          ? int.parse(json['user_id'].toString())
          : null,
      mayorId: json['mayor_id'] != null
          ? int.parse(json['mayor_id'].toString())
          : null,
      nisn: json['nisn'],
      nama: json['nama'],
      konsentrasi: json['konsentrasi'],
      tahunMasuk: json['tahun_masuk'],
      jenisKelamin: json['jenis_kelamin'],
      statusPKl: json['status_pkl'],
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
      internship: json['internship'] != null
          ? Internship.fromJson(json['internship'])
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
  Teacher? teacher;
  Instructor? instructor;
  Corporation? corporation;
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
      this.teacher,
      this.instructor,
      this.corporation});
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
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
      corporation: json['corporation'] != null
          ? Corporation.fromJson(json['corporation'])
          : null,
    );
  }
}

class Mayor {
  int? id;
  int? departmentId;
  String? nama;
  String? createdAt;
  String? updatedAt;

  Mayor({
    this.id,
    this.departmentId,
    this.nama,
    this.createdAt,
    this.updatedAt,
  });

  factory Mayor.fromJson(Map<String, dynamic> json) {
    return Mayor(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      departmentId: json['department_id'] != null
          ? int.parse(json['department_id'].toString())
          : null,
      nama: json['nama'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
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

class Instructor {
  Instructor({
    this.id,
    this.userId,
    this.corporationId,
    this.nip,
    this.nama,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamat,
    this.hp,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? corporationId;
  String? nip;
  String? nama;
  String? jenisKelamin;
  String? tempatLahir;
  String? tanggalLahir;
  String? alamat;
  String? hp;
  String? foto;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        id: json["id"],
        userId: json["user_id"],
        nip: json["nip"],
        nama: json["nama"],
        jenisKelamin: json["jenis_kelamin"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        alamat: json["alamat"],
        hp: json["hp"],
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
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
