import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spin_better/selected_page.dart';
import 'package:spin_better/views/main_screen.dart';
import 'models/jwt_token_receiver.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light
    )
  );
  runApp(
      ChangeNotifierProvider(
    create: (_) => SelectedPage(),
    child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  static JwtTokenReceiver jwtToken = JwtTokenReceiver();
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainScreen()
    );
  }
}