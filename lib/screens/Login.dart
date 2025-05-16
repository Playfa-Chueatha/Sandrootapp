import 'package:flutter/material.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/forgetpass.dart';
import 'package:sandy_roots/screens/Appbar_buyer.dart';
import 'package:sandy_roots/screens/AppBay_admin.dart';
import 'package:sandy_roots/screens/ShowUserJsonScreen%20.dart';

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
        backgroundColor: const Color(0xFFF9F7F3),
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
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8D5BA).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: screenHeight * _containerHeightFactor,
                    width: screenWidth * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.green,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: 'Login'),
                            Tab(text: 'Register'),
                          ],
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

class _Login extends StatefulWidget {
  final DataUser userManager;
  

  const _Login({required this.userManager});

  @override
  State<_Login> createState() => __LoginState();
}

class __LoginState extends State<_Login> {
  final _formKey = GlobalKey<FormState>();
  final usernameOrEmailController = TextEditingController();
  


  final passwordController = TextEditingController();
  bool _isObscurd = true;
  final DataUser dataUser = DataUser();

  @override
  void dispose() {
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
    dataUser.loadUsers(); 
  }

  

  void loginUser() {
    String email = usernameOrEmailController.text.trim();
    String password = passwordController.text;

    if (dataUser.login(email, password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("เข้าสู่ระบบสำเร็จ"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // นำข้อมูลจาก UserProfile มาใช้ในที่นี้
      UserProfile userProfile = dataUser.getUserProfile(email, password)!;  // สมมติว่า getUserProfile() ส่งคืน UserProfile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppbarBuyer(userDetails: userProfile)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("อีเมลหรือรหัสผ่านไม่ถูกต้อง"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    

    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameOrEmailController,
                decoration: InputDecoration(
                  hintText: 'Username or Email',
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อผู้ใช้หรืออีเมล';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: passwordController,
                obscureText: _isObscurd,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurd ? Icons.visibility_off : Icons.visibility),
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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.07),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String useroremail = usernameOrEmailController.text.trim();
                    String password = passwordController.text.trim();

                    if (useroremail == 'admin' && password == '1234') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Login successful"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProductsScreen()),
                      );
                    } else {
                      await widget.userManager.loadUsers(); // ✅ รอให้โหลดเสร็จก่อน
                      bool success = widget.userManager.login(useroremail, password);

                      if (success) {
                        UserProfile? user = widget.userManager.getUserProfile(useroremail, password);
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Welcome to SandRoots store"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
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
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgetpass()),
                  );

                },
                child: Text("ลืมรหัสผ่าน", style: TextStyle(color: Colors.redAccent)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowUserTableScreen()),
                  );

                },
                child: Text("ข้อมูล USER", style: TextStyle(color: Colors.redAccent)),
              ),
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
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
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
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
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
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case RegisterResult.usernameExists:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ชื่อผู้ใช้นี้ถูกใช้งานแล้ว"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
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
                SizedBox(height: screenHeight * 0.02),

                // Username
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
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
                SizedBox(height: screenHeight * 0.02),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscurd,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd ? Icons.visibility_off : Icons.visibility),
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
                SizedBox(height: screenHeight * 0.02),

                // Confirm Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isObscurd2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurd2 ? Icons.visibility_off : Icons.visibility),
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
                SizedBox(height: screenHeight * 0.07),

                // Register Button
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B5E3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Register', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
