import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // 登入成功後的處理邏輯
      logger.i('使用者登入成功：${userCredential.user!.uid}');
      // ignore: use_build_context_synchronously
      _showSnackBar(context, '使用者登入成功');
    } catch (e) {
      // 登入失敗的處理邏輯
      logger.e('使用者登入失敗：$e');
      _showSnackBar(context, '使用者登入失敗');
    }
  }

  Future<void> registerWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // 註冊成功後的處理邏輯
      logger.i('使用者註冊成功：${userCredential.user!.uid}');
      // ignore: use_build_context_synchronously
      _showSnackBar(context, '使用者註冊成功');
    } catch (e) {
      // 註冊失敗的處理邏輯
      logger.e('使用者註冊失敗：$e');
      _showSnackBar(context, '使用者註冊失敗');
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
                  registerWithEmailAndPassword(context);
                },
                child: const Text('註冊'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
