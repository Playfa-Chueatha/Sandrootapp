import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandy_roots/Data/data_user.dart';

class Listorder_buyer extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String orderNumber;
  final double total;
  final String address;
  final String status;
  final UserProfile userDetails;

  const Listorder_buyer({
    super.key,
    required this.orderNumber,
    required this.cartItems,
    required this.total,
    required this.address,
    required this.status,
    required this.userDetails,
  });

  @override
  State<Listorder_buyer> createState() => _Listorder_buyerState();
}

class _Listorder_buyerState extends State<Listorder_buyer> with TickerProviderStateMixin {
  List<dynamic> orders = [];
  late TabController _tabController;
  late UserProfile userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadOrderData();
  }

  Future<void> loadOrderData() async {
    List<dynamic> loaded = await loadOrdersFromFile();

    final newOrder = {
      'orderNumber': widget.orderNumber,
      'cartItems': widget.cartItems,
      'total': widget.total,
      'address': widget.address,
      'status': widget.status,
      'email': widget.userDetails.email, 
    };

    bool isNewOrder = loaded.every((order) => order['orderNumber'] != newOrder['orderNumber']);

    if (isNewOrder) {
      loaded.insert(0, newOrder);
      await saveOrders(loaded);
    }

    setState(() {
      orders = loaded.where((order) => order['email'] == widget.userDetails.email).toList();
      isLoading = false; 
    });
  }


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/order_data.json');
  }

  Future<void> saveOrders(List<dynamic> orders) async {
    final file = await _localFile;
    final jsonString = jsonEncode(orders);
    await file.writeAsString(jsonString);
  }

  Future<List<dynamic>> loadOrdersFromFile() async {
    try {
      final file = await _localFile;
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } catch (e) {
      return [];
    }
  }


  Color getStatusColor(String status) {
    switch (status) {
      case 'รอการจัดส่ง':
        return const Color(0xFFD36E48);
      case 'กำลังจัดส่ง':
        return const Color(0xFFE1B382); 
      case 'จัดส่งสำเร็จ':
        return const Color(0xFF7A9E7E); 
      default:
        return Colors.grey;
    }
  }

  Widget buildStatusIcon(String status) {
    final color = getStatusColor(status);
    switch (status) {
      case 'รอการจัดส่ง':
        return Icon(Icons.access_time, color: color);
      case 'กำลังจัดส่ง':
        return Icon(Icons.local_shipping, color: color);
      case 'จัดส่งสำเร็จ':
        return Icon(Icons.check_circle, color: color);
      default:
        return Icon(Icons.help_outline, color: color);
    }
  }




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFf6f3ec),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'My Orders',
            style: GoogleFonts.notoSansThai(
              fontSize: 30
            ),
          ),
          backgroundColor: Color(0xFFf6f3ec),
          bottom: TabBar(
            controller: _tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: Color(0xFFa98b72)),
              insets: EdgeInsets.symmetric(horizontal: 10),
            ),
            indicatorWeight: 4,
            indicatorColor: Color(0xFFa98b72),
            labelColor: Colors.brown,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.notoSansThai(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.notoSansThai(fontSize: 16),
            tabs: [
              Tab(text: 'รอการจัดส่ง'),
              Tab(text: 'กำลังจัดส่ง'),
              Tab(text: 'จัดส่งสำเร็จ'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: buildOrderList(filterOrdersByStatus("รอการจัดส่ง")),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: buildOrderList(filterOrdersByStatus("กำลังจัดส่ง")),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: buildOrderList(filterOrdersByStatus("จัดส่งสำเร็จ")),
                  ),
                ],
              ),
      ),
    );
  }

  List<dynamic> filterOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  Widget buildOrderList(List<dynamic> orderList) {
    if (orderList.isEmpty) {
      return Center(
        child: Text(
          'ไม่มีคำสั่งซื้อ',
          style: GoogleFonts.notoSansThai(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        var order = orderList[index];
        return GestureDetector(
          onTap: () => showOrderDetailDialog(context, order, () {
            setState(() {});
          }),
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(8),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}',
                        style: GoogleFonts.notoSansThai(fontSize: 12, color:  Color.fromARGB(255, 107, 107, 107))),
                      Row(
                        children: [
                          buildStatusIcon(order['status']),
                          const SizedBox(width: 0),
                          Text(
                            order['status'],
                            style: GoogleFonts.notoSansThai(
                              color: getStatusColor(order['status']),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  Text('ที่อยู่จัดส่ง: ${order['address']}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.notoSansThai(fontSize: 15)),
                  const SizedBox(height: 12),
                  Text('รายการสินค้า:', style: GoogleFonts.notoSansThai(fontWeight: FontWeight.bold,fontSize: 16)),
                  const SizedBox(height: 6),
                  ...List<Map<String, dynamic>>.from(order['cartItems']).map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          item['imageUrl'].startsWith('assets/')
                          ? Image.asset(
                              item['imageUrl'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(item['imageUrl']),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(width: 10),
                          Expanded(child: Text('${item['name']} (x${item['quantity']})',style: GoogleFonts.notoSansThai(fontSize: 14),)),
                          Text('${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿',style: GoogleFonts.notoSansThai(fontSize: 14)),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ราคารวมทั้งหมด:', style: GoogleFonts.notoSansThai(fontWeight: FontWeight.bold,fontSize: 16)),
                      Text('${order['total'].toStringAsFixed(2)} ฿',
                          style: GoogleFonts.notoSansThai(color: Color.fromARGB(255, 123, 131, 102),fontWeight: FontWeight.bold,fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showOrderDetailDialog(
    BuildContext context, dynamic order, VoidCallback onStatusChanged) {
    int totalItems = List<Map<String, dynamic>>.from(order['cartItems'])
        .fold(0, (sum, item) => item['quantity'] + sum);

    showDialog(
      
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color(0xFFF9F9F9),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}',
                        style: const TextStyle(fontSize: 12, color:  Color.fromARGB(255, 107, 107, 107))),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFCD853F).withOpacity(0.4)
                    ),
                    child: Text(
                      'ที่อยู่จัดส่ง: ${order['address']}', 
                      maxLines: 4, 
                      overflow: TextOverflow.ellipsis, 
                      style: GoogleFonts.notoSansThai(fontSize: 15)
                  )),
                const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...List<Map<String, dynamic>>.from(order['cartItems']).map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        item['imageUrl'].startsWith('assets/')
                          ? Image.asset(
                              item['imageUrl'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(item['imageUrl']),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${item['name']} (x${item['quantity']})',
                            style: GoogleFonts.notoSansThai(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            '${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.notoSansThai(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('จำนวนรวม: $totalItems ชิ้น'),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('ราคารวมทั้งหมด: ${order['total'].toStringAsFixed(2)} ฿'),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment:  Alignment.centerRight,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildStatusIcon(order['status']),
                          const SizedBox(width: 0),
                          Text(
                            order['status'],
                            style: GoogleFonts.notoSansThai(
                              color: getStatusColor(order['status']),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 12),
                
              ],
            ),
          ),
          actions: [
            if (order['status'] == "กำลังจัดส่ง")
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E9775),
                  foregroundColor: Colors.white,
                  elevation: 4, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                ),
                onPressed: () {
                  final index = orders.indexOf(order);
                  if (index != -1) {
                    orders[index]['status'] = "จัดส่งสำเร็จ";
                    saveOrders(orders);
                  }

                  onStatusChanged();
                  Navigator.pop(context);
                },
                child: const Text('ได้รับสินค้าแล้ว'),
              ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด'),
            ),
          ],
        ),
      ),
    );
  }
}
