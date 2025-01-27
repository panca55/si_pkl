class EvaluationsShowModel{
  Internship? internship;
  List<Certificate>? certificate;
  EvaluationsShowModel({this.internship, this.certificate});
  factory EvaluationsShowModel.fromJson(Map<String, dynamic> json){
    return EvaluationsShowModel(
      internship: json['internships']!= null? Internship.fromJson(json['internships']) : null,
      certificate: (json['certificate'] as List)
          .map((item) => Certificate.fromJson(item))
          .toList(),
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
  Evaluation? evaluation;
  List<Assessment>? assessment;

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
    this.evaluation,
    this.assessment,
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
      evaluation: json['evaluation'] != null
          ? Evaluation.fromJson(json['evaluation'])
          : null,
      assessment: (json['assessment'] as List)
          .map((item) => Assessment.fromJson(item))
          .toList(),
    );
  }
}

class Evaluation {
  int? id;
  int? internshipId;
  int? monitoring;
  int? sertifikat;
  int? logbook;
  int? presentasi;
  int? nilaiAkhir;
  String? createdAt;
  String? updatedAt;

  Evaluation({
    this.id,
    this.internshipId,
    this.monitoring,
    this.sertifikat,
    this.logbook,
    this.presentasi,
    this.nilaiAkhir,
    this.createdAt,
    this.updatedAt,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      internshipId: json['internship_id'],
      monitoring: json['monitoring'],
      sertifikat: json['sertifikat'],
      logbook: json['logbook'],
      presentasi: json['presentasi'],
      nilaiAkhir: json['nilai_akhir'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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

class Certificate {
  int? id;
  int? internshipId;
  String? category;
  String? nama;
  int? score;
  String? predikat;
  String? file;
  String? namaPimpinan;
  String? createdAt;
  String? updatedAt;

  Certificate({
    this.id,
    this.internshipId,
    this.category,
    this.nama,
    this.score,
    this.predikat,
    this.file,
    this.namaPimpinan,
    this.createdAt,
    this.updatedAt,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'],
      internshipId: json['internship_id'],
      category: json['category'],
      nama: json['nama'],
      score: json['score'],
      predikat: json['predikat'],
      file: json['file'],
      namaPimpinan: json['nama_pimpinan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
