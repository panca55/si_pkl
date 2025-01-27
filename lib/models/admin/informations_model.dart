class InformationsModel {
  List<Information>? information;
  InformationsModel({this.information});
  factory InformationsModel.fromJson(Map<String, dynamic> json) {
    return InformationsModel(
      information: List<Information>.from(json['informations']
          .map((information) => Information.fromJson(information))),
    );
  }
}

class Information{
  int? id;
  String? nama;
  String? isi;
  String? tanggalMulai;
  String? tanggalBerakhir;
  String? createdAt;
  String? updatedAt;
  Information({this.id, this.nama, this.isi, this.tanggalMulai, this.tanggalBerakhir, this.createdAt, this.updatedAt});
  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      id: json['id'],
      nama: json['nama'],
      isi: json['isi'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalBerakhir: json['tanggal_berakhir'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}