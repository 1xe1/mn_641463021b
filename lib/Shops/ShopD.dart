import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopDetailPage extends StatefulWidget {
  final Map<String, dynamic> shop;

  ShopDetailPage({required this.shop});

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late TextEditingController shopNameController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data
    shopNameController = TextEditingController(text: widget.shop['ShopName'].toString());
    statusController = TextEditingController(text: widget.shop['statusDelete'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดร้านค้า'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.store,
                    size: 50,
                    color: Color(0xFF2baf2b),
                  ),
                ),
                buildReadOnlyField('ชื่อร้านค้า', shopNameController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                  child: Text('กลับ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReadOnlyField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  @override
  void dispose() {
    shopNameController.dispose();
    statusController.dispose();
    super.dispose();
  }
}
