class EvaluationsDetailModel {
  Assessment? assessment;
  EvaluationsDetailModel({this.assessment});
  factory EvaluationsDetailModel.fromJson(Map<String, dynamic> json) {
    return EvaluationsDetailModel(
      assessment: json['assessment'] != null
          ? Assessment.fromJson(json['assessment'])
          : null,
    );
  }
}
class Assessment {
  int? id;
  int? internshipId;
  String? nama;
  int? softskill;
  int? norma;
  int? teknis;
  int? pemahaman;
  String? catatan;
  int? score;
  String? deskripsiSoftskill;
  String? deskripsiNorma;
  String? deskripsiTeknis;
  String? deskripsiPemahaman;
  String? deskripsiCatatan;
  String? createdAt;
  String? updatedAt;

  Assessment({
    this.id,
    this.internshipId,
    this.nama,
    this.softskill,
    this.norma,
    this.teknis,
    this.pemahaman,
    this.catatan,
    this.score,
    this.deskripsiSoftskill,
    this.deskripsiNorma,
    this.deskripsiTeknis,
    this.deskripsiPemahaman,
    this.deskripsiCatatan,
    this.createdAt,
    this.updatedAt,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      internshipId: json['internship_id'],
      nama: json['nama'],
      softskill: json['softskill'],
      norma: json['norma'],
      teknis: json['teknis'],
      pemahaman: json['pemahaman'],
      catatan: json['catatan'],
      score: json['score'],
      deskripsiSoftskill: json['deskripsi_softskill'],
      deskripsiNorma: json['deskripsi_norma'],
      deskripsiTeknis: json['deskripsi_teknis'],
      deskripsiPemahaman: json['deskripsi_pemahaman'],
      deskripsiCatatan: json['deskripsi_catatan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
