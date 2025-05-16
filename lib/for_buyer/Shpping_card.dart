import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sandy_roots/Data/data_shoppingCart.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/for_buyer/buyproducts.dart';

class Shpping_card extends StatefulWidget {
  final UserProfile userDetails;
  const Shpping_card({
    super.key, 
    required this.userDetails
  });

  @override
  State<Shpping_card> createState() => _Shpping_cardState();
}

class _Shpping_cardState extends State<Shpping_card> {
  @override
  Widget build(BuildContext context) {
    final cartItems = Cart.getItems();
    final total = Cart.getTotalPrice();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D5BA),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text("ตะกร้าสินค้า"),
      ),
      body: cartItems.isEmpty
        ? Center(
            child: Text(
              'ไม่มีสินค้าในตะกร้าของคุณ',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      leading: buildImage(item['imageUrl'], width: 50, height: 50),
                      title: Text(item['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ราคา: ${item['price']} ฿'),
                          Row(
                            children: [
                              // ปุ่มลบ
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: item['quantity'] > 1
                                  ? () {
                                      setState(() {
                                        Cart.decreaseQuantity(item['id']);
                                      });
                                    }
                                  : null,  // ปิดการใช้งานถ้าจำนวนสินค้าคือ 1
                              ),
                              
                              // การกรอกจำนวนสินค้า
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(text: item['quantity'].toString()),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && int.tryParse(value) != null) {
                                      setState(() {
                                        Cart.updateQuantity(item['id'], int.parse(value));
                                      });
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              
                              // ปุ่มเพิ่ม
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    Cart.increaseQuantity(item['id']);
                                  });
                                },
                              ),
                            ],
                          ),
                          Text('รวม: ${item['price'] * item['quantity']} ฿'),

                          // ปุ่มลบรายการสินค้า
                          TextButton(
                            onPressed: () {
                              setState(() {
                                Cart.removeItem(item['id']);
                              });
                            },
                            child: Text('ลบรายการสินค้า', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ราคารวมทั้งหมด:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} ฿',
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        final currentCart = List<Map<String, dynamic>>.from(cartItems);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => buyproducts(
                              cartItems: currentCart,
                              total: total,
                              userDetails: widget.userDetails,
                            ),
                          ),
                        ).then((_) {
                          setState(() {
                            Cart.clear(); // เคลียร์ตะกร้าหลังกลับจากหน้า buyproducts
                          });
                        });
                      },
                      icon: Icon(Icons.event_busy),
                      label: Text('สั่งซื้อสินค้า'),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

Widget buildImage(String imageUrl, {double width = 50, double height = 50}) {
  if (imageUrl.startsWith('/')) {
    return Image.file(
      File(imageUrl),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image);
      },
    );
  } else {
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image);
      },
    );
  }
}

