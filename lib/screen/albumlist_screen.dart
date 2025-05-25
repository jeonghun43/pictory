import 'package:flutter/material.dart';
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
  final List<String> countries = [
    'France',
    'Italy',
    'Switzerland',
    'England',
    'Japan',
    'USA',
    'Spain'
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            '당신의 여행기록을\nAI가 정리했어요!',
            style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: countries
                  .map((country) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CountryPhotoListPage(
                                              country: country,
                                              photoList:
                                                  countryPhotos[country] ??
                                                      [])));
                            },
                            child: CountryCard(country: country)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
