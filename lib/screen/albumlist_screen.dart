import 'package:flutter/material.dart';
import 'package:pictory/data/world.dart';
import 'package:pictory/screen/contryphotolist_screen.dart';
import 'countrycard.dart';

final Map<String, List<String>> countryPhotos = {
  'France': [
    'images/france1.jpg',
    'images/france2.jpg',
  ],
  // 'Italy': [
  //   'assets/italy1.jpg',
  //   'assets/italy2.jpg',
  // ],
  // 'Switzerland': [
  //   'assets/switzerland1.jpg',
  //   'assets/switzerland2.jpg',
  //   'assets/switzerland3.jpg',
  //   'assets/switzerland4.jpg',
  // ],
  // 'England': [
  //   'assets/england1.jpg',
  // ],z
  // 'Japan': [
  //   'assets/japan1.jpg',
  //   'assets/japan2.jpg',
  //   'assets/japan3.jpg',
  // ],
  // 'USA': [
  //   'assets/usa1.jpg',
  //   'assets/usa2.jpg',
  // ],
  // 'Spain': [
  //   'assets/spain1.jpg',
  //   'assets/spain2.jpg',
  //   'assets/spain3.jpg',
  // ],
};

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  List<String> countries = World.trips.map((trip) => trip['country']!).toList();

  // 여행지별 기본 이미지 매핑
  final Map<String, String> defaultImages = {
    'France': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
    'Italy': 'https://images.unsplash.com/photo-1529260830199-42c24126f198',
    'Switzerland':
        'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99',
    'England': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad',
    'Japan': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e',
    'USA': 'https://images.unsplash.com/photo-1485738422979-f5c462d49f74',
    'Spain': 'https://images.unsplash.com/photo-1543783207-ec64e4d95325',
  };

  String getDefaultImage(String country) {
    return defaultImages[country] ??
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            '당신의 여행기록을\nAI가 정리했어요!',
            style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: countries
                  .map((country) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryPhotoListPage(
                                  country: country,
                                  photoList: countryPhotos[country] ?? [],
                                ),
                              ),
                            );
                          },
                          child: CountryCard(
                            country: country,
                            imageUrl: getDefaultImage(country),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
