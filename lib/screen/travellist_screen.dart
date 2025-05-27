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
  Set<int> selectedIndices = {}; // 선택된 아이템들의 인덱스를 저장

  @override
  void initState() {
    super.initState();
    filteredTrips = List.from(TravelListScreen.trips);
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

  // 아이템 선택 토글 함수
  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  // 선택된 아이템들로 비디오 만들기
  void _createVideoWithSelected() {
    List<Map<String, String>> selectedTrips =
        selectedIndices.map((index) => filteredTrips[index]).toList();

    // 첫 번째 선택된 아이템으로 _onCountrySelect 실행
    if (selectedTrips.isNotEmpty) {
      _onCountrySelect(context, selectedTrips[0]);
    }

    // 선택 초기화
    setState(() {
      selectedIndices.clear();
    });
  }

  // 나라 선택 시 실행될 함수
  void _onCountrySelect(
      BuildContext context, Map<String, String> selectedTrip) async {
    // 선택된 모든 나라 이름 가져오기
    List<String> selectedCountries = selectedIndices
        .map((index) => filteredTrips[index]['country']!)
        .toList();
    String countriesText = selectedCountries.join(', ');

    // [1] 로딩 중 Alert (2초)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 280,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6), // 밝은 보라색
                  Color(0xFF7C3AED), // 중간 보라색
                  Color(0xFF4C1D95), // 진한 보라색
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 산 모양 배경
                Positioned(
                  bottom: -24,
                  left: -24,
                  right: -24,
                  child: ClipPath(
                    clipper: MountainClipper(),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                  ),
                ),
                // 컨텐츠
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '$countriesText에서 찍은 것 중\nAI가 잘 나온 사진을\n선별 중!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context, rootNavigator: true).pop();

    // [2] 두 번째 메시지 Alert (2초)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 280,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6), // 밝은 보라색
                  Color(0xFF7C3AED), // 중간 보라색
                  Color(0xFF4C1D95), // 진한 보라색
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 산 모양 배경
                Positioned(
                  bottom: -24,
                  left: -24,
                  right: -24,
                  child: ClipPath(
                    clipper: MountainClipper(),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                  ),
                ),
                // 컨텐츠
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'AI가 사진을\n다 골랐어요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context, rootNavigator: true).pop();

    // [3] Yes/No 선택 Alert
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 280,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6), // 밝은 보라색
                  Color(0xFF7C3AED), // 중간 보라색
                  Color(0xFF4C1D95), // 진한 보라색
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 산 모양 배경
                Positioned(
                  bottom: -24,
                  left: -24,
                  right: -24,
                  child: ClipPath(
                    clipper: MountainClipper(),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                  ),
                ),
                // 컨텐츠
                SizedBox(
                  width: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '컨텐츠로\n만들어볼까요?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StyleSelectorPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF614385),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'YES',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'NO',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  // 삭제 함수 추가
  void _deleteTrip(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('삭제 확인'),
          content: const Text('이 여행 기록을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String countryToDelete = filteredTrips[index]['country']!;
                  // 원본 리스트에서 삭제
                  TravelListScreen.trips.removeWhere(
                      (trip) => trip['country'] == countryToDelete);
                  // 필터된 리스트에서도 삭제
                  filteredTrips.removeAt(index);
                });
                Navigator.of(context).pop();

                // 삭제 완료 스낵바 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('여행 기록이 삭제되었습니다'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6), // 밝은 보라색
                  Color(0xFF7C3AED), // 중간 보라색
                  Color(0xFF4C1D95), // 진한 보라색
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    title: const Text(
                      'AI EDITER',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      if (selectedIndices.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ElevatedButton.icon(
                            onPressed: _createVideoWithSelected,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('앨범에서 사진 선별'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF614385),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "앨범을 선택하세요(다중 선택 가능) AI가 잘 나온 사진을 선별해드립니다",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                  onTap: () => _toggleSelection(index), // 선택 토글로 변경
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: selectedIndices.contains(index)
                                ? Border.all(color: Color(0xFF8B5CF6), width: 3)
                                : null,
                            image: DecorationImage(
                              image: NetworkImage(
                                  getDefaultImage(trip['country']!)),
                              fit: BoxFit.cover,
                              colorFilter: selectedIndices.contains(index)
                                  ? ColorFilter.mode(
                                      Colors.white.withOpacity(0.8),
                                      BlendMode.lighten,
                                    )
                                  : null,
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    trip['date']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 삭제 버튼
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => _deleteTrip(index),
                            tooltip: '삭제',
                          ),
                        ),
                      ),
                    ],
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

// 산 모양을 그리는 CustomClipper
class MountainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height); // 시작점 (왼쪽 하단)

    // 첫 번째 산
    path.lineTo(size.width * 0.25, size.height * 0.4);

    // 두 번째 산
    path.lineTo(size.width * 0.5, size.height * 0.7);

    // 세 번째 산
    path.lineTo(size.width * 0.75, size.height * 0.3);

    // 오른쪽 끝
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
