import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'item.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'showselected.dart';
import 'about_us_page.dart';
import 'add_product.dart';
import 'category_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _sum = 0.0;
  int itemselected = 0;
  bool _showSelected = false;
  bool _showSearch = false;
  TextEditingController _searchController = TextEditingController();
  List<Item> _filteredItems = [];
  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _filteredItems = items;
    _searchController.addListener(filterItems);

    _checkLoginStatus();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _filteredItems.length;
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null) {
      Future.delayed(Duration.zero, () {
        _showOptionsBottomSheet(context);
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(filterItems);
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void filterItems() {
    List<Item> _items = items.where((item) {
      return item.name.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    setState(() {
      _filteredItems = _items;
    });
  }

  void updateSelectedItems() {
    setState(() {
      _sum = items.where((item) => item.selected).fold(0.0, (sum, item) => sum + item.price * item.quantity);
      itemselected = items.where((item) => item.selected).length;
    });
  }

  void returnToHome() {
    setState(() {
      _showSelected = false;
    });
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Register'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Login'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Continue as Guest'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Add any logic for guest user if needed
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<String>> fetchCategoriesFromDatabase() async {
    final response = await http.get(Uri.parse('http://hipermobile.atwebpages.com/get_categories.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((category) => category.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      screenWidth = screenWidth * 0.8;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: _showSearch
            ? Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showSearch = false;
                  _searchController.clear();
                  _filteredItems = items;
                });
              },
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Image.asset(
                  'assets/cropped-hiperao.png',
                  height: 30,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _showSearch = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    _showOptionsBottomSheet(context);
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.black),
                      onPressed: () {
                        if (_sum != 0) {
                          setState(() {
                            _showSelected = !_showSelected;
                          });
                        }
                        // Handle the cart button press
                      },
                    ),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.black,
                        child: Text(
                          '$itemselected', // Update this number dynamically
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[900],
              ),
              child: Image.asset(
                'assets/cropped-hiperao.png',
                height: 30,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF92271E)),
              title: Text('Profile'),
              onTap: () {
                _showOptionsBottomSheet(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: Color(0xFF92271E)),
              title: Text('Categories'),
              onTap: () async {
                List<String> categories = await fetchCategoriesFromDatabase();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(categories: categories),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Color(0xFF92271E)),
              title: Text('About us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add, color: Color(0xFF92271E)),
              title: Text('Add Product'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _showSelected
                ? ShowSelectedItems(
              width: screenWidth,
              updateSelectedItems: updateSelectedItems,
              returnToHome: returnToHome,
            )
                : _filteredItems.isEmpty
                ? Center(
              child: Text(
                'Product not found',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            )
                : ListView(
              children: [
                SizedBox(
                  height: 140, // Height of your SizedBox
                  child: Center(
                    child: Image.network(
                      _filteredItems[_currentImageIndex].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 2.6 / 4, // Adjust aspect ratio to your preference
                  ),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AspectRatio(
                            aspectRatio: 1, // Keeps the image square
                            child: Image.network(
                              _filteredItems[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              value: _filteredItems[index].selected,
                              onChanged: (e) {
                                setState(() {
                                  _filteredItems[index].selected = e as bool;
                                  updateSelectedItems();
                                });
                              },
                              title: Text(
                                _filteredItems[index].name, // Assuming `name` is a property of `Item`
                                style: TextStyle(fontSize: 18.0),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                "\$${_filteredItems[index].price.toStringAsFixed(2)}", // Price display, formatted
                                style: TextStyle(fontSize: 15.0, color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Footer(), // The footer widget
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.5),
      color: Colors.red[900],
      child: Column(
        children: [
          Text(
            'Contact Us: - +961 81 605 882 // - +961 81 076 902',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.phone, color: Colors.black),
                onPressed: () {
                  // Handle phone button press
                },
              ),
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.black),
                onPressed: () {
                  // Handle Facebook button press
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.black),
                onPressed: () {
                  // Handle WhatsApp button press
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.black),
                onPressed: () {
                  // Handle Instagram button press
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

