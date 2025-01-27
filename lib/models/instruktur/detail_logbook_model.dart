class DetailLogbookModel{
  Logbook? logbook;
  NoteGuru? noteGuru;
  NoteInstruktur? noteInstruktur;
  Grades? grades;
  DetailLogbookModel({this.logbook, this.noteGuru, this.noteInstruktur, this.grades});
  factory DetailLogbookModel.fromJson(Map<String, dynamic> json) {
    return DetailLogbookModel(
      logbook: json['logbook'] != null
          ? Logbook.fromJson(json['logbook'])
          : null,
      noteGuru: json['noteGuru'] != null
          ? NoteGuru.fromJson(json['noteGuru'])
          : null,
      noteInstruktur: json['noteInstruktur'] != null
          ? NoteInstruktur.fromJson(json['noteInstruktur'])
          : null,
      grades: json['grades'] != null
          ? Grades.fromJson(json['grades'])
          : null,
    );
  }
}
class Logbook {
  int? id;
  int? internshipId;
  String? category;
  String? tanggal;
  String? judul;
  String? bentukKegiatan;
  String? penugasanPekerjaan;
  String? mulai;
  String? selesai;
  String? petugas;
  String? isi;
  String? fotoKegiatan;
  String? keterangan;
  String? createdAt;
  String? updatedAt;
  List<Note>? note;

  Logbook({
    this.id,
    this.internshipId,
    this.category,
    this.tanggal,
    this.judul,
    this.bentukKegiatan,
    this.penugasanPekerjaan,
    this.mulai,
    this.selesai,
    this.petugas,
    this.isi,
    this.fotoKegiatan,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
    this.note,
  });

  factory Logbook.fromJson(Map<String, dynamic> json) {
    return Logbook(
      id: json['id'],
      internshipId: json['internship_id'],
      category: json['category'],
      tanggal: json['tanggal'],
      judul: json['judul'],
      bentukKegiatan: json['bentuk_kegiatan'],
      penugasanPekerjaan: json['penugasan_pekerjaan'],
      mulai: json['mulai'],
      selesai: json['selesai'],
      petugas: json['petugas'],
      isi: json['isi'],
      fotoKegiatan: json['foto_kegiatan'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      note: json['note'] != null
          ? List<Note>.from(json['note'].map((item) => Note.fromJson(item)))
          : [],
    );
  }
}

class Note {
  int? id;
  int? logbookId;
  String? noteType;
  String? catatan;
  String? penilaian;
  String? createdAt;
  String? updatedAt;
  Note({this.id, this.logbookId, this.noteType, this.catatan, this.penilaian, this.createdAt, this.updatedAt});

  factory Note.fromJson(Map<String, dynamic> json) {
    // Parsing properti note
    return Note(
      id: json['id'],
      logbookId: json['logbook_id'],
      noteType: json['note_type'],
      catatan: json['catatan'],
      penilaian: json['penilaian'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
class NoteGuru {
  String? catatan;
  String? penilaian;
  NoteGuru({this.catatan, this.penilaian});
  factory NoteGuru.fromJson(Map<String, dynamic> json) {
    return NoteGuru(
      catatan: json['catatan'],
      penilaian: json['penilaian'],
    );
  }
}
class NoteInstruktur {
  String? catatan;
  String? penilaian;
  NoteInstruktur({this.catatan, this.penilaian});
  factory NoteInstruktur.fromJson(Map<String, dynamic> json) {
    return NoteInstruktur(
      catatan: json['catatan'],
      penilaian: json['penilaian'],
    );
  }
}
class Grades {
  String? sudahBagus;
  String? perbaiki;
  Grades({this.perbaiki, this.sudahBagus});
  factory Grades.fromJson(Map<String, dynamic> json) {
    return Grades(
      sudahBagus: json['SUDAH BAGUS'],
      perbaiki: json['PERBAIKI'],
    );
  }
}

