import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:registra/Homepage/home.dart';
import 'package:registra/avatar/avatar_selection.dart';
import 'package:registra/avatar/profile_avatar.dart';
import 'package:registra/services/avatar_services.dart';
import 'package:registra/services/profile_service.dart';
import 'package:toastification/toastification.dart';
import 'package:registra/avatar/avatar_type.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final displayNameController = TextEditingController();
  final usernameController = TextEditingController();
  final profservice = ProfileService();
  final avaService = AvatarServices();
  bool? available;
  bool isAvailable = false;
  String? selectedAvatar;
  File? selectedImage;
  @override
  initState() {
    super.initState();
    _loadUsername();
    final random = Random();
    selectedAvatar = presetAvatars[random.nextInt(presetAvatars.length)];
  }

  Future<void> _loadUsername() async {
    final username = await profservice.generateAvailableUsername();

    if (!mounted) return;

    setState(() {
      usernameController.text = username;
    });
  }

  @override
  void dispose() {
    displayNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomRight,
            colors: [Color(0xff9cd5ff), Color(0xfff7f8f0)],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {},
                      child: ProfileAvatar(
                        avatarPath: selectedAvatar,
                        imageFile: selectedImage,
                        radius: 70,
                        onTap: () async {
                          final result = await Navigator.push<AvatarType>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AvatarPickerPage(
                                currentAvatar: selectedAvatar,
                                currentImage: selectedImage
                              ),
                            ),
                          );
                          if (result != null || !mounted) {
                            setState(() {
                              if (result?.imageFile != null) {
                                selectedImage = result?.imageFile;
                                selectedAvatar = null;
                              } else {
                                selectedAvatar = result?.presetPath;
                                selectedImage = null;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Create your profile",
                    style: style(ft: FontWeight.w500),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        label: Text(
                          "Display name",
                          style: style(clr: Color(0xff000000)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(16),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: displayNameController,
                    ),
                  ),
                  SizedBox(height: 20),

                  SizedBox(
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              label: Text(
                                "UserID",
                                style: style(clr: Color(0xff000000)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: usernameController,
                            onChanged: (value) async {
                              final avai = await profservice.usernameAvailable(
                                usernameController.text.trim(),
                              );
                              setState(() {
                                available = avai;
                                isAvailable = avai;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            usernameController.text = await profservice
                                .generateAvailableUsername();
                          },
                          icon: Icon(Icons.casino_outlined),
                        ),
                      ],
                    ),
                  ),
                  if (available != null)
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(
                            available! ? Icons.check_circle : Icons.cancel,
                            color: available! ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            available!
                                ? "Username is available"
                                : "Username is already taken",
                            style: TextStyle(
                              color: available! ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),

                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (displayNameController.text.trim().isEmpty) {
                          toastification.show(
                            autoCloseDuration: Duration(seconds: 3),
                            context: context,
                            showProgressBar: true,
                            foregroundColor: Color(0xFF355782),
                            type: ToastificationType.warning,
                            title: Text("Missing Credentials"),
                            description: Text(
                              "Please enter all required fields",
                            ),
                          );
                          return;
                        }

                        if (usernameController.text.trim().isEmpty) {
                          toastification.show(
                            autoCloseDuration: Duration(seconds: 3),
                            context: context,
                            showProgressBar: true,
                            foregroundColor: Color(0xFF355782),
                            type: ToastificationType.warning,
                            title: Text("Missing Credentials"),
                            description: Text(
                              "Please enter all required fields",
                            ),
                          );
                          return;
                        }
                        if (!isAvailable) return;
                        final avatarType =
                            selectedAvatar!.startsWith("presets/")
                            ? "preset"
                            : "uploaded";
                        await profservice.createProfile(
                          displayName: displayNameController.text,
                          username: usernameController.text,
                          avatarType: avatarType,
                          avatarPath: selectedAvatar!,
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff355782),
                        foregroundColor: Color(0xfff7f8f0),
                      ),
                      child: Text(
                        "Continue",
                        style: style(clr: Color(0xfff7f8f0), size: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
