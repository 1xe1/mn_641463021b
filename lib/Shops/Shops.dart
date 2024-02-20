import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Shops/AddShop.dart';
import 'package:mn_641463021/Shops/ShopD.dart';
import 'package:mn_641463021/Shops/UpdateShop.dart';
import 'package:mn_641463021/menu.dart';

class Shops extends StatefulWidget {
  @override
  _ShopsState createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  List<Map<String, dynamic>> shops = [];
  int _currentSortColumnIndex = 0;
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    final response = await http.get(
      Uri.parse("http://localhost:8081/mn_641463021/Shop/"),
    );

    if (response.statusCode == 200) {
      setState(() {
        shops = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to load shops. Error ${response.statusCode}');
    }
  }

  void navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddShop(),
      ),
    ).then((_) {
      fetchShops();
    });
  }

  void _navigateToDetail(Map<String, dynamic> shop) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ShopDetailPage(shop: shop), // Corrected parameter name to 'shop'
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายการร้านค้า',
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
        body: shops.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  sortColumnIndex: _currentSortColumnIndex,
                  sortAscending: _isSortAscending,
                  columnSpacing: 10,
                  columns: [
                    DataColumn(
                      label: Text('ชื่อร้านค้า'),
                    ),
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
          tooltip: 'เพิ่มร้านค้า',
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
    return shops.map((shop) {
      return DataRow(cells: [
        DataCell(
          Text(
            shop['ShopName'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.preview),
            onPressed: () {
              _navigateToDetail(shop); // Navigate to detail page
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEdit(shop); // Navigate to edit page
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteShop(int.parse(shop['ShopID'].toString())); // Delete shop
            },
          ),
        ),
      ]);
    }).toList();
  }

  Future<void> _deleteShop(int shopID) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8081/mn_641463021/Shop/'),
        body: json.encode({'ShopID': shopID}),
      );

      if (response.statusCode == 200) {
        fetchShops(); // Refresh shops list after deletion
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
                "ลบร้านเรียบร้อย",
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
                "Failed to delete shop. Error ${response.statusCode}",
              ),
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

  void _navigateToEdit(Map<String, dynamic> shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateShop(shop: shop),
      ),
    ).then((_) {
      fetchShops();
    });
  }
}
