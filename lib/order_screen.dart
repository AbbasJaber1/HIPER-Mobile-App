import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'item.dart'; // Assuming you have an Item class

class OrderScreen extends StatefulWidget {
  final String userEmail;
  final List<Item> selectedItems;

  const OrderScreen({Key? key, required this.userEmail, required this.selectedItems}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> sendOrderEmail(String phone, String location) async {
    String username = 'abbasjaber9090@gmail.com';
    String password = '81076902abbas'; // Use an app-specific password or OAuth2 tokens
    final smtpServer = gmail(username, password);

    final orderDetails = widget.selectedItems.map((item) {
      return '${item.name} - Quantity: ${item.quantity} - Price: ${item.price}';
    }).join('\n');

    final message = Message()
      ..from = Address(username, 'Order App')
      ..recipients.add('abbasjaber9090@gmail.com')
      ..subject = 'New Order from Flutter App'
      ..text = 'Phone Number: $phone\n'
          'Location: $location\n\n'
          'Order Details:\n$orderDetails';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  void _placeOrder() {
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();

    if (phone.isEmpty || location.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter both phone number and delivery location.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Handle the order placement logic here
    print('Order placed by: ${widget.userEmail}');
    print('Phone: $phone');
    print('Delivery Location: $location');

    // Send the email
    sendOrderEmail(phone, location);

    Navigator.pop(context); // Optionally navigate back or show a success message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('Order Now'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your phone number:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Phone number',
                prefixIcon: Icon(Icons.phone),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Enter delivery location:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Delivery location',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900], // Background color
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
