import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/screens/Login.dart';

class Myaccount_buyer extends StatefulWidget {
  final UserProfile userDetails;
  const Myaccount_buyer({super.key, required this.userDetails});

  @override
  State<Myaccount_buyer> createState() => _Myaccount_buyerState();
}

class _Myaccount_buyerState extends State<Myaccount_buyer> {
  // File? _imageFile;
  final picker = ImagePicker();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  // Future<void> _pickImage() async {
  //   if (!isEditing) return;

  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  // Future<void> updateUserProfileToJson({
  //   required String email,
  //   required String username,
  //   File? profileImage,
  // }) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/user_data.json');

  //   // ถ้ามีรูปภาพใหม่ ให้ copy ไปไว้ในโฟลเดอร์แอป
  //   String profileImagePath = 'assets/images/default_sandyroot.png';
  //   if (profileImage != null) {
  //     final imageFileName = 'profile_image.png';
  //     final savedImage = await profileImage.copy('${dir.path}/$imageFileName');
  //     profileImagePath = savedImage.path;
  //   }

  //   final updatedData = {
  //     "email": email,
  //     "username": username,
  //     "profileImage": profileImagePath,
  //   };

  //   await file.writeAsString(jsonEncode(updatedData));
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f3ec),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFf6f3ec),
        title: Text(     
            'My account',
            style: GoogleFonts.notoSansThai(
              fontSize: 30
            ),
          ),
      ),
      body: Stack(
        children: [
          Align(
          alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/backgroundSandyRoots.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
        ),
    
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // GestureDetector(
            //   // onTap: _pickImage,
            //   child: Stack(
            //     children: [
            //       CircleAvatar(
            //         radius: 60,
            //         backgroundImage: _imageFile != null
            //             ? FileImage(_imageFile!)
            //             : const AssetImage('assets/images/default_sandyroot.png') as ImageProvider,
            //       ),         
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('ชื่อผู้ใช้'),
              subtitle: Text(widget.userDetails.username),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('ยืนยันการออกจากระบบ'),
                      content: Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      actions: <Widget>[
                        TextButton(
                          child: Text('ยกเลิก',style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); 

                            
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Mainlogin()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('ออกจากระบบ',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('ออกจากระบบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
  
          ],
        ),
      )])
    );
  }
}
