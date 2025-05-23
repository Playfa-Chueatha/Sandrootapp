import 'dart:io';
import 'package:flutter/material.dart';



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
                child: Text(widget.name,style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ))),
              Padding(padding: EdgeInsets.fromLTRB(10,3,10,5),
                child:Text('${widget.price} ฿',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 123, 131, 102), 
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
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'คุณกำลังอยู่ในมุมมองผู้ซื้อ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Color(0xFF7B5E57).withOpacity(0.5), 
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      },
                      icon: Icon(Icons.add),style: ButtonStyle(
                        iconColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      label: Text('เพิ่มลงตระกร้า',style: TextStyle(
                        color: Colors.black
                      ),),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'คุณกำลังอยู่ในมุมมองผู้ซื้อ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Color(0xFF7B5E57).withOpacity(0.5), 
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      },
                      icon: Icon(Icons.shopping_bag),style: ButtonStyle(
                        iconColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      label: Text('สั่งซื้อสินค้า',
                      style: TextStyle(
                          color: Colors.black
                      )),
                      
                    ),
                  ],
                ),
              )
          ],
      ),
    );
  }
}