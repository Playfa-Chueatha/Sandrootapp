import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/screens/Appbar_buyer.dart';
import 'package:sandy_roots/screens/AppBay_admin.dart';

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
    userManager.loadUsers();
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

  @override
  void dispose() {
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isObscurd = true;
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
                    padding: const EdgeInsetsDirectional.all(10.0),
                    icon: _isObscurd
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
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
                        SnackBar(content: Text("Login successful"),
                          backgroundColor: Colors.green, 
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProductsScreen()), 
                      );
                    } else {
                      
                      await widget.userManager.loadUsers();
                      bool success = widget.userManager.login(useroremail, password);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Wellcome to SandRoots store"),
                            backgroundColor: Colors.green, 
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AppbarBuyer(userManager: DataUser())),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง",
                              style: TextStyle(color: Colors.white), 
                            ),
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
                onPressed: () {},
                child: Text("ลืมรหัสผ่าน", style: TextStyle(color: Colors.redAccent)),
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
  bool  _isObscurd = true;
  bool  _isObscurd2 = true;
  @override
  void initState() {
    super.initState();
    dataUser.loadUsers();
     _isObscurd = true;
     _isObscurd2 = true;
  }

  void registerUser() async {
  String email = emailController.text.trim();
  String username = usernameController.text.trim();
  String password = passwordController.text;
  String confirmPassword = confirmPasswordController.text;

  
  if (formkey.currentState?.validate() ?? false) {  
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("รหัสผ่านไม่ตรงกัน"),
            backgroundColor: Colors.red, 
            behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    bool success = dataUser.register(email, username, password);
    if (success) {
      await dataUser.saveUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("สมัครสมาชิกสำเร็จ"),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("มีผู้ใช้นี้อยู่แล้ว"),
            backgroundColor: Colors.red, 
            behavior: SnackBarBehavior.floating,
        ),
      );
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
              child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  }
                  return null;
                },
                ),
                SizedBox(height: screenHeight * 0.02),
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
                  return null;
                },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscurd,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _isObscurd = !_isObscurd;
                        });
                    }, 
                    icon: _isObscurd
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                    )
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  return null;
                },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isObscurd2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _isObscurd2 = !_isObscurd2;
                        });
                    }, 
                    icon: _isObscurd2
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                    )
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกยืนยันรหัสผ่าน';
                  }
                  return null;
                },
                ),
                SizedBox(height: screenHeight * 0.07),
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



class DataUser {
  List<Map<String, dynamic>> users = [];

  Future<void> loadUsers() async {
    final file = await _getUserFile();
    if (await file.exists()) {
      String content = await file.readAsString();
      users = List<Map<String, dynamic>>.from(json.decode(content));
    } else {
      
      String assetContent = await rootBundle.loadString('assets/data/users.json');
      await file.writeAsString(assetContent);
      users = List<Map<String, dynamic>>.from(json.decode(assetContent));
    }
  }

  Future<void> saveUsers() async {
    final file = await _getUserFile();
    await file.writeAsString(json.encode(users));
  }

  Future<File> _getUserFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  bool login(String usernameOrEmail, String password) {
    return users.any((user) =>
      (user['email'] == usernameOrEmail || user['username'] == usernameOrEmail)
      && user['password'] == password);
  }

  bool register(String email, String username, String password) {
    bool exists = users.any((u) =>
      u['email'] == email || u['username'] == username);
    if (exists) return false;

    users.add({
      'email': email,
      'username': username,
      'password': password,
    });
    return true;
  }
}