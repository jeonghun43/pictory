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
        title: const Text('AI EDITER'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              '어떤 스타일을\n원하시나요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              // 스크롤 가능한 그리드 리스트
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
          ],
        ),
      ),
    );
  }
}
