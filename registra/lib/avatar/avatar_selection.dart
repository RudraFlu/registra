import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registra/avatar/avatar_type.dart';
import 'package:registra/services/avatar_services.dart';

class AvatarPickerPage extends StatefulWidget {
  String? currentAvatar;
  File? currentImage;
  AvatarPickerPage({super.key, this.currentAvatar, this.currentImage});

  @override
  State<AvatarPickerPage> createState() => _AvatarPickerPageState();
}

TextStyle style({
  double size = 16,
  FontWeight ft = FontWeight.normal,
  Color clr = const Color(0xff355782),
}) {
  TextStyle styl = GoogleFonts.poppins(
    textStyle: TextStyle(color: clr, fontSize: size, fontWeight: ft),
  );

  return styl;
}

class _AvatarPickerPageState extends State<AvatarPickerPage> {
  final service = AvatarServices();
  List<List<String>> avatarpages() {
    List<List<String>> pages = [];
    for (int i = 0; i < presetAvatars.length; i += 6) {
      pages.add(
        presetAvatars.sublist(
          i,
          (i + 6 > presetAvatars.length) ? presetAvatars.length : i + 6,
        ),
      );
    }
    return pages;
  }

  String? selectedAvatar;
  File? selectedImage;
  final PageController pageController = PageController();
  int currentPage = 0;
  late final List<List<String>> pages = avatarpages();
  @override
  void initState() {
    super.initState;
    selectedAvatar = widget.currentAvatar;
    selectedImage = widget.currentImage;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? previewImage;
    if (selectedImage != null) {
      previewImage = FileImage(selectedImage!);
    } else if (selectedAvatar != null) {
       previewImage = NetworkImage(
    supabase.storage
        .from('avatar-presets')
        .getPublicUrl(selectedAvatar!),
  );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Choose Avatar", style: style())),
      ),
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: CircleAvatar(
                radius: 150,
                backgroundImage: previewImage,
                child: previewImage == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    final randomIndex = Random().nextInt(presetAvatars.length);
                    setState(() {
                      selectedAvatar = presetAvatars[randomIndex];
                    });
                    {
                      selectedAvatar = presetAvatars[randomIndex];
                    }
                  },
                  icon: Icon(Icons.casino_outlined),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    final custmAvatar = await service.pickImage();
                    if (custmAvatar == null) return;
                    setState(() {
                      selectedImage = custmAvatar;
                      selectedAvatar = null;
                    });
                  },
                  icon: Icon(Icons.photo_library),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              child: ElevatedButton(
                onPressed: (selectedAvatar == null && selectedImage == null)
                    ? null
                    : () {
                        if (selectedImage != null) {
                          Navigator.pop(
                            context,
                            AvatarType(imageFile: selectedImage),
                          );
                          return;
                        }

                        Navigator.pop(
                          context,
                          AvatarType(presetPath: selectedAvatar),
                        );
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff355782),
                ),
                child: Text(
                  "Select",
                  style: style(clr: Color(0xfff7f8f0), size: 15),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 12 : 8,
                  height: currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? const Color(0xff355782)
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, pageIndex) {
                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: pages[pageIndex].length,
                    itemBuilder: (context, index) {
                      final avatar = pages[pageIndex][index];
                      final imageUrl = supabase.storage
                          .from('avatar-presets')
                          .getPublicUrl(avatar);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatar;
                            selectedImage = null;
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          scale: selectedAvatar == avatar ? 1.08 : 1.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedAvatar == avatar
                                    ? Color(0xff355782)
                                    : Colors.transparent,
                                width: 3,
                              ),

                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
