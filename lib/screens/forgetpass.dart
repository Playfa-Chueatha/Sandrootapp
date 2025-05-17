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
          SnackBar(content: Text("❗ รหัสผ่านไม่ตรงกัน")),
        );
        return;
      }

      bool success = await updateUserPassword(email, username, newPassword);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ เปลี่ยนรหัสผ่านสำเร็จ")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainlogin()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ไม่พบผู้ใช้หรือข้อมูลไม่ตรงกัน")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลืมรหัสผ่าน')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(),
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
                SizedBox(height: 16),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อผู้ใช้',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'กรุณากรอกชื่อผู้ใช้' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: _isObscurd,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่านใหม่',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd ? Icons.visibility_off : Icons.visibility),
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
                SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isObscurd2,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่านใหม่',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd2 ? Icons.visibility_off : Icons.visibility),
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
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: Text('เปลี่ยนรหัสผ่าน'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
