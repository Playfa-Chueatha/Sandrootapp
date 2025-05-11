import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandy_roots/data.dart';

class dialog_order extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String category;
  final void Function(Product updated) onSave;
  final void Function(int id) onDelete;  // เพิ่ม callback ลบ

  const dialog_order({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<dialog_order> createState() => _dialog_orderState();
}

class _dialog_orderState extends State<dialog_order> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _catCtrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _priceCtrl = TextEditingController(text: widget.price.toString());
    _descCtrl = TextEditingController(text: widget.description);
    _catCtrl = TextEditingController(text: widget.category);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _catCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: const Text('แก้ไขสินค้า'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipOval(
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          widget.imageUrl.isNotEmpty
                              ? widget.imageUrl
                              : 'assets/images/default_sandyroot.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
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
              controller: _catCtrl,
              decoration: const InputDecoration(
                labelText: 'หมวดหมู่',
                border: OutlineInputBorder(),
              ),
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
            // เรียก callback ลบสินค้า
            widget.onDelete(widget.id);
            Navigator.of(context).pop();
          },
          child: const Text(
            'ลบ',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = Product(
              id: widget.id,
              name: _nameCtrl.text,
              price: int.tryParse(_priceCtrl.text) ?? widget.price,
              description: _descCtrl.text,
              imageUrl: _imageFile?.path ?? widget.imageUrl,
              category: _catCtrl.text,
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
