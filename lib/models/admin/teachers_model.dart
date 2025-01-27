class TeachersModel {
  List<Teacher>? teachers;
  TeachersModel({this.teachers});

  factory TeachersModel.fromJson(Map<String, dynamic> json) {
    return TeachersModel(
      teachers: List<Teacher>.from(json['teachers'].map((teachers) => Teacher.fromJson(teachers))),
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
    this.user,
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
  User? user;

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
        user: json['user'] != null ? User.fromJson(json['user']) : null,
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
