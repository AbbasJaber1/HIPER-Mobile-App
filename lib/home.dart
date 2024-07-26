import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'item.dart'; // Ensure this is defined properly in your project
import 'login_page.dart';
import 'registration_page.dart';
import 'showselected.dart';
import 'about_us_page.dart';
import 'category_page.dart'; // Import the new Category Page

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
  bool _showCategoryFilter = false; // To manage category filter state
  TextEditingController _searchController = TextEditingController();
  List<Item> _filteredItems = [];
  List<Item> _allItems = []; // Store all items for filtering
  int _currentImageIndex = 0;
  Timer? _timer;
  String? _selectedCategory; // Track selected category

  @override
  void initState() {
    super.initState();
    _allItems = items; // Initialize with all items
    _filteredItems = _allItems; // Start with all items
    _searchController.addListener(filterItems);

    Future.delayed(Duration.zero, () {
      _showOptionsBottomSheet(context);
    });

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (_filteredItems.isNotEmpty) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _filteredItems.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(filterItems);
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void filterItems() {
    List<Item> _items = _allItems.where((item) {
      return item.name.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    setState(() {
      _filteredItems = _items;
    });
  }

  void filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredItems = _allItems.where((item) => item.category == category).toList();
      _showCategoryFilter = true; // Show the category filter button
    });
  }

  void removeCategoryFilter() {
    setState(() {
      _selectedCategory = null;
      _filteredItems = _allItems;
      _showCategoryFilter = false; // Hide the category filter button
    });
  }

  void updateSelectedItems() {
    setState(() {
      _sum = _allItems.where((item) => item.selected).fold(0.0, (sum, item) => sum + item.price * item.quantity);
      itemselected = _allItems.where((item) => item.selected).length;
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

  void _showCategoriesBottomSheet(BuildContext context) {
    final categories = _allItems.map((item) => item.category).toSet().toList();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: categories.map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  filterByCategory(category);
                },
              );
            }).toList(),
          ),
        );
      },
    );
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
                  _filteredItems = _allItems;
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
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('Profile'),
              onTap: () {
                _showOptionsBottomSheet(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                _showCategoriesBottomSheet(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()), // Navigate to AboutUsPage
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [

          if (_showCategoryFilter && !_showSelected)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: removeCategoryFilter,
                child: Text('Remove Category Filter'),
              ),
            ),
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
                    child: _filteredItems.isNotEmpty
                        ? Image.network(
                      _filteredItems[_currentImageIndex].image,
                      fit: BoxFit.cover,
                    )
                        : Container(),
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
                  ),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CheckboxListTile(
                            value: _filteredItems[index].selected,
                            onChanged: (e) {
                              setState(() {
                                _filteredItems[index].selected = e ?? false;
                                updateSelectedItems();
                              });
                            },
                            title: Text(
                              _filteredItems[index].toString(),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          Image.network(
                            _filteredItems[index].image,
                            height: 80,
                            width: 80,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Footer(), // The footer widget
              ],
            ),
          ),
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
