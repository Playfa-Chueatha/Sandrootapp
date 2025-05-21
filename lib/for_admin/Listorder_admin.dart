import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class Listorder extends StatefulWidget {
  const Listorder({super.key});

  @override
  State<Listorder> createState() => _ListorderState();
}

class _ListorderState extends State<Listorder> with TickerProviderStateMixin {
  List<dynamic> orders = [];
  late TabController _tabController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrderData();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/order_data.json');
  }

  Future<void> loadOrderData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        setState(() {
          orders = jsonDecode(jsonString);
          isLoading = false;
        });
      } else {
        
        String jsonData = await rootBundle.loadString('assets/data/order_data.json');
        await file.writeAsString(jsonData);
        setState(() {
          orders = jsonDecode(jsonData);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        orders = [];
        isLoading = false;
      });
    }
  }

  Future<void> saveOrders(List<dynamic> updatedOrders) async {
    final file = await _localFile;
    await file.writeAsString(jsonEncode(updatedOrders));
  }


  List<dynamic> filterOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  void showOrderDetailDialog(BuildContext context, dynamic order, VoidCallback onStatusUpdated) {
  int totalItems = List<Map<String, dynamic>>.from(order['cartItems'])
      .fold(0, (sum, item) => item['quantity'] + sum);

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor:  Color(0xFFF9F9F9),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}',
                  style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 107, 107, 107))),
              const SizedBox(height: 6),
              Text('อีเมลผู้สั่งซื้อ: ${order['email']}'),
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
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildStatusIcon(order['status']),
                    const SizedBox(width: 4),
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
          if (order['status'] == "รอการจัดส่ง")
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
                    orders[index]['status'] = "กำลังจัดส่ง";
                    saveOrders(orders);
                  }

                  onStatusUpdated();
                  Navigator.pop(context);
                },
                child: const Text('จัดส่งสินค้าแล้ว'),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFf6f3ec),
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: TextStyle(
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
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
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
}


