import 'package:flutter/material.dart';
import 'package:registra/main.dart';
import 'package:registra/login%20and%20register/registerPage.dart';
import 'package:registra/services/auth_services.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();


  void handleAuth() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    if(email.isEmpty || pass.isEmpty){
      errorNote("missing email");
    }else{
      String? error;
      error = await auth.signIn(email,pass);
    if (!mounted) return;
    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      errorNote(error);
    }}
    
  }
  void errorNote(String error){
     if (error.contains('invalid_credentials')) {
   toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("Invalid credentials"),
        description: Text("Invalid email or password"),
      );
  }
  else if(error.contains("missing email")){
     toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.warning,
        title: Text("Missing Credentials"),
        description: Text("Please enter all required fields"),
      );
  }
  else if(error.contains("request_timeout")){
     toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("Request timeout"),
        description: Text("Request took too long, please try again later"),
      );
  }
  else if(error.contains("errno = 11001")){
    toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("No internet connection"),
        description: Text("Cannot access internet"),
      );
  }else{
    toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("Something went wrong"),
        description: Text(error),
      );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F0),
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff9CD5FF),
            Color(0xffF7F8F0)
          ],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomRight)
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2),
              Center(
                  child: SizedBox(
                    height: 150,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
              ),
              SizedBox(
                  child: Text(
                    "Your Expense Management made easy",
                    style: style(),
                  ),
                ),
              SizedBox(height: 25),
              SizedBox(
                width: 270,
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
                  
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: Color(0xFF355782),
                    foregroundColor: Color(0xFFF7F8F0),
                  ),
                  child: Text("Login", style: stly(clr: Color(0xFFF7F8F0))),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (_)=> RegisterScreen())
                  );
                },
                child: Text("Create account", style: stly(size: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
