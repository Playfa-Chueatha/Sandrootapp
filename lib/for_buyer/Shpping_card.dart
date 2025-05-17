import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Map<String, dynamic>> cartItems = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await Cart.getItems(widget.userDetails.email);
    final totalPrice = await Cart.getTotalPrice(widget.userDetails.email);
    setState(() {
      cartItems = items;
      total = totalPrice;
    });
  }

  // เมื่อแก้ไขตะกร้าแล้วโหลดข้อมูลใหม่
  Future<void> _updateCart() async {
    await _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f3ec),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFf6f3ec),
        title: Text(     
            'Shopping Cart',
            style: GoogleFonts.notoSansThai(
              fontSize: 30
            ),
          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFf6f3ec),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: buildImage(item['imageUrl']),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    item['name'],
                                    style: GoogleFonts.notoSansThai(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[900],
                                    ),
                                ),                          
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ราคา: ${item['price']} ฿',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),  
                                    Row(  
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove_circle_outline, color: Colors.grey[700], size: 22),
                                          onPressed: item['quantity'] > 1
                                              ? () async {
                                                  await Cart.decreaseQuantity(widget.userDetails.email, item['id']);
                                                  await _updateCart();
                                                }
                                              : null,
                                          splashRadius: 20,
                                        ),
                                        SizedBox(
                                          width: 25,
                                          height: 30,
                                          child: Center(
                                            child: TextField(
                                              keyboardType: TextInputType.number,
                                              controller: TextEditingController(text: item['quantity'].toString()),
                                              onChanged: (value) async {
                                                if (value.isNotEmpty && int.tryParse(value) != null) {
                                                  final int newQuantity = int.parse(value);
                                                  await Cart.updateQuantity(widget.userDetails.email, item['id'], newQuantity);
                                                  await _updateCart();
                                                }
                                              },
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 6),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline, color: Colors.grey[700], size: 22),
                                          onPressed: () async {
                                            await Cart.increaseQuantity(widget.userDetails.email, item['id']);
                                            await _updateCart();
                                          },
                                          splashRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'รวม: ${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 123, 131, 102), 
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () async {
                              await Cart.removeItem(widget.userDetails.email, item['id']);
                              await _updateCart();
                            },
                            splashRadius: 20,
                            tooltip: 'ลบรายการสินค้า',
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
                  color: Color(0xFFf6f3ec),
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
                      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 123, 131, 102), ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF6B4C3B), width: 1.5), // กำหนดสีและความหนาเส้นกรอบ
                      ),
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
                        ).then((_) async {      
                          await _updateCart();
                        });
                      },
                      icon: Icon(Icons.shopping_bag, color: Color(0xFF6B4C3B)),
                      label: Text('สั่งซื้อสินค้า',style: TextStyle(color: Color(0xFF6B4C3B))),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
