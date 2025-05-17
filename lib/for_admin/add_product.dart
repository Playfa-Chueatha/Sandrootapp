import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:sandy_roots/services/CategoryListPage.dart';
import 'package:sandy_roots/services/category_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;

  File? _imageFile;

  
  List<String> get categories => CategoryManager.instance.categories;
  String? selectedCategory;
  TextEditingController searchCategoryCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _descCtrl = TextEditingController();

    CategoryManager.instance.loadCategories().then((_) {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    searchCategoryCtrl.dispose();
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

    showModalBottomSheet(
      backgroundColor: Color(0xFFf6f3ec),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        List<String> filteredCategories = categories;

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
                        icon: Icon(Icons.add),
                        onPressed: addNewCategory,
                      ),
                    ),
                    onChanged: filterCategories,
                  ),
                  SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: filteredCategories.isEmpty
                        ? Text('ไม่พบหมวดหมู่')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final cat = filteredCategories[index];
                              return ListTile(
                                title: Text(cat),
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
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveProduct() {
    String name = _nameCtrl.text.trim();
    String price = _priceCtrl.text.trim();
    String category = selectedCategory ?? '';
    String description = _descCtrl.text.trim();

    if (name.isEmpty || price.isEmpty || category.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกสินค้าเรียบร้อย')),
    );

    Navigator.pop(context, {
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'image': _imageFile?.path ?? 'assets/images/default_sandyroot.png',
    });
  }

  Future<void> addNewCategory() async {
    final newCat = searchCategoryCtrl.text.trim();

    
    if (newCat.isNotEmpty && !CategoryManager.instance.categories.contains(newCat)) {      
      await CategoryManager.instance.addCategory(newCat);

      
      setState(() {
        selectedCategory = newCat;
      });

      
      Navigator.pop(context);
    }
  }




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFf6f3ec),
      appBar: AppBar(  
        backgroundColor: Color(0xFFf6f3ec),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Products',
          style: TextStyle(
              fontSize: 30
          )),
        actions: [
          // IconButton(
          //     icon: const Icon(Icons.list),
          //     tooltip: 'ดูหมวดหมู่ทั้งหมด',
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const CategoryListPage()),
          //       );
          //     },
          //   ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProduct,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipOval(
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/default_sandyroot.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
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
            SizedBox(height: screenHeight * 0.05),
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
    );
  }
}
