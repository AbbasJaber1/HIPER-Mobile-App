import 'package:flutter/material.dart';
import 'item.dart';
import 'order_screen.dart';

class ShowSelectedItems extends StatefulWidget {
  final double width;
  final Function updateSelectedItems;
  final Function returnToHome;

  const ShowSelectedItems({
    Key? key,
    required this.width,
    required this.updateSelectedItems,
    required this.returnToHome,
  }) : super(key: key);

  @override
  _ShowSelectedItemsState createState() => _ShowSelectedItemsState();
}

class _ShowSelectedItemsState extends State<ShowSelectedItems> {
  List<Item> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selectedItems list
    for (var e in items) {
      if (e.selected) {
        selectedItems.add(e);
      }
    }
  }

  void _removeItem(int index) {
    setState(() {
      selectedItems[index].selected = false;
      selectedItems.removeAt(index);
    });
    widget.updateSelectedItems();
  }

  void _updateQuantity(int index, int quantity) {
    setState(() {
      selectedItems[index].quantity = quantity;
    });
    widget.updateSelectedItems();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = selectedItems.fold(
        0.0, (sum, item) => sum + item.price * item.quantity);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(selectedItems: selectedItems, userEmail: 'abbasmoulla68@gmail.com'), // Pass the selected items and user email
                    ),
                  );
                },
                child: const Text('Order Now'),
              ),
              const SizedBox(width: 10), // Add spacing between the buttons
              ElevatedButton(
                onPressed: () {
                  // Remember to add the function of this button
                },
                child: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
              ),
              const SizedBox(width: 10), // Add spacing between the buttons
              ElevatedButton(
                onPressed: () {
                  // Return to home logic
                  widget.returnToHome();
                },
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: (widget.width / 200), // This will make the height 100 pixels
            ),
            itemCount: selectedItems.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 200, // Set the height of the card to 100 pixels
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedItems[index].name,
                            style: const TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeItem(index);
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Image.network(
                          selectedItems[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity:'),
                          DropdownButton<int>(
                            value: selectedItems[index].quantity,
                            items: List.generate(
                              10,
                                  (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                _updateQuantity(index, value);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
