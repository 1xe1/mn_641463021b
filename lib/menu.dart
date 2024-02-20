import 'package:flutter/material.dart';
import 'package:mn_641463021/GPSTracking/GPSTracking.dart';
import 'package:mn_641463021/Login/Login.dart';
import 'package:mn_641463021/Products/Products.dart';
import 'package:mn_641463021/Route/Route.dart';
import 'package:mn_641463021/Shops/Shops.dart';
import 'package:mn_641463021/Tour/Tour.dart';
import 'package:mn_641463021/Train/Train.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เที่ยวกัน',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ResponsiveMenuGrid(),
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

class ResponsiveMenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Use a smaller grid for narrower screens
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            MenuItem(
              title: 'ร้านค้า',
              icon: Icons.store,
              onTap: () {
                // Add action to navigate to store page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Shops(),
                  ),
                );
              },
              backgroundColor: Colors.green, // สีพื้นหลังสำหรับเมนูร้านค้า
              iconColor: Colors.white, // สีไอคอนสำหรับเมนูร้านค้า
              textColor: Colors.white, // สีข้อความสำหรับเมนูร้านค้า
            ),
            MenuItem(
              title: 'สินค้า',
              icon: Icons.shopping_cart,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Products()),
                );
              },
              backgroundColor: Colors.orange, // สีพื้นหลังสำหรับเมนูสินค้า
              iconColor: Colors.white, // สีไอคอนสำหรับเมนูสินค้า
              textColor: Colors.white, // สีข้อความสำหรับเมนูสินค้า
            ),
            MenuItem(
              title: 'ตารางการเดินรถ',
              icon: Icons.directions_bus,
              onTap: () {
                // Add action to navigate to GPS tracking page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RoutesPage()),
                );
              },
              backgroundColor:
                  Colors.blue, // สีพื้นหลังสำหรับเมนูตารางการเดินรถ
              iconColor: Colors.white, // สีไอคอนสำหรับเมนูตารางการเดินรถ
              textColor: Colors.white, // สีข้อความสำหรับเมนูตารางการเดินรถ
            ),
            MenuItem(
              title: 'สถานที่ท่องเที่ยว',
              icon: Icons.tour_sharp,
              onTap: () {
                // Add action to navigate to health temperature page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Touristattractions()),
                );
              },
              backgroundColor:
                  Colors.red, // สีพื้นหลังสำหรับเมนูสถานที่ท่องเที่ยว
              iconColor: Colors.white, // สีไอคอนสำหรับเมนูสถานที่ท่องเที่ยว
              textColor: Colors.white, // สีข้อความสำหรับเมนูสถานที่ท่องเที่ยว
            ),
            MenuItem(
              title: 'รถ',
              icon: Icons.car_crash_sharp,
              onTap: () {
                // Add action to navigate to GPS tracking page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TrainManagement()),
                );
              },
              backgroundColor: Colors.purple, // สีพื้นหลังสำหรับเมนู GPs
              iconColor: Colors.white, // สีไอคอนสำหรับเมนู GPs
              textColor: Colors.white, // สีข้อความสำหรับเมนู GPs
            ),
            MenuItem(
              title: 'GPs',
              icon: Icons.location_on,
              onTap: () {
                // Add action to navigate to GPS tracking page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GPSTracking()),
                );
              },
              backgroundColor: Colors.purple, // สีพื้นหลังสำหรับเมนู GPs
              iconColor: Colors.white, // สีไอคอนสำหรับเมนู GPs
              textColor: Colors.white, // สีข้อความสำหรับเมนู GPs
            ),
          ],
        );
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.blue, // กำหนดสีพื้นหลังเริ่มต้น
    this.iconColor = Colors.white, // กำหนดสีไอคอนเริ่มต้น
    this.textColor = Colors.white, // กำหนดสีข้อความเริ่มต้น
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: backgroundColor, // กำหนดสีพื้นหลัง
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50.0, color: iconColor), // กำหนดสีไอคอน
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16.0, color: textColor), // กำหนดสีข้อความ
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
