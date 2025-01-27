class AbsentsModel {
  String? message;
  List<InternshipData>? data;
  String? filterOption;
  int? month;
  int? year;

  AbsentsModel({
    this.message,
    this.data,
    this.filterOption,
    this.month,
    this.year,
  });

  factory AbsentsModel.fromJson(Map<String, dynamic> json) {
    return AbsentsModel(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => InternshipData.fromJson(item))
          .toList(),
      filterOption: json['filterOption'],
      month: json['month'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
      'filterOption': filterOption,
      'month': month,
      'year': year,
    };
  }
}

class InternshipData {
  int? internshipId;
  String? nisn;
  String? nama;
  Absents? absents;

  InternshipData({
    this.internshipId,
    this.nisn,
    this.nama,
    this.absents,
  });

  factory InternshipData.fromJson(Map<String, dynamic> json) {
    return InternshipData(
      internshipId: json['internship_id'],
      nisn: json['nisn'],
      nama: json['nama'],
      absents: Absents.fromJson(json['absents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'internship_id': internshipId,
      'nisn': nisn,
      'nama': nama,
      'absents': absents?.toJson(),
    };
  }
}

class Absents {
  int? hadir;
  int? izin;
  int? sakit;
  int? alpha;
  int? total;

  Absents({
    this.hadir,
    this.izin,
    this.sakit,
    this.alpha,
    this.total,
  });

  factory Absents.fromJson(Map<String, dynamic> json) {
    return Absents(
      hadir: json['hadir'],
      izin: json['izin'],
      sakit: json['sakit'],
      alpha: json['alpha'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hadir': hadir,
      'izin': izin,
      'sakit': sakit,
      'alpha': alpha,
      'total': total,
    };
  }
}
