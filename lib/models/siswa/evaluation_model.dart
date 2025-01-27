class EvaluationModel {
  Internship? internship;
  dynamic feedback;
  EvaluationDate? evaluationDate;
  bool? isEvaluationEmpty;
  EvaluationModel(
      {this.internship,
      this.feedback,
      this.evaluationDate,
      this.isEvaluationEmpty});
  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      internship: json['internship'] == null
         ? null
          : Internship.fromJson(json['internship']),
      feedback: json['feedback'],
      evaluationDate: json['evaluation_date'] == null
         ? null
          : EvaluationDate.fromJson(json['evaluation_date']),
      isEvaluationEmpty: json['is_evaluation_empty'],
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
  Certificate? certificate;
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
      this.evaluation,
      this.certificate});
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
      evaluation: json['evaluation'] != null
          ? Evaluation.fromJson(json['evaluation'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      certificate: Certificate.fromJson(json['certificate']),
    );
  }
}
class Evaluation {
  int? monitoring;
  int? sertifikat;
  int? logbook;
  int? presentasi;
  int? nilaiAkhir;

  Evaluation({
    this.monitoring,
    this.sertifikat,
    this.logbook,
    this.presentasi,
    this.nilaiAkhir,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      monitoring: json['monitoring'],
      sertifikat: json['sertifikat'],
      logbook: json['logbook'],
      presentasi: json['presentasi'],
      nilaiAkhir: json['nilai_akhir'],
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
  dynamic file;
  String? namaPimpinan;
  String? createdAt;
  String? updatedAt;
  Certificate(
      {this.id,
      this.internshipId,
      this.category,
      this.nama,
      this.score,
      this.predikat,
      this.file,
      this.namaPimpinan,
      this.createdAt,
      this.updatedAt});
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

class EvaluationDate {
  int? id;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  EvaluationDate(
      {this.id, this.startDate, this.endDate, this.createdAt, this.updatedAt});
  factory EvaluationDate.fromJson(Map<String, dynamic> json) {
    return EvaluationDate(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
