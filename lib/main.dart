import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/views/theme.dart';
import 'views/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper.initDb();
  makeStatusBarTransparent();
  runApp(const MyApp());
}

void makeStatusBarTransparent() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
