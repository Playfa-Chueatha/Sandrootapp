import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/screens/Appbar_buyer.dart';

class buyproducts extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final UserProfile userDetails;

  const buyproducts({
    super.key, 
    required this.cartItems, 
    required this.total, 
    required this.userDetails, 
    
  });

  @override
  State<buyproducts> createState() => _buyproductsState();
}

class _buyproductsState extends State<buyproducts> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  List provinces = [];
  List districts = [];
  List subdistricts = [];
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedSubdistrict;
  String zipcode = '';

  // เพิ่มตัวแปร orders เพื่อเก็บรายการสั่งซื้อ
  List<Map<String, dynamic>> orders = [];

  Future<void> loadAddressData() async {
    final String response = await rootBundle.loadString('assets/data/thai_address.json');
    final data = json.decode(response);
    setState(() {
      provinces = data;
    });
  }

  void updateFullAddress() {
    if (houseNoController.text.isEmpty ||
        selectedProvince == null ||
        selectedDistrict == null ||
        selectedSubdistrict == null ||
        zipcode.isEmpty) {
      return;
    }

    String fullAddress = '${houseNoController.text} '
        'ต.$selectedSubdistrict อ.$selectedDistrict '
        'จ.$selectedProvince $zipcode';

    addressController.text = fullAddress;
  }


  @override
  void initState() {
    super.initState();
    loadAddressData();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D5BA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("ยืนยันการสั่งซื้อ"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ที่อยู่จัดส่ง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: houseNoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'บ้านเลขที่/หมู่ที่',
                labelText: 'บ้านเลขที่',
              ),
              onChanged: (value) => updateFullAddress(),
            ),

            const SizedBox(height: 10),

            // จังหวัด
            DropdownButton<String>(
              hint: const Text('เลือกจังหวัด'),
              value: selectedProvince,
              items: provinces.map<DropdownMenuItem<String>>((province) {
                return DropdownMenuItem<String>(
                  value: province['province'],
                  child: Text(province['province']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvince = value;
                  selectedDistrict = null;
                  selectedSubdistrict = null;
                  zipcode = '';
                  districts = provinces.firstWhere((p) => p['province'] == value)['districts'];
                  subdistricts = [];
                });
                updateFullAddress();
              },
            ),
            const SizedBox(height: 10),

            // อำเภอ
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'อำเภอ',
              ),
              items: districts.map<DropdownMenuItem<String>>((district) {
                return DropdownMenuItem<String>(
                  value: district['name'],
                  child: Text(district['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedSubdistrict = null;
                  final district = districts.firstWhere((d) => d['name'] == value);
                  subdistricts = district['subdistricts'];
                  zipcode = '';
                });
                updateFullAddress();
              },
            ),
            const SizedBox(height: 10),

            // ตำบล
            DropdownButtonFormField<String>(
              value: selectedSubdistrict,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ตำบล',
              ),
              items: subdistricts.map<DropdownMenuItem<String>>((subdistrict) {
                return DropdownMenuItem<String>(
                  value: subdistrict['name'],
                  child: Text(subdistrict['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubdistrict = value;
                  final district = districts.firstWhere((d) => d['name'] == selectedDistrict);
                  final sub = district['subdistricts'].firstWhere((s) => s['name'] == value);
                  zipcode = sub['zipcode'];
                });
                updateFullAddress();
              },
            ),
            const SizedBox(height: 10),

            // แสดงรหัสไปรษณีย์
            Text('รหัสไปรษณีย์: $zipcode', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('รายการสินค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.cartItems.map((item) => ListTile(
              leading: buildImage(item['imageUrl']),
              title: Text(item['name']),
              subtitle: Text('จำนวน ${item['quantity']} | รวม ${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿'),
            )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ราคารวมทั้งหมด:', style: TextStyle(fontSize: 18)),
                Text('${widget.total.toStringAsFixed(2)} ฿', style: const TextStyle(fontSize: 18, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณากรอกที่อยู่จัดส่ง')),
                    );
                    return;
                  }


                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppbarBuyer(
                        selectedIndex: 2,
                        orderData: {
                          'cartItems': widget.cartItems,
                          'total': widget.total,
                          'address': addressController.text,
                          'status': 'รอการจัดส่ง',
                          'orderNumber': 'ORD-${DateTime.now().millisecondsSinceEpoch}'
                        }, userDetails: widget.userDetails, 
                      ),
                    ),
                  );

                },
                child: const Text('ยืนยันการสั่งซื้อ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget buildImage(String imageUrl) {
  if (imageUrl.startsWith('/')) {
    // เป็น path ของไฟล์ในเครื่อง
    return Image.file(
      File(imageUrl),
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image);
      },
    );
  } else {
    // เป็น asset path
    return Image.asset(
      imageUrl,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image);
      },
    );
  }
}