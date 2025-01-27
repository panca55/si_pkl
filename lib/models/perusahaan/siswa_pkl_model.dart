class SiswaPklModel {
  List<Siswa>? siswa;
  SiswaPklModel({this.siswa});
  factory SiswaPklModel.fromJson(Map<String, dynamic>json){
    return SiswaPklModel(
      siswa: List<Siswa>.from(json['siswa'].map((siswa) => Siswa.fromJson(siswa))),
    );
  }
}

class Siswa {
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
  
  Siswa({
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
    
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
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
