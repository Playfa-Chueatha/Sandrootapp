import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/data.dart';

class Myaccount_buyer extends StatefulWidget {
  final UserProfile userDetails;
  const Myaccount_buyer({super.key, required this.userDetails});

  @override
  State<Myaccount_buyer> createState() => _Myaccount_buyerState();
}

class _Myaccount_buyerState extends State<Myaccount_buyer> {
  File? _imageFile;
  final picker = ImagePicker();
  late TextEditingController _usernameController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userDetails.username);
  }

  Future<void> _pickImage() async {
    if (!isEditing) return;

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> updateUserProfileToJson({
    required String email,
    required String username,
    File? profileImage,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/user_data.json');

    // ถ้ามีรูปภาพใหม่ ให้ copy ไปไว้ในโฟลเดอร์แอป
    String profileImagePath = 'assets/images/default_sandyroot.png';
    if (profileImage != null) {
      final imageFileName = 'profile_image.png';
      final savedImage = await profileImage.copy('${dir.path}/$imageFileName');
      profileImagePath = savedImage.path;
    }

    final updatedData = {
      "email": email,
      "username": username,
      "profileImage": profileImagePath,
    };

    await file.writeAsString(jsonEncode(updatedData));
  }

  void _saveChanges() async {
    String updatedUsername = _usernameController.text;
    File? updatedImage = _imageFile;

    await updateUserProfileToJson(
      email: widget.userDetails.email,
      username: updatedUsername,
      profileImage: updatedImage,
    );

    setState(() {
      widget.userDetails.username = updatedUsername;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("บันทึกการเปลี่ยนแปลงเรียบร้อยแล้ว")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D5BA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("บัญชีของฉัน"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('assets/images/default_sandyroot.png') as ImageProvider,
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(Icons.edit, color: Colors.green[800]),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: "ชื่อผู้ใช้",
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("อีเมล"),
              subtitle: Text(widget.userDetails.email),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (isEditing) {
                  _saveChanges();
                } else {
                  setState(() {
                    isEditing = true;
                  });
                }
              },
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              label: Text(isEditing ? "บันทึกการเปลี่ยนแปลง" : "แก้ไขข้อมูล"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA8D5BA),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
