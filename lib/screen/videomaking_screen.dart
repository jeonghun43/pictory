import 'package:flutter/material.dart';

class VideoMaking extends StatefulWidget {
  String style;
  VideoMaking({super.key, required this.style});
  @override
  State<VideoMaking> createState() => _VideoMakingState();
}

class _VideoMakingState extends State<VideoMaking> {
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
      body: Center(
          child: Column(
        children: [Text("${widget.style} 스타일로 영상 제작중 . . .")],
      )),
    );
  }
}
