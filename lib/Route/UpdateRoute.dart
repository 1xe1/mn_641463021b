import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'dart:convert';

import 'package:mn_641463021/menu.dart';

class UpdateRoute extends StatefulWidget {
  final Map<String, dynamic> route;

  UpdateRoute({required this.route});

  @override
  _UpdateRouteState createState() => _UpdateRouteState();
}

class _UpdateRouteState extends State<UpdateRoute> {
  final TextEditingController _attractionIDController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now(); // Add default time

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _attractionIDController.text = widget.route['AttractionID'];
    // Parse time string to TimeOfDay
    List<String> timeComponents = widget.route['Time'].split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);
    _selectedTime = TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> submitForm(BuildContext context) async {
    final String attractionID = _attractionIDController.text;

    try {
      final String apiUrl = "http://localhost:8081/mn_641463021/Route/";
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'RouteID': widget.route['RouteID'],
          'AttractionID': attractionID,
          'Time': '${_selectedTime.hour}:${_selectedTime.minute}', // Convert TimeOfDay to string
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to update route. Error ${response.statusCode}"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Error submitting form: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Route',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _attractionIDController,
                decoration: InputDecoration(labelText: 'Attraction ID'),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Time'),
                subtitle: Text('${_selectedTime.hour}:${_selectedTime.minute}'),
                onTap: () {
                  _selectTime(context);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  submitForm(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu_rounded),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Menu()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              color: Colors.white,
              onPressed: () {
                // Add action to manage user info
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
