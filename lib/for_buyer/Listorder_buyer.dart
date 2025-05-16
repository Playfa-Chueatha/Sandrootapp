import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context, orders.isNotEmpty ? orders.last : null);
          //   },
          // ),
          title: const Text('รายการคำสั่งซื้อ'),
          backgroundColor: const Color(0xFFA8D5BA),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
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
                  buildOrderList(filterOrdersByStatus("รอการจัดส่ง")),
                  buildOrderList(filterOrdersByStatus("กำลังจัดส่ง")),
                  buildOrderList(filterOrdersByStatus("จัดส่งสำเร็จ")),
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
      return const Center(
        child: Text(
          'ไม่มีคำสั่งซื้อ',
          style: TextStyle(fontSize: 16, color: Colors.grey),
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
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('สถานะ: ${order['status']}', style: const TextStyle(color: Colors.orange)),
                  const SizedBox(height: 8),
                  Text('ที่อยู่จัดส่ง: ${order['address']}', maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...List<Map<String, dynamic>>.from(order['cartItems']).map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Image.asset(item['imageUrl'], width: 40, height: 40),
                          const SizedBox(width: 10),
                          Expanded(child: Text('${item['name']} (x${item['quantity']})')),
                          Text('${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿'),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ราคารวมทั้งหมด:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${order['total'].toStringAsFixed(2)} ฿',
                          style: const TextStyle(color: Colors.green)),
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('ที่อยู่: ${order['address']}'),
                const SizedBox(height: 8),
                const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...List<Map<String, dynamic>>.from(order['cartItems']).map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Image.asset(item['imageUrl'], width: 30, height: 30),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${item['name']} (x${item['quantity']})')),
                        Text('${(item['price'] * item['quantity']).toStringAsFixed(2)} ฿'),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Text('จำนวนรวม: $totalItems ชิ้น'),
                Text('ราคารวมทั้งหมด: ${order['total'].toStringAsFixed(2)} ฿'),
                const SizedBox(height: 12),
                Text('สถานะ: ${order['status']}', style: const TextStyle(color: Colors.orange)),
                const SizedBox(height: 12),
                
              ],
            ),
          ),
          actions: [
            if (order['status'] == "กำลังจัดส่ง")
              TextButton(
                onPressed: () {
                  final index = orders.indexOf(order);
                  if (index != -1) {
                    orders[index]['status'] = "จัดส่งสำเร็จ";
                    saveOrders(orders); // อัปเดตสถานะในไฟล์ด้วย
                  }

                  onStatusChanged();
                  Navigator.pop(context);
                },
                child: const Text('ได้รับสินค้าแล้ว',
                    style: TextStyle(color: Color.fromARGB(255, 3, 27, 4))),
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
