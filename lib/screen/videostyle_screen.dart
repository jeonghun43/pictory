import 'package:flutter/material.dart';
import 'package:pictory/screen/videomaking_screen.dart';

void main() {
  runApp(StyleSelectorPage());
}

class StyleSelectorPage extends StatelessWidget {
  // 스타일 리스트 데이터
  final List<Map<String, String>> styles = [
    {
      'title': '일반',
      'image': 'images/generative.png', // 실제 이미지 경로로 변경
    },
    {
      'title': '지브리',
      'image': 'images/zbry.png',
    },
    {
      'title': '감성',
      'image': 'images/emotional.png',
    },
    {
      'title': '진격의 거인',
      'image': 'images/jingyeok.png',
    },
    {
      'title': '마인크래프트',
      'image': 'images/minecraft.jpg',
    },
    {
      'title': '흑백',
      'image': 'images/nocolor.jpg',
    },
    {
      'title': '필름카메라',
      'image': 'images/film.jpg',
    },
    {
      'title': '빈티지',
      'image': 'images/vintage.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI EDITER',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
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
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
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
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '어떤 스타일을\n원하시나요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: GridView.builder(
                itemCount: styles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2열 그리드
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1, // 정사각형 비율
                ),
                itemBuilder: (context, index) {
                  final style = styles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoMaking(
                                    style: style['title']!,
                                  )));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              style['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          style['title']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
