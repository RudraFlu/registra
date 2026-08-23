import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarPath;
  final File? imageFile;
  final double radius;
  final VoidCallback? onTap;
  Future<String?> getImageUrl() async {
  if (avatarPath == null || avatarPath!.isEmpty) return null;

  if (avatarPath!.startsWith("preset")) {
    return Supabase.instance.client.storage
        .from("avatar-presets")
        .getPublicUrl(avatarPath!);
  }

  return await Supabase.instance.client.storage
      .from("avatar-custom")
      .createSignedUrl(avatarPath!, 3600);
}
  const ProfileAvatar({
    super.key,
    this.avatarPath,
    this.imageFile,
    this.radius = 50,
    this.onTap,
  });
  @override
  Widget build(BuildContext context){
    if(imageFile != null){
     return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(imageFile!),
      ),
    );
    }
     if (avatarPath == null || avatarPath!.isEmpty) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
      ),
    );
  } return FutureBuilder<String?>(
    future: getImageUrl(),
    builder: (context, snapshot) {
      return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundImage: snapshot.hasData
              ? NetworkImage(snapshot.data!)
              : null,
          child: !snapshot.hasData
              ? const CircularProgressIndicator(strokeWidth: 2)
              : null,
        ),
      );
    },
  );
  }
}