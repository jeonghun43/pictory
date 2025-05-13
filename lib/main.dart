// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

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
class HomeScreen extends StatelessWidget {
  final List<String> countries = [
    'France',
    'Italy',
    'Switzerland',
    'England',
    'Japan',
    'Daejeon',
    'Seoul'
  ];

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
                      content: Text('로그인 되었습니다',textAlign: TextAlign.center,),
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
      body: SafeArea(
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

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
                }, // 홈화면으로 되돌아가기
                child: Text('로그인')
            )

          ],
        ),
      ),
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
    'Daejeon',
    'Seoul'
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
    'Daejeon',
    'Seoul'
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
            color: selected.contains(idx) ? Colors.lightBlue[200] : Colors.grey[400],
            child: ListTile(
              leading: Container(width: 40, height: 40, color: Colors.grey[300]),
              title: Text(
                countries[idx],
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
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

// void main() {
//   runApp(const Homepage());
// }

// class Homepage extends StatelessWidget {
//   const Homepage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomepageState();
// }

// class _HomepageState extends State<HomeScreen> {
//   final countries = [
//     'France',
//     'Italy',
//     'England',
//     'USA',
//     'BlaBla1',
//     'BlaBla2',
//     'BlaBla3'
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Text("hello"),
//           SizedBox(
//             height: 400,
//             child: ListView.builder(
//               // shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemCount: countries.length,
//               itemBuilder: (context, index) {
//                 return CountryCard(
//                   country: countries[index],
//                 );
//               },
//             ),
//           ),
//           Text("world!"),
//         ],
//       ),
//     );
//   }
// }

// class CountryCard extends StatelessWidget {
//   final String country;
//   const CountryCard({super.key, required this.country});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150,
//       width: 150,
//       decoration: BoxDecoration(
//           color: Colors.grey, borderRadius: BorderRadius.circular(0.5)),
//       child: Column(
//         children: [
//           SizedBox(),
//           Text(
//             country,
//           )
//         ],
//       ),
//     );
//   }
// }
