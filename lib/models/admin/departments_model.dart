class DepartmentsModel {
  List<Department>? department;
  DepartmentsModel({this.department});

  factory DepartmentsModel.fromJson(Map<String, dynamic> json) {
    return DepartmentsModel(
      department: List<Department>.from(
          json['departments'].map((department) => Department.fromJson(department))),
    );
  }
}

class Department {
  int? id;
  String? nama;
  DateTime? createdAt;
  DateTime? updatedAt;

  Department({this.id, this.nama, this.createdAt, this.updatedAt});
  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"] as int?,
        nama: json["nama"] as String?,
        createdAt: DateTime.parse(json["created_at"]) as DateTime?,
        updatedAt: DateTime.parse(json["updated_at"]) as DateTime?,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
