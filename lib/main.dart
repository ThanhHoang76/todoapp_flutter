import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp_flutter/db/db_helper.dart';
import 'package:todoapp_flutter/ui/home_screen.dart';
import 'package:todoapp_flutter/ultis/themes.dart';
import 'package:get/get.dart';
import 'services/theme_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().database;
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeService().theme,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: const HomePage(),
      //initialRoute: RouterHelper.getInitial(),
      //getPages: RouterHelper.Router,
    );
  }
}
