class DashboardModel {
  Corporation? corporation;
  List<Internships>? internships;
  List<Instructors>? instructors;
  DashboardModel({this.corporation, this.internships, this.instructors});
  factory DashboardModel.fromJson(Map<String, dynamic> json){
    return DashboardModel(
      corporation: json['corporation'] != null
            ? Corporation.fromJson(json['corporation'])
            : null,
      internships: json["internships"] is List
            ? (json["internships"] as List)
                .map(
                    (item) => Internships.fromJson(item as Map<String, dynamic>))
                .toList()
            : json["internship"] != null
                ? [
                    Internships.fromJson(
                        json["internships"] as Map<String, dynamic>)
                  ]
                : null,
      instructors: json["instructors"] is List
          ? (json["instructors"] as List)
              .map((item) => Instructors.fromJson(item as Map<String, dynamic>))
              .toList()
          : json["instructors"] != null
              ? [
                  Instructors.fromJson(
                      json["instructors"] as Map<String, dynamic>)
                ]
              : null,
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

class Internships {
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
  Instructor? instructor;

  Internships({
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
    this.instructor,
  });

  factory Internships.fromJson(Map<String, dynamic> json) {
    return Internships(
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
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
    );
  }
}

class Instructor {
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
  String? createdAt;
  String? updatedAt;

  Instructor(
      {this.id,
      this.userId,
      this.corporationId,
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
      userId: json['user_id'],
      corporationId: json['corporation_id'],
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

class Instructors {
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
  String? createdAt;
  String? updatedAt;
  int? studentsCount;

  Instructors(
      {this.id,
      this.userId,
      this.corporationId,
      this.nama,
      this.nip,
      this.jenisKelamin,
      this.tempatLahir,
      this.tanggalLahir,
      this.alamat,
      this.hp,
      this.foto,
      this.createdAt,
      this.updatedAt,
      this.studentsCount
      });

  factory Instructors.fromJson(Map<String, dynamic> json) {
    return Instructors(
      id: json['id'],
      userId: json['user_id'],
      corporationId: json['corporation_id'],
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
      studentsCount: json['students_count'],
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
