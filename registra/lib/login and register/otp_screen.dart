import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/login and register/registerPage.dart';
import 'package:registra/services/auth_services.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String user;
  final String pass;
  const OtpScreen(this.email, this.user, this.pass,{super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8F0),
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff9CD5FF), Color(0xffF7F8F0)],
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: SizedBox(
                width: 300,
                height: 150,
                child: Image.asset("assets/images/otp.png"),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Text(
                    "an OTP is sent to ${widget.email},",
                    style: style(size: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.edit_rounded),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                "please enter it for verification",
                style: style(size: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              child: Pinput(
                length: 6,
                onCompleted: (pin) => print(pin),
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Color(0xff355782),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xff9CD5FF),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Color(0xfff7f8f0),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xff355782),
                  ),
                ),
                animationCurve: Curves.bounceIn,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              child: Text(
                "Didn't receive code?",
                style: GoogleFonts.poppins(textStyle: style(size: 14)),
              ),
            ),

            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: OutlinedButton(
                onPressed: () {
                  toastification.show(
                    context: context,
                    title: Text('Otp resent!'),
                    description: Text(
                      'New otp sent to your email: ${widget.email}',
                    ),
                    type: ToastificationType.success,
                    backgroundColor: Color(0xFFF7F8F0),
                    foregroundColor: Color(0xFF355782),
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xff355782),
                ),
                child: Text(
                  "Resend",
                  style: GoogleFonts.poppins(textStyle: TextStyle()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
