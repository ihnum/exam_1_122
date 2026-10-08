import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/app_user.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          return const LoginScreen();
        }

        return _ProfileGate(firebaseUser: snapshot.data!);
      },
    );
  }
}

class _ProfileGate extends StatelessWidget {
  const _ProfileGate({required this.firebaseUser});

  final User firebaseUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data();
        if (data == null) {
          return const _AccessError(message: 'ไม่พบข้อมูลผู้ใช้ใน Firestore');
        }

        final user = AppUser.fromMap(firebaseUser.uid, data);
        if (!user.hasKnownRole) {
          return const _AccessError(
            message: 'Role ต้องเป็น Admin หรือ Operator',
          );
        }

        return MyHomePage(title: 'Flutter Demo Home Page', user: user);
      },
    );
  }
}

class _AccessError extends StatelessWidget {
  const _AccessError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('ออกจากระบบ'),
            ),
          ],
        ),
      ),
    );
  }
}
