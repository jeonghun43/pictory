import 'package:flutter/material.dart';
import 'package:pictory/screen/travelselect_screen.dart';

// 두 번째 화면
class TravelListScreen extends StatelessWidget {
  final List<Map<String, String>> trips = [
    {'country': 'France', 'date': '22.12.03 ~ 22.12.16'},
    {'country': 'Italy', 'date': '23.01.23 ~ 23.01.30'},
    {'country': 'Switzerland', 'date': '23.07.01 ~ 23.07.15'},
    {'country': 'England', 'date': '23.08.15 ~ 23.08.31'},
    {'country': 'Japan', 'date': '24.01.17 ~ 24.01.23'},
    {'country': 'USA', 'date': '24.02.03 ~ 24.02.16'},
    {'country': 'Spain', 'date': '24.12.25 ~ 24.12.31'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI EDITER')),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: trips.map((trip) {
          return Card(
            color: Colors.cyan[100],
            child: ListTile(
              leading:
                  Container(width: 40, height: 40, color: Colors.grey[300]),
              title: Text(
                trip['country']!,
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(trip['date']!),
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
