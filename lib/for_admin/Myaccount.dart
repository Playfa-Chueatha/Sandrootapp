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
      body: SingleChildScrollView(
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
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Mainlogin()),
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
      ),
    );
  }
}
