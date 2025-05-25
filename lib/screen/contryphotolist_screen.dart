import 'package:flutter/material.dart';

class CountryPhotoListPage extends StatelessWidget {
  final String country;
  final List<String> photoList;

  const CountryPhotoListPage({
    super.key,
    required this.country,
    required this.photoList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$country의 사진들'),
      ),
      body: photoList.isEmpty
          ? const Center(child: Text('사진이 없습니다.'))
          : ListView.builder(
              itemCount: photoList.length,
              itemBuilder: (context, index) {
                final photoPath = photoList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        photoPath,
                        fit: BoxFit.fitHeight,
                        // fit: BoxFit.cover,
                        width: double.infinity,
                        height: 1000,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(child: Text('이미지 없음')),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
