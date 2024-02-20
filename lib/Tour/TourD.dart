import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TouristAttractionDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  TouristAttractionDetailPage({required this.data});

  @override
  _TouristAttractionDetailPageState createState() => _TouristAttractionDetailPageState();
}

class _TouristAttractionDetailPageState extends State<TouristAttractionDetailPage> {
  late TextEditingController attractionNameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data
    attractionNameController = TextEditingController(text: widget.data['AttractionName'].toString());
    latitudeController = TextEditingController(text: widget.data['Latitude'].toString());
    longitudeController = TextEditingController(text: widget.data['Longitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลสถานที่ท่องเที่ยว'),
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
                    Icons.place,
                    size: 50,
                    color: Color(0xFF2baf2b),
                  ),
                ),
                buildReadOnlyField('ชื่อสถานที่', attractionNameController),
                buildReadOnlyField('ละติจูด', latitudeController),
                buildReadOnlyField('ลองจิจูด', longitudeController),
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
    attractionNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
}
