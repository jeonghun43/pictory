// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  final List<String> countries = [
    'France',
    'Italy',
    'Switzerland',
    'England',
    'Japan',
    'USA',
    'Spain'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
                child: Text(
              'Recummend trip area is making ...',
            )),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                '당신의 여행기록을\nAI가 정리했어요!',
                style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: countries
                      .map((country) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _CountryCard(country: country),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
                child: Text(
              'AI EDIT SERVICE is making ...',
            )),
          ),
        ),
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
      // 오른쪽 아래 버튼 (예: 여행 리스트로 이동)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TravelListScreen()),
          );
        },
        child: Icon(Icons.list),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _CountryCard extends StatelessWidget {
  final String country;
  const _CountryCard({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(color: Colors.grey[300], height: 70, width: 100),
          SizedBox(height: 8),
          Text(country, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 두 번째 화면
class TravelListScreen extends StatelessWidget {
  final List<String> countries = [
    'France',
    'Italy',
    'Switzerland',
    'England',
    'Japan',
    'USA',
    'Spain'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI EDITER')),
      body: ListView(
        children: countries.map((country) {
          return Card(
            color: Colors.cyan[100],
            child: ListTile(
              leading:
                  Container(width: 40, height: 40, color: Colors.grey[300]),
              title: Text(
                country,
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('24.12.03 ~ 24.12.16'),
            ),
          );
        }).toList(),
      ),
      // + 버튼 (선택 모드로 이동)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TravelSelectScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// 세 번째 화면 (선택 모드)
class TravelSelectScreen extends StatefulWidget {
  @override
  State<TravelSelectScreen> createState() => _TravelSelectScreenState();
}

class _TravelSelectScreenState extends State<TravelSelectScreen> {
  final List<String> countries = [
    'France',
    'Italy',
    'Switzerland',
    'England',
    'Japan',
    'USA',
    'Spain'
  ];
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI EDITER')),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, idx) {
          return Card(
            color: Colors.grey[400],
            child: ListTile(
              leading:
                  Container(width: 40, height: 40, color: Colors.grey[300]),
              title: Text(
                countries[idx],
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('24.12.03 ~ 24.12.16'),
              trailing: Checkbox(
                value: selected.contains(idx),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selected.add(idx);
                    } else {
                      selected.remove(idx);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
      // 예시로 Play 버튼 추가
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // 선택된 항목 처리
        },
        icon: Icon(Icons.play_arrow),
        label: Text('Play'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
