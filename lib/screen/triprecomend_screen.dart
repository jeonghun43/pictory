import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Map<String, String> koreanToEnglishMap = {
  '루체른': 'Lucerne, Switzerland',
  '코르시카': 'Corsica, France',
  '안달루시아': 'Andalusia, Spain',
  '유럽': 'Europe',
  '스위스': 'Switzerland',
  '프랑스': 'France',
  '이탈리아': 'Italy',
  '노르웨이': 'Norway',
};

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
      {"role": "user", "content": prompt},
      {
        "role": "system",
        "content":
            "반드시 [지역이름] 형식으로 시작하고 그 뒤에 설명이 이어지는 한 문장으로 답변하세요. 예시: [파리] 에펠탑으로 유명한 프랑스의 로맨틱한 수도"
      }
    ],
    "max_tokens": 100,
    "temperature": 0.7,
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['choices'][0]['message']['content'].toString().trim();
  } else {
    throw Exception('GPT 요청 실패');
  }
}

Future<String?> fetchImage(String place) async {
  await dotenv.load(fileName: 'assets/config/.env');
  WidgetsFlutterBinding.ensureInitialized();
  final accessKey = dotenv.env['JAYS_OPEN_IMAGE_API_KEY']!;
  final mappedPlace = koreanToEnglishMap[place] ?? place;
  final primaryQuery = '$mappedPlace landscape tourism';
  final fallbackQuery = mappedPlace;

  Future<String?> tryQuery(String query) async {
    final url = Uri.parse(
      'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(query)}&orientation=landscape&client_id=$accessKey&per_page=5&content_filter=high',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final results = data['results'];
        return results[Random().nextInt(results.length)]['urls']['regular'];
      }
    }
    return null;
  }

  return await tryQuery(primaryQuery) ?? await tryQuery(fallbackQuery);
}

String getMapUrl(String place) {
  final query = koreanToEnglishMap[place] ?? place;
  return 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
}

String extractPlace(String response) {
  final pattern = RegExp(r'^\[([^\]]+)\]');
  final match = pattern.firstMatch(response);
  if (match != null && match.group(1) != null) {
    return match.group(1)!.trim();
  }
  return "유럽";
}

class TripRecumendPage extends StatefulWidget {
  const TripRecumendPage({super.key});
  @override
  State<TripRecumendPage> createState() => _TripRecumendPageState();
}

class _TripRecumendPageState extends State<TripRecumendPage> {
  String? recommendation;
  String? imageUrl;
  String? mapUrl;
  int step = 0;
  bool isLoading = true;
  bool isTypingMode = false;
  final TextEditingController _controller = TextEditingController();
  String? contextIntro;

  @override
  void initState() {
    super.initState();
    fetchRecommendation();
  }

  String getPrompt() {
    if (isTypingMode) {
      return "${_controller.text.trim()}와 관련된 여행지를 추천해주세요. [지역이름] 형식으로 시작하고 설명을 덧붙여서 한 문장으로 답변해주세요.";
    }
    switch (step) {
      case 0:
        contextIntro = "프랑스를 많이 가셨다면 이런 유럽 여행은 어떠신가요?";
        return "유럽의 덜 알려졌지만 매력적인 여행지를 추천해주세요. [지역이름] 형식으로 시작하고 설명을 덧붙여서 한 문장으로 답변해주세요.";
      case 1:
        contextIntro = "도시 위주의 여행을 즐기셨다면, 자연은 어떠신가요?";
        return "전 세계에서 자연이 아름다운 여행지를 추천해주세요. [지역이름] 형식으로 시작하고 설명을 덧붙여서 한 문장으로 답변해주세요.";
      case 2:
        contextIntro = "프랑스 여행을 많이 하셨다니, 프랑스 한 번 더는 어떠신가요?";
        return "프랑스의 잘 알려지지 않은 여행지를 추천해주세요. [지역이름] 형식으로 시작하고 설명을 덧붙여서 한 문장으로 답변해주세요.";
      default:
        contextIntro = null;
        return "재미있는 여행지를 추천해주세요. [지역이름] 형식으로 시작하고 설명을 덧붙여서 한 문장으로 답변해주세요.";
    }
  }

  void fetchRecommendation() async {
    setState(() {
      isLoading = true;
      imageUrl = null;
      mapUrl = null;
    });

    try {
      final prompt = getPrompt();
      final reply = await fetchFromGPT(prompt);
      final place = extractPlace(reply);
      final image = await fetchImage(place);
      final map = getMapUrl(place);

      setState(() {
        recommendation = reply;
        imageUrl = image;
        mapUrl = map;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        recommendation = '추천 실패 ㅠㅠ';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isTypingMode
            ? const Text(
                '여행지 추천',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : TextField(
                controller: _controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "예) 오로라 볼 수 있는 곳",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    fetchRecommendation();
                  }
                },
              ),
        actions: [
          if (!isTypingMode)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  isTypingMode = true;
                });
              },
              tooltip: '직접 검색하기',
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                setState(() {
                  isTypingMode = false;
                  _controller.clear();
                });
              },
              tooltip: '검색 취소',
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  fetchRecommendation();
                }
              },
              tooltip: '검색',
            ),
          ],
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFF7C3AED),
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3E8FF),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isTypingMode && contextIntro != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            contextIntro!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B46C1),
                            ),
                          ),
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF8B5CF6).withOpacity(0.08),
                              blurRadius: 24,
                              spreadRadius: 0,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (imageUrl != null)
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: 'travel_image',
                                            child: Image.network(
                                              imageUrl!,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.45,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                color: Colors.grey[100],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.2),
                                                  Colors.black.withOpacity(0.6),
                                                ],
                                                stops: const [0.3, 0.7, 1.0],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!isTypingMode)
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: Material(
                                          color: Colors.white.withOpacity(0.95),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          elevation: 4,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            onTap: () {
                                              setState(() {
                                                step++;
                                                step %= 3;
                                              });
                                              fetchRecommendation();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              child: Icon(
                                                Icons.refresh_rounded,
                                                color: Color(0xFF8B5CF6),
                                                size: 26,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      left: 24,
                                      right: 24,
                                      bottom: 24,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recommendation ?? '추천 없음',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              height: 1.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(0, 2),
                                                  blurRadius: 4.0,
                                                  color: Color.fromARGB(
                                                      130, 0, 0, 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (mapUrl != null)
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ElevatedButton.icon(
                                  onPressed: () => launchUrl(
                                    Uri.parse(mapUrl!),
                                    mode: LaunchMode.externalApplication,
                                  ),
                                  icon: const Icon(Icons.map_outlined),
                                  label: const Text(
                                    "구글 지도에서 보기",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 2,
                                    shadowColor:
                                        Color(0xFF10B981).withOpacity(0.4),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart'; // 구글 검색할 경우 대비용
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// // GPT API 호출 함수
// Future<String> fetchFromGPT(String prompt) async {
//   await dotenv.load(fileName: 'assets/config/.env');
//   WidgetsFlutterBinding.ensureInitialized();
//   String? apiKey = dotenv.env['JAYS_OPEN_API_KEY'];
//   String tmpurl = dotenv.env['API_URL']!;
//   final url = Uri.parse(tmpurl);
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $apiKey',
//   };

//   final body = jsonEncode({
//     "model": "gpt-3.5-turbo",
//     "messages": [
//       {"role": "user", "content": prompt}
//     ],
//     "max_tokens": 100,
//     "temperature": 0.8,
//   });

//   final response = await http.post(url, headers: headers, body: body);

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     final reply = data['choices'][0]['message']['content'];
//     return reply;
//   } else {
//     print('실패 코드: ${response.statusCode}');
//     print(response.body);
//     throw Exception('GPT 추천 실패 ㅠㅠ');
//   }
// }

// class TripRecumendPage extends StatefulWidget {
//   const TripRecumendPage({super.key});

//   @override
//   State<TripRecumendPage> createState() => _TripRecumendPageState();
// }

// class _TripRecumendPageState extends State<TripRecumendPage> {
//   String? recommendation;
//   int step = 0;
//   bool isLoading = true;
//   bool isTypingMode = false;
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchTripFromGPT(); // 첫 추천 자동 호출
//   }

//   String getPrompt() {
//     if (isTypingMode) {
//       return "Recommend me a travel destination related to '${_controller.text}'. Just one sentence.";
//     }

//     switch (step) {
//       case 0:
//         return "Recommend me a European travel destination. Just one sentence.";
//       case 1:
//         return "I've been to Europe many times. Recommend me a place with beautiful nature. Just one sentence.";
//       case 2:
//         return "I've been to many European countries. Suggest a new route or city in a familiar country. Just one sentence.";
//       default:
//         return "Stop recommending. Just give me one travel-related keyword.";
//     }
//   }

//   void fetchTripFromGPT() async {
//     final prompt = getPrompt();
//     try {
//       final reply = await fetchFromGPT(prompt);
//       setState(() {
//         recommendation = reply;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         recommendation = 'GPT 추천 실패 ㅠㅠ';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final searchUrl = recommendation != null
//         ? 'https://www.google.com/search?q=${Uri.encodeComponent(recommendation!)}'
//         : null;

//     return Scaffold(
//       appBar: AppBar(title: const Text('GPT 여행지 추천')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     recommendation ?? '추천 없음',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontFamilyFallback: [
//                         'NotoSansKR',
//                         'Apple SD Gothic Neo',
//                         'sans-serif'
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (!isTypingMode) ...[
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           step++;
//                           isLoading = true;
//                         });
//                         fetchTripFromGPT();
//                       },
//                       child: const Text("마음에 안 들어요 😐"),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           isTypingMode = true;
//                         });
//                       },
//                       child: const Text("직접 검색어 입력할래요"),
//                     ),
//                   ] else ...[
//                     TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                         hintText: "예: 오로라 볼 수 있는 곳",
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           isLoading = true;
//                         });
//                         fetchTripFromGPT();
//                       },
//                       child: const Text("GPT한테 물어보기"),
//                     ),
//                   ],
//                   const SizedBox(height: 20),
//                   if (searchUrl != null)
//                     TextButton(
//                       onPressed: () {
//                         launchUrl(Uri.parse(searchUrl));
//                       },
//                       child: const Text("구글에서 더 알아보기 🔍"),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
