import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:si_pkl/controller/auth_controller.dart';
import 'package:si_pkl/provider/admin/absents_provider.dart';
import 'package:si_pkl/provider/admin/corporations_provider.dart';
import 'package:si_pkl/provider/admin/departments_provider.dart';
import 'package:si_pkl/provider/admin/evaluations_provider.dart';
import 'package:si_pkl/provider/admin/informations_provider.dart';
import 'package:si_pkl/provider/admin/instructors_provider.dart';
import 'package:si_pkl/provider/admin/internships_provider.dart';
import 'package:si_pkl/provider/admin/mayors_provider.dart';
import 'package:si_pkl/provider/admin/students_provider.dart';
import 'package:si_pkl/provider/admin/teachers_provider.dart';
import 'package:si_pkl/provider/admin/users_provider.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_detail_provider.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_provider.dart';
import 'package:si_pkl/provider/guru/assessment/assessment_show_provider.dart';
import 'package:si_pkl/provider/guru/bimbingan_index_provider.dart';
import 'package:si_pkl/provider/guru/bimbingan_siswa_provider.dart';
import 'package:si_pkl/provider/guru/detail_logbook_provider.dart';
import 'package:si_pkl/provider/guru/profile_guru_provider.dart';
import 'package:si_pkl/provider/instruktur/bimbingan_instruktur_index_provider.dart';
import 'package:si_pkl/provider/instruktur/bimbingan_instruktur_provider.dart';
import 'package:si_pkl/provider/instruktur/detail_logbook_instruktur_provider.dart';
import 'package:si_pkl/provider/instruktur/profile_instruktur_provider.dart';
import 'package:si_pkl/provider/instruktur/sertifikat/sertifikat_detail_provider.dart';
import 'package:si_pkl/provider/instruktur/sertifikat/sertifikat_provider.dart';
import 'package:si_pkl/provider/perusahaan/bursa_kerja_provider.dart';
import 'package:si_pkl/provider/perusahaan/dashboard_provider.dart';
import 'package:si_pkl/provider/perusahaan/profile_perusahaan_provider.dart';
import 'package:si_pkl/provider/perusahaan/siswa_pkl_provider.dart';
import 'package:si_pkl/provider/pimpinan/siswa_provider.dart';
import 'package:si_pkl/provider/siswa/evaluation_provider.dart';
import 'package:si_pkl/provider/siswa/intern_provider.dart';
import 'package:si_pkl/provider/siswa/profile_provider.dart';
import 'package:si_pkl/provider/user_provider.dart';
import 'package:si_pkl/provider/guru/evaluation_guru_provider.dart';

class Providers{
  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
    ChangeNotifierProvider(
      create: (context) =>
          ProfileProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          InternProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          SiswaProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          UserProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          EvaluationProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          ProfileGuruProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) => BimbinganSiswaProvider(
          authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) => BimbinganIndexProvider(
          authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          DetailLogbookProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          AssessmentProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          AssessmentShowProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          AssessmentDetailProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          EvaluationGuruProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          ProfileInstrukturProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          BimbinganInstrukturProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          BimbinganInstrukturIndexProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          DetailLogbookInstrukturProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          SertifikatProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          SertifikatDetailProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          DashboardProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          ProfilePerusahaanProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          BursaKerjaProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          SiswaPklProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          CorporationsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          DepartmentsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          EvaluationsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          InformationsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          InformationsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          InstructorsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          InternshipsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          MayorsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          StudentsProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          TeachersProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          UsersProvider(authController: context.read<AuthController>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          AbsentsProvider(authController: context.read<AuthController>()),
    ),
  ];
}