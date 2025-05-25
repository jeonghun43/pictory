import 'package:flutter/material.dart';
import 'package:pictory/screen/contentname_screen.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPage extends StatelessWidget {
  final String thumbnailPath;
  final String videoUrl;

  const VideoPreviewPage({
    super.key,
    required this.thumbnailPath,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 16),
              child: Text(
                'AI EDITER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 9 / 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          thumbnailPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FullScreenVideoPage(videoUrl: videoUrl),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 36,
                          ),
                        ),
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

// 전체화면 영상 재생 페이지
class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPage({super.key, required this.videoUrl});

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });
    _controller.setLooping(false); // 영상 반복 안 함

    // 영상 종료 감지 리스너 추가
    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    // 영상이 끝났는지 확인
    if (_controller.value.position >= _controller.value.duration &&
        !_isVideoEnded) {
      setState(() {
        _isVideoEnded = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        Positioned(
                          bottom: 40,
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Colors.white,
                              backgroundColor: Colors.white24,
                              bufferedColor: Colors.white54,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          right: 40,
                          child: IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  if (_isVideoEnded) {
                                    _controller.seekTo(Duration.zero);
                                    _isVideoEnded = false;
                                  }
                                  _controller.play();
                                }
                              });
                            },
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 32),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                },
              ),
            ),
            // 영상이 끝났을 때만 save 버튼 표시
            if (_isVideoEnded)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // 저장 기능 구현
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContentNamePage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      'save',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
