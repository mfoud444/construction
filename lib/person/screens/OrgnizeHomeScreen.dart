import 'package:construction/common/colors.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/person/screens/OrgnizeDetailsScreen.dart';
import 'package:flutter/material.dart';

class RestaurantHomeScreen extends StatefulWidget {
  final Organize restaurant;

  const RestaurantHomeScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  _RestaurantHomeScreenState createState() =>
      _RestaurantHomeScreenState(restaurant: restaurant);
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  final Organize restaurant;
  _RestaurantHomeScreenState({required this.restaurant});

  late int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      OrgnizeDetailsScreen(orgnize: restaurant),
    ];

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text(restaurant.name.toString())),
        body: Builder(builder: (context) {
          return Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: appColor,
          selectedItemColor: secondaryColor,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Restaurant',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Post ',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
