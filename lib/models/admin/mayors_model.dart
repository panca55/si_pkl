class MayorsModel {
  List<Mayor>? mayor;
  MayorsModel({this.mayor});

  factory MayorsModel.fromJson(Map<String, dynamic> json) {
    return MayorsModel(
      mayor: List<Mayor>.from(
          json['mayors'].map((mayor) => Mayor.fromJson(mayor))),
    );
  }
}

class Mayor {
  int? id;
  int? departmentId;
  String? nama;
  DateTime? createdAt;
  DateTime? updatedAt;
  Department? department;
  Mayor(
      {this.id,
      this.departmentId,
      this.nama,
      this.createdAt,
      this.updatedAt,
      this.department});

  factory Mayor.fromJson(Map<String, dynamic> json) => Mayor(
        id: json["id"] != null ? int.parse(json["id"].toString()) : null,
        departmentId: json["department_id"] != null
            ? int.parse(json["department_id"].toString())
            : null,
        nama: json["nama"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        department: json['department'] != null
            ? Department.fromJson(json['department'])
            : null,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Department {
  int? id;
  String? nama;
  DateTime? createdAt;
  DateTime? updatedAt;

  Department({this.id, this.nama, this.createdAt, this.updatedAt});
  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        nama: json["nama"],
        createdAt: DateTime.parse(json["created_at"]),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
