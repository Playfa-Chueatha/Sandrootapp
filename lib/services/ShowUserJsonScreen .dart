import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ShowUserTableScreen extends StatefulWidget {
  const ShowUserTableScreen({super.key});

  @override
  _ShowUserTableScreenState createState() => _ShowUserTableScreenState();
}

class _ShowUserTableScreenState extends State<ShowUserTableScreen> {
  List<Map<String, dynamic>> users = [];
  String filePath = '';

  Future<void> loadUsersFromJsonFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/user_data.json');
      filePath = file.path;

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = json.decode(jsonString);

        if (jsonData is List) {
          setState(() {
            users = jsonData.cast<Map<String, dynamic>>();
          });
        } else {
          setState(() {
            users = [jsonData];
          });
        }
      } else {
        setState(() {
          users = [];
        });
      }
    } catch (e) {
      setState(() {
        users = [];
      });
    }
  }

  Future<void> clearUserDataFile() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/user_data.json');

    if (await file.exists()) {
      await file.writeAsString('[]'); // เขียนอาร์เรย์ว่างลงไป
    } else {
    }
  } catch (e) {
    // print('⚠️ เกิดข้อผิดพลาดในการล้างข้อมูล: $e');
  }
}

  @override
  void initState() {
    super.initState();
    loadUsersFromJsonFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายชื่อผู้ใช้')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: users.isEmpty
            ? Center(child: Text('ไม่มีข้อมูลผู้ใช้ หรือยังไม่ได้โหลดไฟล์'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📁 Path: $filePath', style: TextStyle(fontSize: 12)),
                                    ElevatedButton(
                    onPressed: () async {
                      await clearUserDataFile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("ล้างข้อมูลผู้ใช้เรียบร้อย")),
                      );
                      // อัปเดตหน้าจอใหม่ถ้าจำเป็น
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("🗑️ ล้างข้อมูลผู้ใช้"),
                  ),

                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('password')),
                          DataColumn(label: Text('Profile')),
                        ],
                        rows: users.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user['email'] ?? '')),
                              DataCell(Text(user['username'] ?? '')),
                              DataCell(Text(user['password'] ?? '')),
                              DataCell(
                                Image.asset(
                                  user['profileImage'] ?? '',
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.image_not_supported),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
