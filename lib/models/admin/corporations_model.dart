class CorporationsModel {
  List<Corporations>? corporation;
  CorporationsModel({this.corporation});

  factory CorporationsModel.fromJson(Map<String, dynamic> json) {
    return CorporationsModel(
      corporation: List<Corporations>.from(json['corporations']
          .map((corporation) => Corporations.fromJson(corporation))),
    );
  }
}

class Corporations {
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
  User? user;

  Corporations({
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
    this.user,
  });

  factory Corporations.fromJson(Map<String, dynamic> json) {
    return Corporations(
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
