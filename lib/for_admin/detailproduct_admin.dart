import 'package:flutter/material.dart';
import 'package:sandy_roots/data.dart';



class Detailproduct_admin extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String category;
  const Detailproduct_admin({
    super.key, 
    required this.id, 
    required this.name, 
    required this.price, 
    required this.description, 
    required this.imageUrl, 
    required this.category
  });

  @override
  State<Detailproduct_admin> createState() => _DetailproductState();
}

class _DetailproductState extends State<Detailproduct_admin> {
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Cart.getItems();
    Cart.getTotalPrice();
    return Scaffold(
      appBar: AppBar(
                backgroundColor: const Color(0xFFA8D5BA),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Image.asset(
                  widget.imageUrl,
                  height: screenHeight * 0.4,
                  width: double.infinity,
                  fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,10,10,2),
                child: Text(widget.name,style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ))),
              Padding(padding: EdgeInsets.fromLTRB(10,3,10,5),
                child:Text('${widget.price} ฿',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green
                  ),
                ),
              ),             
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Text(widget.description),
                  ), 
                )
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                      
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.name} คุณกำลังอยู่ในมุมมองผู้ซื้อ')),
                        );
                      },
                      icon: Icon(Icons.shopping_bag),
                      label: Text('เพิ่มลงตระกร้า'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.name} คุณกำลังอยู่ในมุมมองผู้ซื้อ')),
                        );
                      },
                      icon: Icon(Icons.event_busy),
                      label: Text('สั่งซื้อสินค้า'),
                    ),
                  ],
                ),
              )
          ],
      ),
    );
  }
}