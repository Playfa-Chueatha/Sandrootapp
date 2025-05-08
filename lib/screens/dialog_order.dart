import 'package:flutter/material.dart';
import 'package:sandy_roots/screens/OrderScreen.dart';

class dialog_order extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;


  final void Function(Product updated) onSave;

  const dialog_order({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.onSave,
  });

  @override
  State<dialog_order> createState() => _dialog_orderState();
}

class _dialog_orderState extends State<dialog_order> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: widget.name);
    _priceCtrl = TextEditingController(text: widget.price.toString());
    _descCtrl = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('แก้ไขสินค้า'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
  
            ClipOval(
              child: Image.asset(
                widget.imageUrl.isNotEmpty ? widget.imageUrl : 'assets/images/default_sandyroot.png',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'ชื่อสินค้า',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

  
            TextFormField(
              controller: _priceCtrl,
              decoration: const InputDecoration(
                labelText: 'ราคา (฿)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),


            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'รายละเอียด',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ยกเลิก'),
        ),
   
        ElevatedButton(
          onPressed: () {
           
            final updated = Product(
              id: widget.id,
              name: _nameCtrl.text,
              price: int.tryParse(_priceCtrl.text) ?? widget.price,
              description: _descCtrl.text,
              imageUrl: widget.imageUrl,
            );
            widget.onSave(updated);
            Navigator.of(context).pop();
          },
          child: const Text('บันทึก'),
        ),
      ],
    );
  }
}
