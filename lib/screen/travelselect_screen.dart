import 'package:flutter/material.dart';
import 'package:pictory/screen/videostyle_screen.dart';
import 'package:pictory/screen/travellist_screen.dart';

// 세 번째 화면 (선택 모드)
class TravelSelectScreen extends StatefulWidget {
  @override
  State<TravelSelectScreen> createState() => _TravelSelectScreenState();
}

class _TravelSelectScreenState extends State<TravelSelectScreen> {
  List<Map<String, String>> trips = TravelListScreen.trips;
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI EDITER')),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, idx) {
          return Card(
            color: selected.contains(idx)
                ? Colors.lightBlue[200]
                : Colors.grey[400],
            child: ListTile(
              leading:
                  Container(width: 40, height: 40, color: Colors.grey[300]),
              title: Text(
                trips[idx]['country'] ?? '',
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
        onPressed: () async {
          // [1] 로딩 중 Alert (3초)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'AI가\n잘나온 사진을\n 선별 중!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );

          await Future.delayed(Duration(seconds: 3));
          Navigator.of(context, rootNavigator: true).pop(); // 닫기

          // [2] 두 번째 메시지 Alert (2초)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              content: Text(
                'AI가 사진을\n다 골랐어요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          );

          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context, rootNavigator: true).pop();

          // [3] Yes/No 선택 Alert
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: SizedBox(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '컨텐츠로\n만들어볼까요?',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StyleSelectorPage()));
                              // YES 동작
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                            ),
                            child: const Text(
                              'YES',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.shade100,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                            ),
                            child: const Text(
                              'NO',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
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
