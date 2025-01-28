class BaseApi{
  static var base =  "http://127.0.0.1:8000";
  static var api = "$base/api";
  var authPath = Uri.parse("$api/login");
  var registerPath = Uri.parse("$api/register");
  var logoutPath = Uri.parse("$api/logout");
  var profileSiswaPath = Uri.parse("$api/profil/siswa");
  var siswaPath = Uri.parse("$api/siswa");
  var internPath = Uri.parse("$api/intern");
  var logbookPostPath = Uri.parse("$api/intern/logbook");
  var siswaPimpinanPath = Uri.parse("$api/pimpinan/siswa");
  var siswaEvaluationPath = Uri.parse("$api/evaluation/index");
  var guruProfilePath = Uri.parse("$api/teacher/dashboard");
  var perusahaanProfilePath = Uri.parse("$api/corporate/profile");
  var instrukturProfilePath = Uri.parse("$api/instruktur/profile");
  var bimbinganPath = Uri.parse("$api/teacher/bimbingan");
  var bimbinganInstrukturPath = Uri.parse("$api/instruktur/bimbingan");
  var dashboardPerusahaanPath = Uri.parse("$api/corporate/dashboard");
  var bursaKerjaPath = Uri.parse("$api/bursa");
  var postSertifikatPath = Uri.parse("$api/sertifikat");
  var postKomentarPath = Uri.parse("$api/teacher/bimbingan");
  var postKomentarInstrukturPath = Uri.parse("$api/instruktur/bimbingan");
  var postSubmitInstrukturPath = Uri.parse("$api/corporate/dashboard");
  var addMayorPath = Uri.parse("$api/mayor");
  var addUserPath = Uri.parse("$api/users");
  var addInfoPath = Uri.parse("$api/info");
  var addDepartmentPath = Uri.parse("$api/department");
  var addTeacherPath = Uri.parse("$api/teacher");
  var addInstrukturPath = Uri.parse("$api/instruktur");
  var addCorporatePath = Uri.parse("$api/korporat");
  var toggleActivePath = Uri.parse("$api/user/active");
  var assessmentPath = Uri.parse("$api/assessment");
  var evaluationPath = Uri.parse("$api/teacher/evaluation");
  var sertifikatPath = Uri.parse("$api/sertifikat");
  var siswaPklPath = Uri.parse("$api/corporate/siswa");
  var departmentsPath = Uri.parse("$api/department");
  var corporationsPath = Uri.parse("$api/korporat");
  var evaluationsPath = Uri.parse("$api/admin/evaluation");
  var informationsPath = Uri.parse("$api/info");
  var internshipsPath = Uri.parse("$api/admin/intern");
  var instructorsPath = Uri.parse("$api/instruktur");
  var mayorsPath = Uri.parse("$api/mayor");
  var studentsPath = Uri.parse("$api/student");
  var teachersPath = Uri.parse("$api/teacher");
  var usersPath = Uri.parse("$api/users");
  var absentsPath = Uri.parse("$api/admin/intern/absen");
  static int? id;

  Uri siswaIndexPath(int? id) => Uri.parse("$api/pimpinan/siswa/$id");
  Uri bimbinganIndexPath(int? id) => Uri.parse("$api/teacher/bimbingan/$id");
  Uri bimbinganInstrukturIndexPath(int? id) => Uri.parse("$api/instruktur/bimbingan/$id");
  Uri detailLogbookGuruPath(int? id) => Uri.parse("$api/teacher/bimbingan/logbook/$id");
  Uri detailLogbookInstrukturPath(int? id) => Uri.parse("$api/instruktur/bimbingan/logbook/$id");
  Uri editKomentarGuruPath(int? id) => Uri.parse("$api/teacher/bimbingan/update/$id");
  Uri editKomentarInstrukturPath(int? id) => Uri.parse("$api/instruktur/bimbingan/update/$id");
  Uri postAssessmentPath(int? id) => Uri.parse("$api/assessment?internship_id=$id");
  Uri assessmentShowPath(int? id) => Uri.parse("$api/assessment/$id");
  Uri assessmentDetailPath(int? id) => Uri.parse("$api/assessment/detail/$id");
  Uri printAssessmentPath(int? id) => Uri.parse("$api/assessment/print/$id");
  Uri printEvaluationPath(int? id) => Uri.parse("$api/teacher/evaluation/print/$id");
  Uri sertifikatDetailPath(int? id) => Uri.parse("$api/sertifikat/$id");
  Uri printSertifikatPath(int? id) => Uri.parse("$api/sertifikat/print/$id");
  Uri penilaianDetailPath(int? id) => Uri.parse("$api/admin/evaluation/detail/$id");
  Uri penilaianShowPath(int? id) => Uri.parse("$api/admin/evaluation/show/$id");
  var currentUserPath = Uri.parse("$api/user");
  String? token;

  void setToken(String newToken) {
    token = newToken;
  }
  // more routes
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };                            
  
  Map<String, String> getHeaders(String? token) {
    if (token == null) {
      throw Exception("Token is null. Please log in first.");
    }
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }                          
  Map<String, String> getMultipartHeaders(String? token) {
    if (token == null) {
      throw Exception("Token is null. Please log in first.");
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    };
  }                          
}