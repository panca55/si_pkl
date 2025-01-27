class BursaKerjaModel {
  List<Job>? jobs;

  BursaKerjaModel({this.jobs});

  factory BursaKerjaModel.fromJson(Map<String, dynamic> json) {
    return BursaKerjaModel(
      jobs: List<Job>.from(json['jobs'].map((job) => Job.fromJson(job))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobs': jobs?.map((job) => job.toJson()).toList(),
    };
  }
}

class Job {
  int? id;
  int? corporationId;
  String? judul;
  String? slug;
  String? deskripsi;
  String? persyaratan;
  String? jenisPekerjaan;
  String? lokasi;
  String? rentangGaji;
  String? batasPengiriman;
  String? contactEmail;
  String? foto;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Job({
    this.id,
    this.corporationId,
    this.judul,
    this.slug,
    this.deskripsi,
    this.persyaratan,
    this.jenisPekerjaan,
    this.lokasi,
    this.rentangGaji,
    this.batasPengiriman,
    this.contactEmail,
    this.foto,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      corporationId: json['corporation_id'],
      judul: json['judul'],
      slug: json['slug'],
      deskripsi: json['deskripsi'],
      persyaratan: json['persyaratan'],
      jenisPekerjaan: json['jenis_pekerjaan'],
      lokasi: json['lokasi'],
      rentangGaji: json['rentang_gaji'],
      batasPengiriman: json['batas_pengiriman'],
      contactEmail: json['contact_email'],
      foto: json['foto'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'corporation_id': corporationId,
      'judul': judul,
      'slug': slug,
      'deskripsi': deskripsi,
      'persyaratan': persyaratan,
      'jenis_pekerjaan': jenisPekerjaan,
      'lokasi': lokasi,
      'rentang_gaji': rentangGaji,
      'batas_pengiriman': batasPengiriman,
      'contact_email': contactEmail,
      'foto': foto,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
