import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sandy_roots/Data/data_shoppingCart.dart';
import 'package:sandy_roots/Data/data_user.dart';
import 'package:sandy_roots/for_buyer/buyproducts.dart';
import 'package:sandy_roots/screens/Appbar_buyer.dart';


class Detailproduct extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String category;
  final UserProfile userDetails;
  const Detailproduct({
    super.key, 
    required this.id, 
    required this.name, 
    required this.price, 
    required this.description, 
    required this.imageUrl, 
    required this.category, 
    required this.userDetails, 
    
  });

  @override
  State<Detailproduct> createState() => _DetailproductState();
}

class _DetailproductState extends State<Detailproduct> {
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Cart.getItems();
    Cart.getTotalPrice();

    Widget imageWidget;
    if (widget.imageUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        widget.imageUrl,
        height: screenHeight * 0.4,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Image.file(
        File(widget.imageUrl),
        height: screenHeight * 0.4,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    
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
              imageWidget,
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
                        Cart.addItem({
                          'id': widget.id,
                          'name': widget.name,
                          'price': widget.price,
                          'imageUrl': widget.imageUrl,
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AppbarBuyer(
                            selectedIndex: 3,
                            userDetails: widget.userDetails,
                            )),
                        );


                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.name} ถูกเพิ่มลงในตะกร้าแล้ว')),
                        );
                      },
                      icon: Icon(Icons.shopping_bag),
                      label: Text('เพิ่มลงตระกร้า'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        
                        final oneItem = {
                          'id': widget.id,
                          'name': widget.name,
                          'price': widget.price,
                          'imageUrl': widget.imageUrl,
                          'quantity': 1,
                        };
                        
                        final oneTotal = widget.price * 1.0;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => buyproducts(
                              cartItems: [oneItem],   
                              total: oneTotal,
                              userDetails: widget.userDetails,     
                            ),
                          ),
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