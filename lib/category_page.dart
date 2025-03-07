import 'package:flutter/material.dart';
import 'item.dart';

class CategoryPage extends StatelessWidget {
  final List<String> categories;

  const CategoryPage({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Colors.red[900],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryItemsPage(category: categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryItemsPage extends StatelessWidget {
  final String category;

  const CategoryItemsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<Item> categoryItems = items.where((item) => item.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.red[900],
      ),
      body: categoryItems.isEmpty
          ? Center(
        child: Text(
          'No products in this category.',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      )
          : ListView.builder(
        itemCount: categoryItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: ListTile(
              leading: Image.network(categoryItems[index].image),
              title: Text(categoryItems[index].name),
              subtitle: Text('\$${categoryItems[index].price}'),
            ),
          );
        },
      ),
    );
  }
}
