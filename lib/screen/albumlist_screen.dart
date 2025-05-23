import 'package:flutter/material.dart';
import 'countrycard.dart';

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
                        child: CountryCard(country: country),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
