import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Train/AddTrain.dart';
import 'package:mn_641463021/Train/TrainD.dart';
import 'package:mn_641463021/Train/UpdateTrain.dart';
import 'package:mn_641463021/menu.dart';

class TrainManagement extends StatefulWidget {
  @override
  _TrainManagementState createState() => _TrainManagementState();
}

class _TrainManagementState extends State<TrainManagement> {
  List<Map<String, dynamic>> trains = [];
  int _currentSortColumnIndex = 0;
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchTrains();
  }

  Future<void> fetchTrains() async {
    final response = await http.get(
      Uri.parse("http://localhost:8081/mn_641463021/Train/"),
    );

    if (response.statusCode == 200) {
      setState(() {
        trains = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load trains. Error ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายการรถ',
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
      body: trains.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortColumnIndex: _currentSortColumnIndex,
                sortAscending: _isSortAscending,
                columnSpacing: 10,
                columns: [
                  DataColumn(
                    label: Text('TrainNumber'),
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
        tooltip: 'เพิ่มรถ',
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
    );
  }

  List<DataRow> _createRows() {
    return trains.map((train) {
      return DataRow(cells: [
        DataCell(
          Text(
            train['TrainNumber'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.preview),
            onPressed: () {
              _navigateToDetail(train);
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEdit(train);
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteTrain(int.parse(train['TrainID'].toString()));
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

    trains.sort((a, b) {
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
        builder: (context) => AddTrain(),
      ),
    ).then((_) {
      fetchTrains();
    });
  }

  void _navigateToEdit(Map<String, dynamic> train) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTrain(train: train),
      ),
    ).then((_) {
      fetchTrains();
    });
  }

  void _navigateToDetail(Map<String, dynamic> train) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TrainDetailPage(data: train),
    ),
  );
}


  Future<void> _deleteTrain(int trainID) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8081/mn_641463021/Train/'),
        body: json.encode({'TrainID': trainID}),
      );

      if (response.statusCode == 200) {
        fetchTrains();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Success",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              content: Text(
                "ลบรถเสร็จสมบูรณ์",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to delete train. Error ${response.statusCode}"),
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
      print('Error: $e');
    }
  }
}
