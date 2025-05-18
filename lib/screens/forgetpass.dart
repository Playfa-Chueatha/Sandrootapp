import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/screens/Login.dart';


class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  List<Map<String, dynamic>> users = [];
  String filePath = '';
  bool _isObscurd = true;
  bool _isObscurd2 = true;

  @override
  void initState() {
    super.initState();
    loadUsersFromJsonFile();
  }

  Future<void> loadUsersFromJsonFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/user_data.json');
    filePath = file.path;

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString);
      setState(() {
        users = (jsonData is List)
            ? jsonData.cast<Map<String, dynamic>>()
            : [jsonData];
      });
    } else {
      setState(() => users = []);
    }
  }

  Future<bool> updateUserPassword(String email, String username, String newPassword) async {
    bool found = false;

    for (var user in users) {
      if (user['email'] == email && user['username'] == username) {
        user['password'] = newPassword;
        found = true;
        break;
      }
    }

    if (found) {
      final file = File(filePath);
      await file.writeAsString(json.encode(users));
      return true;
    } else {
      return false;
    }
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final username = usernameController.text.trim();
      final newPassword = newPasswordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("รหัสผ่านไม่ตรงกัน"),
            backgroundColor: Color(0xFFE97451).withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      bool success = await updateUserPassword(email, username, newPassword);

      if (success) {
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("เปลี่ยนรหัสผ่านสำเร็จ"),
              backgroundColor: Color(0xFF708238).withOpacity(0.7),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainlogin()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ไม่พบผู้ใช้หรือข้อมูลไม่ตรงกัน"),
            backgroundColor: Color(0xFFE97451).withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Color(0xFFf6f3ec),
    appBar: AppBar(
      backgroundColor: Color(0xFFf6f3ec),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Stack(
      children: [

      Align(
        alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/images/22.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
      ),
 
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              

              Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 30),
                )
              ),
              SizedBox(height: 30),

              // อีเมล
              Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFF0E3C6).withOpacity(0.5), 
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'อีเมล',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกอีเมล';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'รูปแบบอีเมลไม่ถูกต้อง';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),

              // ชื่อผู้ใช้
              Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFF0E3C6).withOpacity(0.5), 
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ชื่อผู้ใช้',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                    hintStyle: TextStyle(fontSize: 16),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณากรอกชื่อผู้ใช้' : null,
                ),
              ),
              SizedBox(height: 16),

              // รหัสผ่านใหม่
              Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFF0E3C6).withOpacity(0.5), 
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: newPasswordController,
                  obscureText: _isObscurd,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'รหัสผ่านใหม่',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd ? Icons.visibility_off : Icons.visibility),color: Color(0xFF3E2C1C),
                      onPressed: () {
                        setState(() {
                          _isObscurd = !_isObscurd;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่านใหม่';
                    }
                    if (value.length < 6) {
                      return 'รหัสผ่านควรมีอย่างน้อย 6 ตัวอักษร';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),

              // ยืนยันรหัสผ่านใหม่
              Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFF0E3C6).withOpacity(0.5),               
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isObscurd2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ยืนยันรหัสผ่านใหม่',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd2 ? Icons.visibility_off : Icons.visibility),color: Color(0xFF3E2C1C),
                      onPressed: () {
                        setState(() {
                          _isObscurd2 = !_isObscurd2;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณายืนยันรหัสผ่านใหม่';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: Color(0xFF7A8A3A).withOpacity(0.6), 
                  elevation: 10,
                  shadowColor: Colors.black45, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
                child: Text('เปลี่ยนรหัสผ่าน'),
              ),
              
              

            ],
          ),
        ),
      )])
    );
  }
}