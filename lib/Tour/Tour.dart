import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Tour/AddTour.dart';
import 'package:mn_641463021/Tour/TourD.dart';
import 'package:mn_641463021/Tour/UpdateTour.dart';
import 'package:mn_641463021/menu.dart';

class Touristattractions extends StatefulWidget {
  @override
  _TouristattractionsState createState() => _TouristattractionsState();
}

class _TouristattractionsState extends State<Touristattractions> {
  List<Map<String, dynamic>> attractions = [];
  int _currentSortColumnIndex = 0;
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchAttractions();
  }

  void _navigateToDetail(Map<String, dynamic> attraction) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TouristAttractionDetailPage(data: attraction),
    ),
  );
}

  Future<void> fetchAttractions() async {
    final response = await http.get(
        Uri.parse("http://localhost:8081/mn_641463021/Touristattractions/"));

    if (response.statusCode == 200) {
      setState(() {
        attractions =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load attractions. Error ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายการสถานที่ท่องเที่ยว',
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
        body: attractions.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortColumnIndex: _currentSortColumnIndex,
                  sortAscending: _isSortAscending,
                  columnSpacing:
                      10, // เพิ่ม property นี้เพื่อกำหนดระยะห่างระหว่างคอลัมน์
                  columns: [
                    DataColumn(
                      label: Text('ชื่อสถานที่'),
                      onSort: (columnIndex, _) {
                        _sort(columnIndex);
                      },
                    ),
                    DataColumn(
                      label: Text('เพิ่มเติม'),
                    ),
                    DataColumn(
                      label: Text('แก้ไข'),
                    ),
                    DataColumn(
                      label: Text('ลบ'),
                    ),
                  ],
                  rows: _createRows(),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: navigateToAdd,
          tooltip: 'เพิ่มสถานที่',
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
    return attractions.map((attraction) {
      return DataRow(cells: [
        DataCell(
          Text(
            attraction['AttractionName'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          IconButton(
  icon: Icon(Icons.preview),
  onPressed: () {
    _navigateToDetail(attraction);
  },
),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit page and pass attraction data
              _navigateToEdit(attraction);
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Call delete function here
              _deleteAttraction(
                  int.parse(attraction['AttractionID'].toString()));
            },
          ),
        ),
      ]);
    }).toList();
  }

  void _sort(int columnIndex) {
    if (columnIndex == _currentSortColumnIndex) {
      setState(() {
        _isSortAscending = !_isSortAscending;
      });
    } else {
      setState(() {
        _currentSortColumnIndex = columnIndex;
        _isSortAscending = true;
      });
    }

    attractions.sort((a, b) {
      if (_isSortAscending) {
        return a.values
            .elementAt(columnIndex)
            .compareTo(b.values.elementAt(columnIndex));
      } else {
        return b.values
            .elementAt(columnIndex)
            .compareTo(a.values.elementAt(columnIndex));
      }
    });
  }

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTouristattractions(),
      ),
    ).then((_) {
      fetchAttractions();
    });
  }

  void _navigateToEdit(Map<String, dynamic> attraction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTouristAttraction(attraction: attraction),
      ),
    ).then((_) {
      fetchAttractions(); // Call fetchAttractions() when updating is completed
    });
  }

  Future<void> _deleteAttraction(int attractionID) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8081/mn_641463021/Touristattractions/'),
        body: json.encode({'AttractionID': attractionID}),
      );

      if (response.statusCode == 200) {
        // Attraction deleted successfully, update UI or show a message
        fetchAttractions(); // Refresh attractions list after deletion
        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Success",
                style: TextStyle(
                  color: Colors.green, // Set text color to green for success
                ),
              ),
              content: Text(
                "ลบสถานที่ท่องเที่ยวเสร็จสมบูรณ์",
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
        // Failed to delete attraction, handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to delete attraction. Error ${response.statusCode}"),
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
