class ProfileModel {
  Profile? profile;
  ProfileModel({this.profile});
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profile: Profile.fromJson(json['profile'])
    );}
}
class Profile {
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

  Profile(
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

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
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
