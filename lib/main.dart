import 'package:flutter/material.dart';
import 'package:pictory/screen/albumlist_screen.dart';
import 'package:pictory/screen/login_screen.dart';
import 'package:pictory/screen/travellist_screen.dart';
import 'package:pictory/screen/triprecumend_screen.dart';
import 'package:pictory/screen/videostyle_screen.dart';

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
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentpageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PICTORY'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );

              // Future.delayed로 딜레이 줘야 context 안정됨
              if (result == true) {
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      content: Text(
                        '로그인 되었습니다',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                });
              }
            },
          )
        ],
      ),
      body: <Widget>[
        TripRecumendPage(),
        AlbumList(),
        TravelListScreen(),
      ][currentpageIndex],
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
          ]),
    );
  }
}
