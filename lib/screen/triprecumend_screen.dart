import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // 구글 검색할 경우 대비용
import 'package:flutter_dotenv/flutter_dotenv.dart';

// GPT API 호출 함수
Future<String> fetchFromGPT(String prompt) async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  String? apiKey = dotenv.env['JAYS_OPEN_API_KEY'];
  String tmpurl = dotenv.env['API_URL']!;
  final url = Uri.parse(tmpurl);
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": [
      {"role": "user", "content": prompt}
    ],
    "max_tokens": 100,
    "temperature": 0.8,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final reply = data['choices'][0]['message']['content'];
    return reply;
  } else {
    print('실패 코드: ${response.statusCode}');
    print(response.body);
    throw Exception('GPT 추천 실패 ㅠㅠ');
  }
}

class TripRecumendPage extends StatefulWidget {
  const TripRecumendPage({super.key});

  @override
  State<TripRecumendPage> createState() => _TripRecumendPageState();
}

class _TripRecumendPageState extends State<TripRecumendPage> {
  String? recommendation;
  int step = 0;
  bool isLoading = true;
  bool isTypingMode = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTripFromGPT(); // 첫 추천 자동 호출
  }

  String getPrompt() {
    if (isTypingMode) {
      return "Recommend me a travel destination related to '${_controller.text}'. Just one sentence.";
    }

    switch (step) {
      case 0:
        return "Recommend me a European travel destination. Just one sentence.";
      case 1:
        return "I've been to Europe many times. Recommend me a place with beautiful nature. Just one sentence.";
      case 2:
        return "I've been to many European countries. Suggest a new route or city in a familiar country. Just one sentence.";
      default:
        return "Stop recommending. Just give me one travel-related keyword.";
    }
  }

  void fetchTripFromGPT() async {
    final prompt = getPrompt();
    try {
      final reply = await fetchFromGPT(prompt);
      setState(() {
        recommendation = reply;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        recommendation = 'GPT 추천 실패 ㅠㅠ';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchUrl = recommendation != null
        ? 'https://www.google.com/search?q=${Uri.encodeComponent(recommendation!)}'
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('GPT 여행지 추천')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    recommendation ?? '추천 없음',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamilyFallback: [
                        'NotoSansKR',
                        'Apple SD Gothic Neo',
                        'sans-serif'
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isTypingMode) ...[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          step++;
                          isLoading = true;
                        });
                        fetchTripFromGPT();
                      },
                      child: const Text("마음에 안 들어요 😐"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isTypingMode = true;
                        });
                      },
                      child: const Text("직접 검색어 입력할래요"),
                    ),
                  ] else ...[
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "예: 오로라 볼 수 있는 곳",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        fetchTripFromGPT();
                      },
                      child: const Text("GPT한테 물어보기"),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (searchUrl != null)
                    TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse(searchUrl));
                      },
                      child: const Text("구글에서 더 알아보기 🔍"),
                    ),
                ],
              ),
      ),
    );
  }
}
