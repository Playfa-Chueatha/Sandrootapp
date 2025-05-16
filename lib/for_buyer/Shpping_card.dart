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
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D5BA),
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
                      leading: buildImage(item['imageUrl']),
                      title: Text(item['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ราคา: ${item['price']} ฿'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: item['quantity'] > 1
                                  ? () async {
                                      await Cart.decreaseQuantity(widget.userDetails.email, item['id']);
                                      await _updateCart();
                                    }
                                  : null,
                              ),
                              SizedBox(
                                width: 50,
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
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  await Cart.increaseQuantity(widget.userDetails.email, item['id']);
                                  await _updateCart();
                                },
                              ),
                            ],
                          ),
                          Text('รวม: ${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿'),
                          TextButton(
                            onPressed: () async {
                              await Cart.removeItem(widget.userDetails.email, item['id']);
                              await _updateCart();
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
                        ).then((_) async {
                          await Cart.clear(widget.userDetails.email);
                          await _updateCart();
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
