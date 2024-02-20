import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Route/AddRoute.dart';
import 'package:mn_641463021/Route/RouteD.dart';
import 'package:mn_641463021/Route/UpdateRoute.dart';
import 'package:mn_641463021/menu.dart';

class RoutesPage extends StatefulWidget {
  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  List<Map<String, dynamic>> routes = [];

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }
  void _navigateToDetail(Map<String, dynamic> route) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RouteDetailPage(route: route), // Corrected parameter name to 'shop'
    ),
  );
}

  Future<void> fetchRoutes() async {
    final response = await http.get(
        Uri.parse("http://localhost:8081/mn_641463021/Route/"));

    if (response.statusCode == 200) {
      setState(() {
        routes = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load routes. Error ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายการเส้นทาง',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Menu(),
                ),
              );
            },
          ),
        ),
        body: routes.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                
                child: DataTable(
                  columnSpacing:
                      10, 
                  columns: [
                    DataColumn(
                      label: Text('สถานที่'),
                    ),
                    DataColumn(label: Text('เวลา')),
                    DataColumn(label: Text('เพิ่มเติม')),
                    DataColumn(label: Text('แก้ไข')),
                    DataColumn(label: Text('ลบ')),
                  ],
                  rows: _createRows(),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: navigateToAdd,
          tooltip: 'เพิ่มเส้นทาง',
          child: Icon(Icons.add),
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
      ),
    );
  }

  List<DataRow> _createRows() {
    return routes.map((route) {
      return DataRow(cells: [
        DataCell(
          Text(
            route['AttractionName'] ?? '', // Add null check
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(route['Time'] ?? '')), // Add null check
        DataCell(
          IconButton(
            icon: Icon(Icons.preview),
            onPressed: () {
              _navigateToDetail(route); // Navigate to detail page
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEdit(route); // Pass the route data to the edit page
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteRoute(int.parse(route['RouteID'].toString()));
            },
          ),
        ),
      ]);
    }).toList();
  }

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRoute(),
      ),
    ).then((_) {
      fetchRoutes();
    });
  }

  void _navigateToEdit(Map<String, dynamic> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateRoute(route: route),
      ),
    ).then((_) {
      fetchRoutes(); // Call fetchRoutes() when updating is completed
    });
  }

  Future<void> _deleteRoute(int routeID) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8081/mn_641463021/Route/'),
        body: json.encode({'RouteID': routeID}),
      );

      if (response.statusCode == 200) {
        // Route deleted successfully, update UI or show a message
        fetchRoutes(); // Refresh routes list after deletion
        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "เรียบร้อย",
                style: TextStyle(
                  color: Colors.green, // Set text color to green for success
                ),
              ),
              content: Text(
                "ลบเส้นทางเสร็จสมบูรณ์",
                style: TextStyle(
                  fontSize: 18.0, // Increase font size for better readability
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors
                          .green, // Match text color with title for consistency
                      fontSize:
                          16.0, // Match font size with content for consistency
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Failed to delete route, handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to delete route. Error ${response.statusCode}"),
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
      // Handle any exceptions
      print('Error: $e');
    }
  }
}
