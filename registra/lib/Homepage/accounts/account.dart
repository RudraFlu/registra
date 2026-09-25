import 'package:flutter/material.dart';
import 'package:registra/Homepage/accounts/change_email.dart';
import 'package:registra/avatar/profile_avatar.dart';
import 'package:registra/login%20and%20register/login.dart';
import 'package:registra/services/auth_services.dart';
import 'package:registra/services/profile_service.dart';
import 'package:toastification/toastification.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  Map<String, dynamic>? data;
  String? email;
  String? avatarPath;
  final ProfileService profService = ProfileService();
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await profService.getProfile();

      if (!mounted) return;

      setState(() {
        data = profile;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color(0xff355872),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: ProfileAvatar(
                      avatarPath: data?['avatar_path'],
                      radius: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const SizedBox(height: 15),

                Text(
                  data?['display_name'] ?? 'Loading...',
                  style: style(size: 22, ft: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  '@${data?['username'] ?? 'username'}',
                  style: style(size: 15, clr: Colors.grey.shade600),
                ),

                const SizedBox(height: 6),

                Text(
                  data?['email'] ?? 'Loading...',
                  style: style(size: 14, clr: Colors.grey.shade600),
                ),

                const SizedBox(height: 25),

                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text("Change Email"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeEmailPage(currentEmail: data?['email'] ?? ''),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final shouldContinue = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text(
                            "Change Password?",
                            style: style(ft: FontWeight.bold),
                          ),
                          content: Text(
                            "A password reset link will be sent to your registered email.",
                            style: style(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, false);
                              },
                              child: Text("Cancel", style: style()),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, true);
                              },
                              child: Text("Continue", style: style()),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldContinue != true) return;

                    final auth = AuthService();

                    final error = await auth.resetPassword(
                      data?['email'] ?? '',
                    );

                    if (!mounted) return;

                    if (error != null) {
                      toastification.show(
                        context: context,
                        title: const Text("Something went wrong"),
                        description: Text(error),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );

                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text(
                            "Email Sent",
                            style: style(ft: FontWeight.bold),
                          ),
                          content: Text(
                            "We've sent a password reset link to your email. "
                            "Please check your inbox to continue.",
                            style: style(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Text("OK", style: style()),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Log Out",
                      style: style(ft: FontWeight.w500, clr: Colors.black),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(
                              "Log Out?",
                              style: style(ft: FontWeight.bold),
                            ),
                            content: Text(
                              "Are you sure you want to log out of your Registra account?",
                              style: style(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                },
                                child: Text("Cancel", style: style()),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff355782),
                                  foregroundColor: const Color(0xFFF7F8F0),
                                ),
                                child: const Text("Log Out"),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldLogout != true) return;

                      try {
                        await AuthService().signOut();

                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      } catch (e) {
                        if (!mounted) return;

                        toastification.show(
                          context: context,
                          title: const Text("Logout failed"),
                          description: const Text(
                            "Something went wrong. Please try again.",
                          ),
                          type: ToastificationType.error,
                          backgroundColor: const Color(0xFFF7F8F0),
                          foregroundColor: const Color(0xff355782),
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                      }
                    },
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
