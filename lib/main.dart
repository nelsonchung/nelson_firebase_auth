import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: '使用者登入',
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Logger logger = Logger();

  LoginPage({Key? key}) : super(key: key);

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // 登入成功後的處理邏輯
      logger.i('使用者登入成功：${userCredential.user!.uid}');
    } catch (e) {
      // 登入失敗的處理邏輯
      logger.e('使用者登入失敗：$e');
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      // 寄送驗證郵件後的處理邏輯
      logger.i('已寄送驗證郵件至使用者的信箱');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue,
                Color.fromARGB(255, 2, 50, 90),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(
                size: 100.0,
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: '使用者名稱',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: '密碼',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  signInWithEmailAndPassword(context);
                },
                child: const Text('登入'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  sendEmailVerification(context);
                },
                child: const Text('寄送驗證郵件'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
