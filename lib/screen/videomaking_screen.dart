import 'package:flutter/material.dart';
import 'package:pictory/screen/videoplay.dart';

class VideoMaking extends StatefulWidget {
  final String style;
  const VideoMaking({super.key, required this.style});

  @override
  State<VideoMaking> createState() => _VideoMakingState();
}

class _VideoMakingState extends State<VideoMaking> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isCompleted = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewPage(
              thumbnailPath: "images/thumbnail.jpg",
              videoUrl: "assets/ex.mp4",
            ),
          ),
        );
      });
    });
  }

  Widget buildCompletedUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 48,
          color: Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 16),
        Text(
          "영상 제작 완료!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  Widget buildLoadingUI(String style) {
    switch (style.toLowerCase()) {
      case '진격의 거인':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_creation, size: 40, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              "피로 물든 진격의 거인 모드 ON\n영상 콘텐츠를 렌더링 중...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                color: Colors.redAccent,
                backgroundColor: Colors.red.withOpacity(0.2),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        );
      case '감성':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_satisfied_alt, size: 40, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              "노을 아래서\n기억을 담고 있어요...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: Colors.orange,
                backgroundColor: Colors.orange.withOpacity(0.2),
                strokeWidth: 4,
              ),
            ),
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 40, color: Color(0xFF8B5CF6)),
            const SizedBox(height: 16),
            Text(
              "${widget.style} 스타일로\n영상 제작 중...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: Color(0xFF8B5CF6),
                backgroundColor: Color(0xFF8B5CF6).withOpacity(0.2),
                strokeWidth: 4,
              ),
            ),
          ],
        );
    }
  }

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF3E8FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 산 모양 배경
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: MountainClipper(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF8B5CF6).withOpacity(0.1),
                        Color(0xFF7C3AED).withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8B5CF6).withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isCompleted
                              ? buildCompletedUI()
                              : buildLoadingUI(widget.style),
                          if (!isCompleted) ...[
                            SizedBox(height: 16),
                            Text(
                              "잠시만 기다려주세요",
                              style: TextStyle(
                                color: Color(0xFF7C3AED).withOpacity(0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 산 모양을 그리는 CustomClipper
class MountainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);

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
