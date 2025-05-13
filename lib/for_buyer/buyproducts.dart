import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandy_roots/data.dart';
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
    final String response = await rootBundle.loadString('assets/thai_address.json');
    final data = json.decode(response);
    setState(() {
      provinces = data;
    });
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
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรุณากรอกที่อยู่จัดส่ง',
              ),
            ),
            const SizedBox(height: 20),
            const Text('รายการสินค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.cartItems.map((item) => ListTile(
              leading: Image.asset(item['imageUrl'], width: 40, height: 40),
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
