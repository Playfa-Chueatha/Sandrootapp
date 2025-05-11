import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Listorder_buyer extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String orderNumber;
  final double total;
  final String address;
  final String status;

  const Listorder_buyer({
    super.key,
    required this.orderNumber, 
    required this.cartItems,
    required this.total,
    required this.address,
    required this.status, 
  });

  @override
  State<Listorder_buyer> createState() => _Listorder_buyerState();
}

class _Listorder_buyerState extends State<Listorder_buyer> with TickerProviderStateMixin {
  List<dynamic> orders = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadOrderData();
  }

  Future<void> loadOrderData() async {
    // 1. โหลดจากไฟล์ก่อน
    String jsonData = await rootBundle.loadString('assets/data/order_data.json');
    List<dynamic> loaded = json.decode(jsonData);

    // 2. สร้าง map ของ order ใหม่จาก widget properties
    final newOrder = {
      'orderNumber': widget.orderNumber,
      'cartItems': widget.cartItems,
      'total': widget.total,
      'address': widget.address,
      'status': widget.status,
    };

    setState(() {
      // 3. เอาของเก่าและของใหม่มารวมกัน
      orders = [newOrder, ...loaded];
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, orders.last); 
            },
          ),
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
        body: orders.isEmpty
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
          onTap: () => showOrderDetailDialog(context, order),
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('สถานะ: ${order['status']}', style: const TextStyle(color: Colors.orange)),
                  const SizedBox(height: 8),
                  Text(
                    'ที่อยู่จัดส่ง: ${order['address']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                          Expanded(
                            child: Text('${item['name']} (x${item['quantity']})'),
                          ),
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
                      Text('${order['total'].toStringAsFixed(2)} ฿', style: const TextStyle(color: Colors.green)),
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

  void showOrderDetailDialog(BuildContext context, dynamic order) {
    int totalItems = List<Map<String, dynamic>>.from(order['cartItems'])
        .fold(0, (sum, item) => item['quantity'] + sum);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
          actions: [
            if (order['status'] == "กำลังจัดส่ง")
              TextButton(
                onPressed: () {
                  setState(() {
                    order['status'] = "จัดส่งสำเร็จ";
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'ได้รับสินค้าแล้ว',
                  style: TextStyle(color: Colors.green),
                ),
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
