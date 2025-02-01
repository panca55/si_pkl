import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:si_pkl/Services/providers.dart';
import 'package:si_pkl/Views/discover_page.dart';
import 'package:si_pkl/Views/guru/bimbingan/bimbingan_detail.dart';
import 'package:si_pkl/Views/pimpinan/siswa_pkl_detail.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  final listProviders = Providers().providers;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => MultiProvider(
          providers: listProviders,
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'SIM PKL',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: '/',
      routes: {
        '/': (context) => const DiscoverPage(),
        SiswaPklDetail.routname: (context) => SiswaPklDetail(
              siswaId: ModalRoute.of(context)?.settings.arguments as int,
            ),
        BimbinganDetail.routname: (context) => BimbinganDetail(
              bimbinganId: ModalRoute.of(context)?.settings.arguments as int,
            ),
      },
    );
  }
}
