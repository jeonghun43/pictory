import 'package:flutter/material.dart';
import 'package:pictory/screen/albumlist_screen.dart';
import 'package:pictory/screen/login_screen.dart';
import 'package:pictory/screen/travellist_screen.dart';
import 'package:pictory/screen/triprecumend_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// 첫 번째 화면
class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentpageIndex;
  final List<Widget> _pages = [
    const TripRecumendPage(),
    AlbumList(),
    TravelListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentpageIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentpageIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentpageIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue.shade100,
        selectedIndex: currentpageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.flight), label: "Recummend"),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Gallerys",
          ),
          NavigationDestination(icon: Icon(Icons.edit_rounded), label: "AI"),
        ],
      ),
    );
  }
}
