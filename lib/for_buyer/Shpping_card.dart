import 'package:flutter/material.dart';
import 'package:sandy_roots/data.dart';
import 'package:sandy_roots/for_buyer/buyproducts.dart';

class Shpping_card extends StatefulWidget {
  const Shpping_card({super.key});

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                  leading: Image.asset(item['imageUrl'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ราคา: ${item['price']} ฿'),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                Cart.decreaseQuantity(item['id']);
                              });
                            },
                          ),
                          Text('${item['quantity']}'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => buyproducts(
                          cartItems: cartItems,
                          total: total,
                        ),
                      ),
                    );
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
