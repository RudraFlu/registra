import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/services/auth_services.dart';
import 'package:toastification/toastification.dart';
import 'package:registra/login and register/login.dart';

class ForgPassPage extends StatefulWidget {
  const ForgPassPage({super.key});

  @override
  State<ForgPassPage> createState() => _ForgPassPageState();
}

class _ForgPassPageState extends State<ForgPassPage> {
  final passcont = TextEditingController();
  final cpasscont = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size.width * 0.8;
    final hsize = MediaQuery.of(context).size.height * 0.05;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff9cd5ff),
        foregroundColor: Color(0xff355872),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Color(0xff9CD5FF)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              SizedBox(
                child: Text(
                  "Reset your password",
                  style: style(ft: FontWeight.w500, size: 23),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xfff7f8f0),
                ),
                child: Column(
                  children: [
                    Container(
                      width: wsize,
                      height: hsize,
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "New Password",
                        style: style(ft: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff355872),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff355872)),
                          ),
                          hint: Text("Enter Password (at least 6)"),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                          ),
                        ),
                        obscureText: obscurePassword,
                        controller: passcont,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      alignment: AlignmentGeometry.centerLeft,
                      width: wsize,
                      child: Text(
                        passcont.text.length >= 6
                            ? '✓ Minimum 6 characters'
                            : '${passcont.text.length}/6 characters',
                        style: TextStyle(
                          color: passcont.text.length >= 6
                              ? Colors.green
                              : Color(0xff000000),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: wsize,
                      height: hsize,
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "Confirm Password",
                        style: style(ft: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff355872),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff355872)),
                          ),
                          hint: Text("Enter password again"),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => obscureConfirm = !obscureConfirm,
                            ),
                          ),
                        ),
                        obscureText: obscureConfirm,

                        controller: cpasscont,

                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      alignment: AlignmentGeometry.centerLeft,
                      width: wsize,
                      child: Text(
                        (passcont.text == cpasscont.text ||
                                cpasscont.text.isEmpty)
                            ? ""
                            : 'Passwords don\'t match',
                        style: TextStyle(
                          color: passcont.text == cpasscont.text
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 50,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff355782),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (passcont.text.length < 6) return;
                                    if (passcont.text != cpasscont.text) return;
                                    setState(() => isLoading = true);

                                    try {
                                      await AuthService().updatePassword(
                                        passcont.text,
                                      );

                                      if (!mounted) return;

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(
                                            passwordResetSuccess: true,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    } catch (e) {
                                      if (!mounted) return;

                                      final error = e.toString();
                                      if (error.contains("request_timeout")) {
                                        toastification.show(
                                          autoCloseDuration: Duration(
                                            seconds: 3,
                                          ),
                                          context: context,
                                          foregroundColor: Color(0xFF355782),
                                          showProgressBar: true,
                                          type: ToastificationType.error,
                                          title: Text("Request timeout"),
                                          description: Text(
                                            "Request took too long, please try again later",
                                          ),
                                        );
                                      } else if (error.contains(
                                        "errno = 11001",
                                      )) {
                                        toastification.show(
                                          autoCloseDuration: Duration(
                                            seconds: 3,
                                          ),
                                          context: context,
                                          foregroundColor: Color(0xFF355782),
                                          showProgressBar: true,
                                          type: ToastificationType.error,
                                          title: Text("No internet connection"),
                                          description: Text(
                                            "Cannot access internet",
                                          ),
                                        );
                                      } else if (error.contains(
                                        "over_email_send_rate_limit",
                                      )) {
                                        toastification.show(
                                          autoCloseDuration: Duration(
                                            seconds: 3,
                                          ),
                                          context: context,
                                          foregroundColor: Color(0xFF355782),
                                          showProgressBar: true,
                                          style: ToastificationStyle.minimal,
                                          type: ToastificationType.warning,
                                          title: Text(
                                            "Cannot resend otp immediately",
                                          ),
                                          description: Text(
                                            "Please try after some time",
                                          ),
                                        );
                                      } else if (error.contains(
                                        "email rate limit exceeded",
                                      )) {
                                        toastification.show(
                                          autoCloseDuration: Duration(
                                            seconds: 3,
                                          ),
                                          context: context,
                                          foregroundColor: Color(0xFF355782),
                                          showProgressBar: true,
                                          style: ToastificationStyle.minimal,
                                          type: ToastificationType.error,
                                          title: Text(
                                            "Email rate limit exceeded",
                                          ),
                                          description: Text(
                                            "please try again later",
                                          ),
                                        );
                                      } else {
                                        toastification.show(
                                          context: context,
                                          description: Text(error.toString()),
                                          showProgressBar: true,
                                          type: ToastificationType.error,
                                          backgroundColor: Color(0xFFF7F8F0),
                                          foregroundColor: Color(0xFF355782),
                                          autoCloseDuration: const Duration(
                                            seconds: 3,
                                          ),
                                        );
                                      }

                                      print(e);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(12),
                                    ),
                                    backgroundColor: const Color(0xff355782),
                                    foregroundColor: const Color(0xFFF7F8F0),
                                  ),
                                  child: Text(
                                    "Continue",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
