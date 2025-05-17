import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandy_roots/Data/data_Product.dart';
import 'package:sandy_roots/services/category_provider.dart';

class dialog_order extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final String category;
  final void Function(Product updated) onSave;
  final void Function(int id) onDelete;  

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
  String? selectedCategory;
  TextEditingController searchCategoryCtrl = TextEditingController();
  List<String> get categories => CategoryManager.instance.categories;


  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _priceCtrl = TextEditingController(text: widget.price.toString());
    _descCtrl = TextEditingController(text: widget.description);
    _catCtrl = TextEditingController(text: widget.category);
    selectedCategory = widget.category;
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

  void _showCategorySelector() {
  searchCategoryCtrl.clear();

  final ScrollController scrollController = ScrollController();

  showModalBottomSheet(
    backgroundColor: const Color(0xFFf6f3ec),
    context: context,
    isScrollControlled: true,
    builder: (context) {
      List<String> filteredCategories = categories;

      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = filteredCategories.indexOf(selectedCategory ?? '');
        if (index >= 0 && scrollController.hasClients) {
          scrollController.jumpTo(index * 56.0);
        }
      });

      return StatefulBuilder(
        builder: (context, setModalState) {
          void filterCategories(String query) {
            final filtered = categories.where((cat) =>
              cat.toLowerCase().contains(query.toLowerCase())
            ).toList();
            setModalState(() {
              filteredCategories = filtered;
            });
          }

          void addNewCategory() {
            final newCat = searchCategoryCtrl.text.trim();
            if (newCat.isNotEmpty && !CategoryManager.instance.categories.contains(newCat)) {
              setState(() {
                CategoryManager.instance.addCategory(newCat);
                selectedCategory = newCat;
              });
              Navigator.pop(context);
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchCategoryCtrl,
                  decoration: InputDecoration(
                    labelText: 'ค้นหาหมวดหมู่ หรือ เพิ่มใหม่',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: addNewCategory,
                    ),
                  ),
                  onChanged: filterCategories,
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: filteredCategories.isEmpty
                      ? const Text('ไม่พบหมวดหมู่')
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            final cat = filteredCategories[index];
                            final isSelected = cat == selectedCategory;

                            return ListTile(
                              title: Text(
                                cat,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.brown : Colors.black,
                                ),
                              ),
                              tileColor: isSelected ? Colors.brown.withOpacity(0.1) : null,
                              onTap: () {
                                setState(() {
                                  selectedCategory = cat;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      backgroundColor: Color(0xFFf6f3ec),
      title: const Text('Edit Products'),
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

            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'ชื่อสินค้า',
                  hintText: 'ชื่อสินค้า',
                  hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _priceCtrl,
                decoration: InputDecoration(
                  labelText: 'ราคา',
                  border: InputBorder.none,
                  hintText: 'ราคา (฿)',
                  hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: InkWell(
                onTap: _showCategorySelector,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCategory ?? 'เลือกหมวดหมู่',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedCategory == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            

            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFf6f3ec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'รายละเอียด',
                  hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                ),
                maxLines: 3,
              ),
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
          child: const Text('ยกเลิก',style: TextStyle(color: Colors.black),),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = Product(
              id: widget.id,
              name: _nameCtrl.text,
              price: int.tryParse(_priceCtrl.text) ?? widget.price,
              description: _descCtrl.text,
              imageUrl: _imageFile?.path ?? widget.imageUrl,
              category: selectedCategory ?? '',
            );
            widget.onSave(updated);
            Navigator.of(context).pop();
          },
          child: const Text('บันทึก',style: TextStyle(color: Colors.green),),
        ),
      ],
    );
  }
}
