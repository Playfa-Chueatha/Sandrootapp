import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    Cart.getItems(widget.userDetails.email);
    Cart.getTotalPrice(widget.userDetails.email);


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
      backgroundColor: Color(0xFFf6f3ec),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Stack(
                children: [
                  imageWidget,
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),          
              Padding(
                padding: EdgeInsets.fromLTRB(10,10,10,2),
                child: Text(widget.name,
                style: GoogleFonts.notoSansThai(
                  fontSize: 20,
                  color: Colors.black
                ))),
              Padding(padding: EdgeInsets.fromLTRB(10,3,10,5),
                child:Text('${widget.price} ฿',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 18,
                    color: Color.fromARGB(255, 123, 131, 102), 
                  ),
                ),
              ),             
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Text(widget.description,style: GoogleFonts.notoSansThai(
                      fontSize: 16,
                      color: Colors.black
                    )),
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
                        Cart.addItem(widget.userDetails.email, {
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
                          SnackBar(
                              content: Text("สินค้าถูกเพิ่มลงในตะกร้าแล้ว",style: TextStyle(fontSize: 14),),
                              backgroundColor: Color(0xFF708238).withOpacity(0.8),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(Icons.add),style: ButtonStyle(
                        iconColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      label: Text('เพิ่มลงตระกร้า',style: GoogleFonts.notoSansThai(
                        color: Colors.black
                      ),),
                    ),
                    SizedBox(width:screenWidth * 0.01),
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
                      icon: Icon(Icons.shopping_bag),style: ButtonStyle(
                        iconColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      label: Text('สั่งซื้อสินค้า',
                      style: GoogleFonts.notoSansThai(
                          color: Colors.black
                        )
                      ),
                    ),
                  ],
                ),
              )
          ],
      ),
    );
  }
}