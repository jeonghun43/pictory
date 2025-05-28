import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pictory/firebase_options.dart';
import 'package:pictory/screen/albumlist_screen.dart';
import 'package:pictory/screen/login_screen.dart';
import 'package:pictory/screen/travellist_screen.dart';
import 'package:pictory/screen/triprecomend_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// 첫 번째 화면
class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({this.initialIndex = 1, super.key});

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
      appBar: AppBar(
        backgroundColor: Color(0xFF8B5CF6),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B5CF6), // 밝은 보라색
                Color(0xFF7C3AED), // 중간 보라색
                Color(0xFF4C1D95), // 진한 보라색
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          icon: Icon(
            Icons.login,
            color: Colors.white,
          ),
          style: IconButton.styleFrom(
            highlightColor: Colors.white.withOpacity(0.2),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentpageIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B5CF6),
              Color(0xFF7C3AED),
              Color(0xFF4C1D95),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          child: NavigationBar(
            height: 70,
            onDestinationSelected: (int index) {
              setState(() {
                currentpageIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            indicatorColor: Color(0xFFE9D5FF).withOpacity(0.2),
            selectedIndex: currentpageIndex,
            animationDuration: Duration(milliseconds: 800),
            destinations: <Widget>[
              NavigationDestination(
                icon: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: currentpageIndex == 0 ? 0.0 : 1.0,
                      child: Icon(Icons.flight_takeoff_outlined,
                          color: Colors.white70),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: currentpageIndex == 0 ? 1.0 : 0.0,
                      child: Icon(Icons.flight_takeoff, color: Colors.white),
                    ),
                  ],
                ),
                label: "Recommend",
              ),
              NavigationDestination(
                icon: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: currentpageIndex == 1 ? 0.0 : 1.0,
                      child: Icon(Icons.photo_library_outlined,
                          color: Colors.white70),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: currentpageIndex == 1 ? 1.0 : 0.0,
                      child: Icon(Icons.photo_library, color: Colors.white),
                    ),
                  ],
                ),
                label: "Gallery",
              ),
              NavigationDestination(
                icon: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: currentpageIndex == 2 ? 0.0 : 1.0,
                      child: Icon(Icons.auto_awesome_outlined,
                          color: Colors.white70),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: currentpageIndex == 2 ? 1.0 : 0.0,
                      child: Icon(Icons.auto_awesome, color: Colors.white),
                    ),
                  ],
                ),
                label: "AI Editor",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
