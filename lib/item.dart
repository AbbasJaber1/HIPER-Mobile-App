import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Item {
  final String _name;
  final double _price;
  bool _selected = false;
  final String _image;
  int _quantity = 1;
  String category;

  Item(this._name, this._price, this._image, this.category);

  // getters and setters
  String get name => _name;
  double get price => _price;
  bool get selected => _selected;
  String get image => _image;
  int get quantity => _quantity;
  set selected(bool e) => _selected = e;
  set quantity(int qty) => _quantity = qty;

  // factory constructor for creating an instance of Item from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['name'],
      double.parse(json['price']),
      json['image_url'],
      json['category'],
    );
  }

  // item description is displayed in the ListView
  @override
  String toString() {
    String space = ''; // loop computes spaces between price and name
    for (int i = 0; i < 3 - _price.toString().length; i++) {
      space += ' ';
    }
    return 'Price: \$$_price $space$_name';
  }
}

final List<Item> items = [];

void getProducts() async {
  print("getProducts is called");  // Confirm function entry
  try {
    var url = Uri.http('hipermobile.atwebpages.com', '/getProduct.php');
    var response = await http.get(url);
    print("HTTP Status: ${response.statusCode}");  // Log the HTTP status

    if (response.statusCode == 200) {
      print("Response Body: ${response.body}");  // Log the response body
      var jsonResponse = convert.jsonDecode(response.body) as List;
      items.clear();
      for (var product in jsonResponse) {
        Item item = Item.fromJson(product);
        items.add(item);
      }
      print("Items loaded: ${items.length}");  // Confirm items have been added
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  } catch (e, stackTrace) {
    print("An error occurred: $e");
    print("Stack Trace: $stackTrace");  // Print the stack trace for more details
  }
}
