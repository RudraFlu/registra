import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarPath;
  final File? imageFile;
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.avatarPath,
    this.imageFile,
    this.radius = 50,
    this.onTap,
  });
  @override
  Widget build(BuildContext context){
    ImageProvider? image;
    if(imageFile != null){
      image = FileImage(imageFile!);
    }
    else if (avatarPath != null && avatarPath!.isNotEmpty){
      final url = Supabase.instance.client.storage
          .from('avatar')
          .getPublicUrl(avatarPath!);

      image = NetworkImage(url);
    }
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: image,
        child: image == null
            ? Icon(
                Icons.person,
                size: radius,
              )
            : null,
      ),
    );
  }
}