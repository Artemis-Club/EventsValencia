import 'package:common/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/pages/phones_page.dart';
import 'package:provider/provider.dart';
import 'package:common/constants.dart';

void main() async {
  await dotenv.load();
  runApp(
    ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var watcher = context.watch<AppProvider>();
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: watcher.theme,
        theme: AppTheme.theme,
        darkTheme: ThemeData.dark(),
        home: const PhonesHomePage(title: ''));
  }
}
