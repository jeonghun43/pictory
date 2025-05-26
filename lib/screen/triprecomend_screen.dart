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
      {"role": "system", "content": "장소 이름 + 짧은 설명 형태로, 한 문장으로만 한국어로 대답하세요."}
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
  final matches = RegExp(r"(?:[는은이의] )?([가-힣a-zA-Z]{2,20})[은는이가의]")
      .allMatches(response)
      .map((m) => m.group(1))
      .where((e) => e != null && e!.length > 1)
      .toList();
  return matches.isNotEmpty ? matches.last! : "유럽";
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
  String? contextIntro;
  int step = 0;
  bool isLoading = true;
  bool isTypingMode = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecommendation();
  }

  String getPrompt() {
    if (isTypingMode) {
      return "${_controller.text.trim()} 장소 하나만 간단히 추천 + 짧은 설명. 한 문장. 한국어.";
    }
    switch (step) {
      case 0:
        contextIntro = "프랑스를 많이 가셨다면 이런 유럽 여행은 어떠신가요?";
        return "유럽의 덜 알려졌지만 매력적인 여행지 한 곳을 장소 + 짧은 설명 형태로 한 문장으로 추천해주세요. 한국어로.";
      case 1:
        contextIntro = "도시 위주의 여행을 즐기셨다면, 자연은 어떠신가요?";
        return "유럽에서 자연이 아름다운 여행지 한 곳을 장소 + 짧은 설명 형태로 한 문장으로 추천해주세요. 한국어로.";
      case 2:
        contextIntro = "프랑스 여행을 많이 하셨다니, 프랑스 한 번 더는 어떠신가요?";
        return "프랑스의 잘 알려지지 않은 여행지 중 하나를 장소 + 짧은 설명 형태로 한 문장으로 추천해주세요. 한국어로.";
      default:
        contextIntro = null;
        return "재미있는 여행지 한 곳을 장소 + 짧은 설명 형태로 한 문장으로 추천해주세요. 한국어로.";
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
      appBar: AppBar(title: const Text('여행지 추천')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (contextIntro != null)
                      Text(
                        contextIntro!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      recommendation ?? '추천 없음',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Text('사진을 불러오지 못했습니다'),
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (mapUrl != null)
                      TextButton(
                        onPressed: () => launchUrl(Uri.parse(mapUrl!)),
                        child: const Text("구글 지도에서 보기 🗺️"),
                      ),
                    const SizedBox(height: 20),
                    if (!isTypingMode) ...[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            step++;
                          });
                          fetchRecommendation();
                        },
                        child: const Text("다른 추천 보기 🔁"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isTypingMode = true;
                          });
                        },
                        child: const Text("직접 검색하기 ✍️"),
                      ),
                    ] else ...[
                      TextField(
                        controller: _controller,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          hintText: "예) 오로라 볼 수 있는 곳",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchRecommendation,
                        child: const Text("추천 받기 🚀"),
                      ),
                    ]
                  ],
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
