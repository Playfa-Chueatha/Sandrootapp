import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandy_roots/Data/data_shoppingCart.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Color(0xFFf6f3ec),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(      
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('')

              ],
            ),  
            const SizedBox(height: 20),
            Padding(padding: EdgeInsets.fromLTRB(5,10,5,5),
            child: Text('ที่อยู่จัดส่ง', style: GoogleFonts.notoSansThai(fontSize: 18))),
       
            // บ้านเลขที่/หมู่ที่
            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: houseNoController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'บ้านเลขที่/หมู่ที่',
                  hintStyle: GoogleFonts.notoSansThai(
                          fontSize: 16,
                        ),
                ),
                onChanged: (value) => updateFullAddress(),
              ),
            ),
            const SizedBox(height: 10),

            // จังหวัด
            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf6f3ec)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf6f3ec)),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  isExpanded: true,
                  hint: Text('เลือกจังหวัด',style: GoogleFonts.notoSansThai(fontSize: 16)),
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
                      districts = provinces
                          .firstWhere((p) => p['province'] == value)['districts'];
                      subdistricts = [];
                    });
                    updateFullAddress();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // อำเภอ
            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf6f3ec)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf6f3ec)),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  isExpanded: true,
                  hint: Text('เลือกอำเภอ',style: GoogleFonts.notoSansThai(fontSize: 16)),
                  value: selectedDistrict,
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
                      final district = districts
                          .firstWhere((d) => d['name'] == value);
                      subdistricts = district['subdistricts'];
                      zipcode = '';
                    });
                    updateFullAddress();
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ตำบล
            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf6f3ec)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFf6f3ec)),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  isExpanded: true,
                  hint: Text('เลือกตำบล',style: GoogleFonts.notoSansThai(fontSize: 16)),
                  value: selectedSubdistrict,
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
                )
              ),
            ),
            const SizedBox(height: 15),

            // แสดงรหัสไปรษณีย์
            Text('รหัสไปรษณีย์: $zipcode', style: GoogleFonts.notoSansThai(fontSize: 16)),
            SizedBox(height: 20),
            Text('รายการสินค้า', style: GoogleFonts.notoSansThai(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.cartItems.map((item) => ListTile(
              leading: buildImage(item['imageUrl']),
              title: Text(item['name'], style: GoogleFonts.notoSansThai(fontSize: 16)),
              subtitle: Text('จำนวน ${item['quantity']} | รวม ${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿', style: GoogleFonts.notoSansThai(fontSize: 14)),
            )),
            Divider(
              color: Colors.grey,
              thickness: 1,  
              indent: 10,    
              endIndent: 10,
            ),
            Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ราคารวมทั้งหมด:', style: GoogleFonts.notoSansThai(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )),
                  Text('${widget.total.toStringAsFixed(2)} ฿', 
                  style: GoogleFonts.notoSansThai(
                    fontSize: 18, 
                    color: Color.fromARGB(255, 123, 131, 102), 
                    fontWeight: FontWeight.bold
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFc3a68e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,  
                  shadowColor: Colors.brown.withOpacity(0.5), 
                ),
                onPressed: () async {
                  if (addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("กรุณากรอกที่อยู่จัดส่ง"),
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
                  await Cart.clear(widget.userDetails.email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("สั่งซื้อสำเร็จแล้ว!"),
                      backgroundColor: Color(0xFF708238).withOpacity(0.8),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                        right: 16,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'ยืนยันการสั่งซื้อ',
                    style: GoogleFonts.notoSansThai(
                      fontSize: 18,
                      color: Color(0xFF7B5E57),
                    ),
                  ),
                ),
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

