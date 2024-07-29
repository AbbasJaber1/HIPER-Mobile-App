import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class AddProductPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  Future<void> _addProduct(BuildContext context) async {
    final String name = _nameController.text;
    final String price = _priceController.text;
    final String imageUrl = _imageUrlController.text;
    final String category = _categoryController.text;
    final String token = _tokenController.text;

    if (name.isEmpty || price.isEmpty || imageUrl.isEmpty || category.isEmpty || token.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill out all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://hipermobile.atwebpages.com/add_product.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'price': double.parse(price),
        'image_url': imageUrl,
        'category': category,
        'token': token,
      }),
    );

    final responseData = json.decode(response.body);

    if (responseData['success']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Product added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Pop the AddProductPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      _nameController.clear();
      _priceController.clear();
      _imageUrlController.clear();
      _categoryController.clear();
      _tokenController.clear();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(responseData['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                ),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _tokenController,
                decoration: InputDecoration(
                  labelText: 'Token',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addProduct(context),
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
