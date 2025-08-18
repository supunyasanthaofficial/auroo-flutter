import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../context/Product_Provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_nameController.text.isEmpty || _imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter product name and image URL'),
        ),
      );
      return;
    }
    context.read<ProductProvider>().addProduct(
      Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        price: 3999.0,
        size: ['S', 'M', 'L'],
        colors: ['#000000', '#FFFFFF'],
        thumbnail: _imageController.text,
        imagesByColor: {
          '#000000': _imageController.text,
          '#FFFFFF': _imageController.text,
        },
        description: 'Newly added product',
        rating: 4.0,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontFamily: 'Helvetica'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleAdd,
              child: const Text(
                'Add Product',
                style: TextStyle(fontFamily: 'Helvetica'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
