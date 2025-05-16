import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum RegisterResult {
  success,
  emailExists,
  usernameExists,
}

class DataUser {
  List<UserProfile> users = [];
  final String _fileName = 'user_data.json';

  
  Future<File> get localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> loadUsers() async {
    final file = await localFile;

    if (!await file.exists()) {
      await file.writeAsString('[]'); 
    }

    final contents = await file.readAsString();

    final dynamic jsonData = json.decode(contents);

    if (jsonData is List) {
      users = jsonData
          .map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (jsonData is Map<String, dynamic>) {
      users = [UserProfile.fromJson(jsonData)];
    } else {
      throw Exception('รูปแบบ JSON ไม่รองรับ');
    }
  }


  Future<void> saveUsers() async {
    final file = await localFile; // ใช้ localFile แทน _localFile
    final jsonList = users.map((u) => u.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  bool login(String usernameOrEmail, String password) {
    final input = usernameOrEmail.trim();
    for (var user in users) {
      if ((user.username.toLowerCase() == input || user.email.toLowerCase() == input) &&
          user.password == password) {
        return true;
      }
    }
    return false;
  }

  UserProfile? getUserProfile(String usernameOrEmail, String password) {
    final input = usernameOrEmail.trim();
    for (var user in users) {
      if ((user.username == input || user.email == input) &&
          user.password == password) {
        return user;
      }
    }
    return null;
  }

  RegisterResult register(String email, String username, String password) {
    final inputEmail = email.toLowerCase();
    final inputUser = username.toLowerCase();

    if (users.any((u) => u.email.toLowerCase() == inputEmail)) {
      return RegisterResult.emailExists;
    }
    if (users.any((u) => u.username.toLowerCase() == inputUser)) {
      return RegisterResult.usernameExists;
    }

    users.add(UserProfile(
      email: email,
      username: username,
      password: password,
      profileImage: 'assets/images/default_sandyroot.png',
    ));

    return RegisterResult.success;
  }
}



//user
class UserProfile {
  String email;
  String username;
  String password;
  String profileImage;

  UserProfile({
    required this.email,
    required this.username,
    required this.password,
    required this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
    );
  }



  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
    'profileImage': profileImage,
  };
}








