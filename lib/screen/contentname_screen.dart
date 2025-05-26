import 'package:flutter/material.dart';
import 'package:pictory/screen/travellist_screen.dart';
import 'package:pictory/main.dart';

class ContentNamePage extends StatefulWidget {
  const ContentNamePage({super.key});

  @override
  State<ContentNamePage> createState() => _ContentNamePageState();
}

class _ContentNamePageState extends State<ContentNamePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI EDITER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '컨텐츠 이름을 정해주세요!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      TravelListScreen.trips.insert(0, {
                        'country': _controller.text + " VIDEO BY AI",
                        'date': '20250527', // 혹은 원하는 기본값
                      });
                      if (_controller.text.trim().isNotEmpty) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(initialIndex: 2),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('완료'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
