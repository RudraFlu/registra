import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:registra/services/auth_services.dart";
import "package:toastification/toastification.dart";
import "package:registra/login and register/otp_screen.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailcont = TextEditingController();

  final passcont = TextEditingController();

  final cpasscont = TextEditingController();

  final auth = AuthService();
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  Future<void> handleSignup() async {
    final email = emailcont.text.trim();
    final pass = passcont.text;
    if (_formKey.currentState!.validate()) {
      if (cpasscont.text == pass && pass.length >= 6) {
        setState(() {
          isLoading = true;
        });

        final error = await auth.signUp(email, pass);

        if (error != null) {
          showErrors(e: error);
        } else {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OtpScreen(email, pass)),
            );
          }
        }
        if (mounted) {
          setState(() => isLoading = false);
        }
      } else {
        showErrors();
        return;
      }
    } else {
      showErrors();
      return;
    }
  }

  void showErrors({String e = "Something went wrong"}) {
    final email = emailcont.text.trim();
    final pass = passcont.text;
    final cpass = cpasscont.text;
    if (email.isEmpty || pass.isEmpty || cpass.isEmpty) {
      errorNote("All fields must be filled");
    } else if (pass.length < 6) {
      errorNote("Password length must be more than or equal to 6");
    } else if (pass != cpass) {
      errorNote("Password dont match");
    } else if (e.contains("Unable to validate email")) {
      toastification.show(
        context: context,
        title: Text("Invalid email format"),
        description: Text("Please enter a valid email address"),
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
        backgroundColor: Color(0xFFF7F8F0),
        foregroundColor: Color(0xFF355782),
        autoCloseDuration: const Duration(seconds: 3),
      );
    } else if (e.contains("request_timeout")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
        title: Text("Request timeout"),
        description: Text("Request took too long, please try again later"),
      );
    } else if (e.contains("email rate limit exceeded")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
        title: Text("Email rate limit exceeded"),
        description: Text("please try again later"),
      );
    } else if (e.contains("errno = 11001")) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        context: context,
        foregroundColor: Color(0xFF355782),
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
        title: Text("No internet connection"),
        description: Text("Cannot access internet"),
      );
    } else {
      errorNote(e, typ: ToastificationType.error);
    }
  }

  void errorNote(
    String mess, {
    ToastificationType typ = ToastificationType.warning,
  }) {
    toastification.show(
      context: context,
      title: Text(mess),
      style: ToastificationStyle.minimal,
      type: typ,
      backgroundColor: Color(0xFFF7F8F0),
      foregroundColor: Color(0xFF355782),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(context) {
    final wsize = MediaQuery.of(context).size.width * 0.8;
    final hsize = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: Color(0xffF7F8F0),
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff9CD5FF), Color(0xffF7F8F0)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomLeft,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 150,
                    child: Image.asset("assets/images/cret.png"),
                  ),
                ),
                SizedBox(
                  child: Text(
                    "Join us to help you with your expenses",
                    style: style(),
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: wsize,
                  child: Column(
                    children: [
                      Container(
                        width: wsize,
                        height: hsize,
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text("Email", style: style(ft: FontWeight.bold)),
                      ),
                      SizedBox(
                        child: TextFormField(
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
                            hint: Text("Enter your email address"),
                          ),
                          controller: emailcont,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: wsize,
                        height: hsize,
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text(
                          "Password",
                          style: style(ft: FontWeight.bold),
                        ),
                      ),

                      SizedBox(
                        child: TextFormField(
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length >= 6) {
                              return null;
                            }
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
                        child: TextFormField(
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm your password';
                            }
                            return null;
                          },
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
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 40,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Color(0xff355782),))
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: handleSignup,
                              style: ElevatedButton.styleFrom(
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

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an account?",
                    style: style(size: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
