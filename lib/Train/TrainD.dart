import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463021/Train/Train.dart';

class TrainDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  TrainDetailPage({required this.data});

  @override
  _TrainDetailPageState createState() => _TrainDetailPageState();
}

class _TrainDetailPageState extends State<TrainDetailPage> {
  late TextEditingController trainNumberController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the train number
    trainNumberController = TextEditingController(text: widget.data['TrainNumber'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลรถรางเพิ่มเติม'),
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
                    Icons.train,
                    size: 50,
                    color: Color(0xFF2baf2b),
                  ),
                ),
                buildReadOnlyField('รหัสรถราง', trainNumberController),
                // Add more fields here if needed
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
    trainNumberController.dispose();
    super.dispose();
  }
}
