import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/main.dart';
import 'package:registra/login%20and%20register/otp_screen.dart';
import 'package:registra/login%20and%20register/profile.dart';
import 'package:registra/login%20and%20register/registerPage.dart';
import 'package:registra/services/auth_services.dart';
import 'package:registra/services/profile_service.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  final bool passwordResetSuccess;
  const LoginScreen({super.key, this.passwordResetSuccess = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPassEmail = TextEditingController();
  final auth = AuthService();
  final profservice = ProfileService();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.passwordResetSuccess) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text("Password updated successfully"),
        );
      }
    });
  }

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
        final exists = await profservice.profileExists();
        if (exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainPage()),
          );
        } else {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
        );
        }
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
        showProgressBar: true,
        type: ToastificationType.error,
        title: Text("Invalid credentials"),
        description: Text("Invalid email or password"),
      );
    } else if (error.contains("Unable to validate email")) {
      toastification.show(
        context: context,
        title: Text("Invalid email format"),
        showProgressBar: true,
        description: Text("Please enter a valid email address"),
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
        backgroundColor: Color(0xFFF7F8F0),
        foregroundColor: Color(0xFF355782),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else if (error.contains("missing email")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        showProgressBar: true,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.warning,
        title: Text("Missing Credentials"),
        description: Text("Please enter all required fields"),
      );
    } else if (error.contains("request_timeout")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        showProgressBar: true,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("Request timeout"),
        description: Text("Request took too long, please try again later"),
      );
    } else if (error.contains("errno = 11001")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        showProgressBar: true,
        foregroundColor: Color(0xFF355782),
        type: ToastificationType.error,
        title: Text("No internet connection"),
        description: Text("Cannot access internet"),
      );
    } else if (error.contains("email rate limit exceeded")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        showProgressBar: true,
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
        title: Text("Email rate limit exceeded"),
        description: Text("please try again later"),
      );
    } else if (error.contains("over_email_send_rate_limit")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        style: ToastificationStyle.minimal,
        showProgressBar: true,
        type: ToastificationType.warning,
        title: Text("Cannot resend otp immediately"),
        description: Text("Please try after some time"),
      );
    } else if (error.contains("email_not_confirmed")) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool isLoading = false;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text("Your email is not verified"),
                content: Text(
                  "would you like to proceed with the email verification process",
                  softWrap: true,
                  style: style(),
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final email = emailController.text.trim();
                            final pass = passwordController.text;

                            setDialogState(() {
                              isLoading = true;
                            });

                            final e = await auth.signUp(email, pass);

                            if (!mounted) return;
                            if (!dialogContext.mounted) return;

                            if (e != null) {
                              setDialogState(() {
                                isLoading = false;
                              });

                              errorNote(e);
                            } else {
                              Navigator.of(dialogContext).pop();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpScreen(email, pass),
                                ),
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text("Yes", style: style()),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(dialogContext).pop();
                          },
                    child: Text("No", style: style()),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        showProgressBar: true,
        type: ToastificationType.error,
        title: Text("Something went wrong"),
        description: Text(error),
      );
      print(error);
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
                    hint: Text(
                      "Email",
                      style: style(),
                      textAlign: TextAlign.center,
                    ),
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
                    hint: Text(
                      "Password",
                      style: style(),
                      textAlign: TextAlign.center,
                    ),
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
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    builder: (BuildContext sheetContext) {
                      bool isLoading = false;

                      return StatefulBuilder(
                        builder: (context, setSheetState) {
                          return SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xfff7f8f0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),

                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    "Forgot Password?",
                                    style: style(
                                      ft: FontWeight.w700,
                                      clr: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      "Pleases enter your registered email to proceed with password reset procedure",
                                      softWrap: true,
                                      style: style(size: 14, clr: Colors.black),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextField(
                                      controller: resetPassEmail,
                                      decoration: InputDecoration(
                                        hint: Text(
                                          "Email",
                                          style: style(clr: Colors.black),
                                        ),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff355872),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              final email = resetPassEmail.text
                                                  .trim();

                                              if (email.isEmpty) {
                                                errorNote("missing email");
                                                return;
                                              }
                                              setSheetState(() {
                                                isLoading = true;
                                              });
                                              final e = await auth
                                                  .resetPassword(email);

                                              if (!mounted) return;

                                              if (!sheetContext.mounted) return;
                                              if (e != null) {
                                                setSheetState(() {
                                                  isLoading = false;
                                                });
                                                errorNote(e);
                                              } else {
                                                Navigator.of(
                                                  sheetContext,
                                                ).pop();
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (dialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Email sent",
                                                        style: style(
                                                          ft: FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        "Password reset email is sent to your provided email address, please check your inbox",
                                                        softWrap: true,
                                                        style: style(),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              dialogContext,
                                                            ).pop();
                                                          },
                                                          child: Text(
                                                            "Ok",
                                                            style: style(),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xff355782,
                                        ),
                                        foregroundColor: const Color(
                                          0xFFF7F8F0,
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFFF7F8F0),
                                              ),
                                            )
                                          : const Text("Proceed"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(12),
                                ),
                              ),
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
