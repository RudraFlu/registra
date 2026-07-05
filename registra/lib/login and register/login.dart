import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/login%20and%20register/otp_screen.dart';
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

  bool isLoading = false;

  void handleAuth() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    if (email.isEmpty || pass.isEmpty) {
      errorNote("missing email");
    } else {
      setState(() {
        isLoading = true;
      });
      String? error;
      error = await auth.signIn(email, pass);
      if (!mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (error == null) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        errorNote(error);
      }
    }
  }

  void errorNote(String error) {
    if (error.contains('invalid_credentials')) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("Invalid credentials"),
        description: Text("Invalid email or password"),
      );
    } else if (error.contains("missing email")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.warning,
        title: Text("Missing Credentials"),
        description: Text("Please enter all required fields"),
      );
    } else if (error.contains("request_timeout")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("Request timeout"),
        description: Text("Request took too long, please try again later"),
      );
    } else if (error.contains("errno = 11001")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("No internet connection"),
        description: Text("Cannot access internet"),
      );
    } else if (error.contains("email_not_confirmed")) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Your email is not verified"),
          content: Text(
            "would you like to proceed with the email verification process",
            softWrap: true,
            style: style(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpScreen(
                      emailController.text.trim(),
                      passwordController.text,
                    ),
                  ),
                );
              },
              child: Text("Yes", style: style()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No", style: style()),
            ),
          ],
        ),
      );
    } else {
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
          gradient: LinearGradient(
            colors: [Color(0xff9CD5FF), Color(0xffF7F8F0)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
                    hint: Text("Email", style: style(),textAlign: TextAlign.center),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 10,
                      ),
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
                    hint: Text("Password", style: style(),textAlign: TextAlign.center,),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 10,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                },
                child: Text("Forgot password?", style: style(size: 14)),
              ),
              SizedBox(height: 10),
              SizedBox(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff355782),
                          ),
                        )
                      : SizedBox(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff355782),
                              foregroundColor: const Color(0xFFF7F8F0),
                            ),
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: Text("Create account", style: style(size: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
