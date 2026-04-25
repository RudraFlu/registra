import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/main.dart';
import 'package:registra/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  bool isLogin = true;

  void handleAuth()async{
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    String? error;
    if(isLogin){
      error = await auth.signIn(email, pass);
    }else{
    error = await auth.signUp(email, pass);  
    }
  if(!mounted)return;

  if(error == null){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
  }
  else{
    toastification.show(
      alignment: Alignment.bottomCenter,
      autoCloseDuration: Duration(seconds: 3),
      context: context,
      foregroundColor: Color(0xFF355782),
      type: ToastificationType.error,
      title: Text("Failed"),
      description: Text(error)

    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 260,
            child: TextFormField(
              controller: emailController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hint: Text("Email", style: stly()),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid, width: 10),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: passwordController,
              textAlign: TextAlign.center,
              obscureText: true,
              decoration: InputDecoration(
                hint: Text("Password", style: stly()),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid, width: 10),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                handleAuth();
              },
              child: Text(isLogin ? "Login" : "Sign Up", style: stly(clr: Color(0xFFF7F8F0))),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15)
                ),
                padding: EdgeInsets.zero,
                backgroundColor: Color(0xFF355782),
                foregroundColor: Color(0xFFF7F8F0),
              ),
            ),
          ),
          SizedBox(height: 10),
           TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin
                  ? "Create account"
                  : "Already have an account?",style: stly(size: 15),),
            )
        ],
      ),
    );
  }
}
