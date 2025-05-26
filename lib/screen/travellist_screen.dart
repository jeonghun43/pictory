import 'package:flutter/material.dart';
import 'package:pictory/data/world.dart';
import 'package:pictory/screen/videostyle_screen.dart';

// 두 번째 화면
class TravelListScreen extends StatefulWidget {
  static List<Map<String, String>> trips = World.trips;
  TravelListScreen({super.key});
  @override
  State<TravelListScreen> createState() => _TravelListScreenState();
}

class _TravelListScreenState extends State<TravelListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredTrips = [];

  @override
  void initState() {
    super.initState();
    filteredTrips = TravelListScreen.trips;
  }

  void _filterTrips(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTrips = TravelListScreen.trips;
      } else {
        filteredTrips = TravelListScreen.trips
            .where((trip) =>
                trip['country']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // 나라 선택 시 실행될 함수
  void _onCountrySelect(
      BuildContext context, Map<String, String> selectedTrip) async {
    // TODO: 여기에 실제 구현 코드 추가

    // [1] 로딩 중 Alert (2초)
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

    await Future.delayed(Duration(seconds: 2));
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

    await Future.delayed(Duration(seconds: 1));
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
                                builder: (context) => StyleSelectorPage()));
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
  }

  // 여행지별 기본 이미지 매핑
  final Map<String, String> defaultImages = {
    'France': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
    'Italy': 'https://images.unsplash.com/photo-1529260830199-42c24126f198',
    'Switzerland':
        'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99',
    'England': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad',
    'Japan': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e',
    'USA': 'https://images.unsplash.com/photo-1485738422979-f5c462d49f74',
    'Spain': 'https://images.unsplash.com/photo-1543783207-ec64e4d95325',
  };

  String getDefaultImage(String country) {
    return defaultImages[country] ??
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.shade300,
                  Colors.pink.shade200,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    title: const Text('AI EDITER'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white,
                            const Color(0xFFF8F9FA),
                          ],
                          stops: const [0.0, 0.8, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.5,
                            offset: const Offset(-1, -1),
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 0.3,
                            offset: const Offset(1, 1),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Colors.grey.shade100,
                              Colors.grey.shade200,
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterTrips,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: '나라 이름으로 검색...',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.orange.shade300,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                return GestureDetector(
                  onTap: () => _onCountrySelect(context, trip),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image:
                              NetworkImage(getDefaultImage(trip['country']!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip['country']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trip['date']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
