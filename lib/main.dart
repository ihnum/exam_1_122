import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'model/app_user.dart';
import 'screen/auth_gate.dart';
import 'screen/display.dart';
import 'screen/formscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(49, 152, 43, 1)),
      ),
      home: const AuthGate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user});
  final String title;
  final AppUser user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            Formscreen(user: widget.user),
            DisplayScreen(user: widget.user),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 49, 224, 157),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: 'บันทึก'),
            Tab(text: 'แสดง'),
          ],
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          labelColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
