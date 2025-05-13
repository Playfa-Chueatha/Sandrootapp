import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Listorder extends StatefulWidget {
  const Listorder({super.key});

  @override
  State<Listorder> createState() => _ListorderState();
}

class _ListorderState extends State<Listorder> with TickerProviderStateMixin {
  List<dynamic> orders = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    loadOrderData();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> loadOrderData() async {
    String jsonData = await rootBundle.loadString('assets/data/order_data.json');
    setState(() {
      orders = List.from(json.decode(jsonData));  // โหลดข้อมูลจาก JSON
    });
  }

  List<dynamic> filterOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  void showOrderDetailDialog(BuildContext context, dynamic order, VoidCallback onStatusUpdated) {
    int totalItems = List<Map<String, dynamic>>.from(order['cartItems'])
        .fold(0, (sum, item) => item['quantity'] + sum);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: const EdgeInsets.all(16),
        content: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('คำสั่งซื้อที่ ${order['orderNumber'] ?? "-"}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('ที่อยู่: ${order['address']}'),
                    const SizedBox(height: 12),
                    const Text('รายการสินค้า:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ...List<Map<String, dynamic>>.from(order['cartItems']).map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                    const SizedBox(height: 20),
                    if (order['status'] == 'รอการจัดส่ง') 
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            order['status'] = 'กำลังจัดส่ง'; 
                            Navigator.pop(context); 
                            onStatusUpdated(); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('จัดส่งสินค้า'),
                        ),
                      ),
                      
                  ],
                ),
              ),
            ),
            
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
}
