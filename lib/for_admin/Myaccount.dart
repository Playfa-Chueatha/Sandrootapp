import 'package:flutter/material.dart';
import 'package:sandy_roots/screens/Login.dart';

class Myaccount extends StatelessWidget {
  const Myaccount({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFf6f3ec),
        title: Text(     
            'My account',
            style: TextStyle(
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
              
              // CircleAvatar(
              //     radius: 60,
              //     backgroundImage: const AssetImage('assets/images/default_sandyroot.png') as ImageProvider,
              // ),
                            
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('ชื่อผู้ใช้'),
                subtitle: Text('admin'),
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
