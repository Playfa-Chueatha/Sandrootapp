import 'package:flutter/material.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/screens/forgetpass.dart';
import 'package:sandy_roots/screens/Appbar_buyer.dart';
import 'package:sandy_roots/screens/AppBar_admin.dart';
import 'package:sandy_roots/services/animasion.dart';
// import 'package:sandy_roots/services/ShowUserJsonScreen%20.dart';

class Mainlogin extends StatefulWidget {
  const Mainlogin({super.key});

  @override
  State<Mainlogin> createState() => _LoginState();
}

class _LoginState extends State<Mainlogin> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _containerHeightFactor = 0.5;
  final userManager = DataUser();
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    setState(() {
      _containerHeightFactor = _tabController.index == 0 ? 0.5 : 0.6;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/backgroundlogin.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Center(
                    child: Image.asset(
                      'assets/images/logosandroots.png',
                      width: screenWidth * 0.8,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AnimatedContainer(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOutBack,  
                          decoration: BoxDecoration(
                            color: Color(0xFFFAF0E6).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              
                              //บนซ้าย
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                offset: Offset(-4, -4),
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                              //ล่างขวา
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.2),
                                offset: Offset(4, 4),
                                blurRadius: 2,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          height: screenHeight * _containerHeightFactor,
                          width: screenWidth * 0.9,
                          margin:  EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              TabBar(
                          controller: _tabController,
                          indicatorColor: Color(0xFF4B3621),
                          tabs: [
                            AnimatedCircleTab(
                              text: 'Login',
                              isSelected: _tabController.index == 0,
                            ),
                            AnimatedCircleTab(
                              text: 'Register',
                              isSelected: _tabController.index == 1,
                            ),
                          ],
                          onTap: (index) {
                            setState(() {
                              _tabController.index = index; 
                            });
                          },
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _Login(userManager: userManager),
                              _Register(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  final DataUser userManager;
  

  const _Login({required this.userManager});

  @override
  State<_Login> createState() => __LoginState();
}

class __LoginState extends State<_Login> {
  final _formKey = GlobalKey<FormState>();
  final usernameOrEmailController = TextEditingController();
  bool rememberMe = false;
  


  final passwordController = TextEditingController();
  bool _isObscurd = true;
  final DataUser dataUser = DataUser();

  @override
  void dispose() {
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
    
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    

    return Center(
      child: Container(
        margin:  EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFCDE3C0).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFDF9F4).withOpacity(0.6),
                      offset: Offset(-4, -4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.25),
                      offset: Offset(4, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: usernameOrEmailController,
                  decoration: InputDecoration(
                    hintText: 'Username or Email',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF8B5E3C)),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Color(0xFF8B5E3C).withOpacity(0.7)),
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16), // ปรับความสูงของ TextField
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFCDE3C0).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFDF9F4).withOpacity(0.6),
                      offset: Offset(-4, -4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.25),
                      offset: Offset(4, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscurd,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF8B5E3C)),
                    filled: true,
                    fillColor: Colors.transparent, 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd ? Icons.visibility_off : Icons.visibility), color: Color(0xFF8B5E3C),
                      onPressed: () {
                        setState(() {
                          _isObscurd = !_isObscurd;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16), 
                    hintStyle: TextStyle(color: Color(0xFF8B5E3C).withOpacity(0.7)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              //login button
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF9C7B56).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade300.withOpacity(0.4), 
                      offset: Offset(-4, -4),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.brown.shade700.withOpacity(0.6), 
                      offset: Offset(4, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String useroremail = usernameOrEmailController.text.trim();
                      String password = passwordController.text.trim();

                      if (useroremail == 'admin' && password == '1234') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("เริ่มการขายใน SandRoots store"),
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
                          MaterialPageRoute(builder: (context) => AppbarAdmin()),
                        );
                      } else {
                        await widget.userManager.loadUsers(); 
                        bool success = widget.userManager.login(useroremail, password);

                        if (success) {
                          UserProfile? user = widget.userManager.getUserProfile(useroremail, password);
                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("ยินดีต้อนรับสู่ SandRoots store"),
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
                              MaterialPageRoute(
                                builder: (context) => AppbarBuyer(userDetails: user),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"),
                              backgroundColor: Color(0xFFE97451).withOpacity(0.8),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFFFAF0E6), 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgetpass()),
                  );

                },
                child: Text(
                  "ลืมรหัสผ่าน", 
                  style: TextStyle(
                    color: Color(0xFFB7410E),
                    fontSize: 16,
                  )
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ShowUserTableScreen()),
              //     );

              //   },
              //   child: Text("ข้อมูล USER", style: TextStyle(color: Colors.redAccent)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Register extends StatefulWidget {
  @override
  State<_Register> createState() => _RegisterState();
}

class _RegisterState extends State<_Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final DataUser dataUser = DataUser();
  bool _isObscurd = true;
  bool _isObscurd2 = true;

  @override
  void initState() {
    super.initState();
    dataUser.loadUsers();
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com)$");
    return regex.hasMatch(email);
  }

  bool containsOnlyDigits(String s) {
  return RegExp(r'^\d+$').hasMatch(s);
}

bool containsOnlySpecialChars(String s) {
  // อักษรพิเศษที่ยอมรับ
  final specialChars = RegExp(r'^[-_@.]+$');
  return specialChars.hasMatch(s);
}

bool hasEnglishLetters(String s) {
  return RegExp(r'[a-zA-Z]').hasMatch(s);
}

bool hasAtLeast3EnglishLetters(String s) {
  final englishLetters = RegExp(r'[a-zA-Z]');
  int count = s.split('').where((c) => englishLetters.hasMatch(c)).length;
  return count >= 3;
}

bool hasSpecialChars(String s) {
  final specialChars = RegExp(r'[-_@.]');
  return specialChars.hasMatch(s);
}

bool isValidUsername(String username) {
  final trimmed = username.trim();

  
  if (RegExp(r'[\u0E00-\u0E7F]').hasMatch(trimmed)) {
    return false;
  }

  
  if (!RegExp(r'^[a-zA-Z0-9-_@.]+$').hasMatch(trimmed)) {
    return false;
  }

  if (!hasAtLeast3EnglishLetters(trimmed)) {
    return false;
  }

  if (!hasSpecialChars(trimmed)) {
    return false;
  }

  return true;
}



  bool isValidPassword(String password) {
    return password.length >= 5;
  }

  void registerUser() async {
  String email = emailController.text.trim();
  String username = usernameController.text.trim();
  String password = passwordController.text;
  String confirmPassword = confirmPasswordController.text;

  if (formkey.currentState?.validate() ?? false) {
    if (password != confirmPassword) {
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

    RegisterResult result = dataUser.register(email, username, password);

    switch (result) {
      case RegisterResult.success:
        await dataUser.saveUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("สมัครสมาชิกสำเร็จ"),
              backgroundColor: Color(0xFF708238).withOpacity(0.7),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              duration: Duration(seconds: 2),
          ),
        );
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainlogin()),
        );
        break;

      case RegisterResult.emailExists:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("อีเมลนี้ถูกใช้งานแล้ว"),
            backgroundColor: Color(0xFFE97451).withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            duration: Duration(seconds: 3),
          ),
        );
        break;

      case RegisterResult.usernameExists:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ชื่อผู้ใช้นี้ถูกใช้งานแล้ว"),
            backgroundColor: Color(0xFFE97451).withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            duration: Duration(seconds: 3),
          ),
        );
        break;
    }
  }
}


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFCDE3C0).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFDF9F4).withOpacity(0.6),
                        offset: Offset(-4, -4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.25),
                        offset: Offset(4, 4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFF8B5E3C)),
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      hintStyle: TextStyle(color: Color(0xFF8B5E3C).withOpacity(0.7)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      } else if (!isValidEmail(value)) {
                        return 'กรุณากรอกเฉพาะ @gmail.com หรือ @hotmail.com';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Username
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFCDE3C0).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFDF9F4).withOpacity(0.6),
                        offset: Offset(-4, -4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.25),
                        offset: Offset(4, 4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Color(0xFF8B5E3C)),
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      hintStyle: TextStyle(color: Color(0xFF8B5E3C).withOpacity(0.7)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อผู้ใช้';
                      }

                      final trimmed = value.trim();

                      if (RegExp(r'[\u0E00-\u0E7F]').hasMatch(trimmed)) {
                        return 'ไม่อนุญาตให้กรอกภาษาไทย';
                      }

                      if (!RegExp(r'^[a-zA-Z0-9\-_.@]+$').hasMatch(trimmed)) {
                        return 'ชื่อผู้ใช้สามารถประกอบด้วยตัวอักษรภาษาอังกฤษ ตัวเลข และ . - _ @ เท่านั้น';
                      }

                      if (trimmed.length < 4) {
                        return 'ชื่อผู้ใช้ต้องมีความยาวอย่างน้อย 4 ตัวอักษร';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Password
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFCDE3C0).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFDF9F4).withOpacity(0.6),
                        offset: Offset(-4, -4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.25),
                        offset: Offset(4, 4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _isObscurd,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF8B5E3C)),
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.transparent,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscurd ? Icons.visibility_off : Icons.visibility),
                        color: Color(0xFF8B5E3C),
                        onPressed: () {
                          setState(() {
                            _isObscurd = !_isObscurd;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      hintStyle: TextStyle(color: Color(0xFF8B5E3C).withOpacity(0.7)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      } else if (!isValidPassword(value)) {
                        return 'รหัสผ่านต้องมีอย่างน้อย 5 ตัวอักษร';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Confirm Password
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFCDE3C0).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFDF9F4).withOpacity(0.6),
                        offset: Offset(-4, -4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.25),
                        offset: Offset(4, 4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _isObscurd2,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF8B5E3C)),
                      hintText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.transparent,
                      suffixIcon: IconButton(
                        icon: Icon(_isObscurd2 ? Icons.visibility_off : Icons.visibility),
                        color: Color(0xFF8B5E3C),
                        onPressed: () {
                          setState(() {
                            _isObscurd2 = !_isObscurd2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      hintStyle: TextStyle(color: Color(0xFF8B5E3C).withOpacity(0.7)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกยืนยันรหัสผ่าน';
                      } else if (value != passwordController.text) {
                        return 'รหัสผ่านไม่ตรงกัน';
                      }
                      return null;
                    },
                  ),
                ),              
                SizedBox(height: screenHeight * 0.06),

                // Register Button
                Container(
                decoration: BoxDecoration(
                  color: Color(0xFF9C7B56).withOpacity(0.6), 
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade700.withOpacity(0.6), 
                      offset: Offset(4, 4),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.brown.shade300.withOpacity(0.4), 
                      offset: Offset(-4, -4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Color(0xFFFAF0E6), 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
