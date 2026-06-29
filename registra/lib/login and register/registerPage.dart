import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:toastification/toastification.dart";
import "package:registra/login and register/otp_screen.dart";

TextStyle style({double size = 16, FontWeight ft = FontWeight.normal}) {
  TextStyle styl = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(0xFF355872),
      fontSize: size,
      fontWeight: ft,
    ),
  );

  return styl;
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailcont = TextEditingController();
  final numcont = TextEditingController();

  final passcont = TextEditingController();

  final userncont = TextEditingController();

  final cpasscont = TextEditingController();
  void showErrors() {
    final email = emailcont.text.trim();
    final user = userncont.text;
    final pass = passcont.text;
    final cpass = cpasscont.text;
    if (email.isEmpty || user.isEmpty || pass.isEmpty || cpass.isEmpty) {
      errorNote("All fields must be filled");
    } else if (pass.length < 6) {
      errorNote("Password length must be more than or equal to 6");
    } else if (pass != cpass) {
      errorNote("Password dont match");
    }
  }

  void errorNote(String mess) {
    toastification.show(
      context: context,
      title: Text(mess),
      style: ToastificationStyle.minimal,
      type: ToastificationType.warning,
      backgroundColor: Color(0xFFF7F8F0),
      foregroundColor: Color(0xFF355782),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(context) {
    final wsize = MediaQuery.of(context).size.width * 0.6;
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
                        child: Text(
                          "Full Name",
                          style: style(ft: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff355872)),
                            ),
                            hint: Text("Enter your full name"),
                          ),
                          controller: userncont,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: wsize,
                        height: hsize,
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text("Email", style: style(ft: FontWeight.bold)),
                      ),
                      SizedBox(
                        child: TextFormField(
                          decoration: InputDecoration(
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
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff355872)),
                            ),
                            hint: Text("Enter Password (at least 6)"),
                          ),

                          obscureText: true,
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
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff355872)),
                            ),
                            hint: Text("Enter password again"),
                          ),
                          obscureText: true,
                          controller: cpasscont,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm your password';
                            }
                            return null;
                          },
                          onChanged:(value) {
                            setState(() {
                            });
                          },
                        ),
                      ),
                       Container(
                        alignment: AlignmentGeometry.centerLeft,
                        width: wsize,
                        child: Text(
                                  (passcont.text == cpasscont.text || cpasscont.text.isEmpty) 
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
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailcont.text.trim();
                        final user = userncont.text;
                        final pass = passcont.text;
                        if(cpasscont.text == pass && pass.length >=6){
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtpScreen(email, user, pass),
                          ),
                        );}else{
                          showErrors();
                        }
                        
                      } else {
                        showErrors();
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff355782),
                      foregroundColor: Color(0xFFf7f8f0),
                    ),
                    child: Text(
                      "Next page",
                      style: GoogleFonts.poppins(textStyle: TextStyle()),
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
