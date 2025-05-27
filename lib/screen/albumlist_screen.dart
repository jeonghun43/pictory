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
  List<String> filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCountries = List.from(countries);
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = List.from(countries);
      } else {
        filteredCountries = countries
            .where((country) =>
                country.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFF7C3AED),
                  Color(0xFF4C1D95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    title: const Text(
                      '앨범',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterCountries,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: '나라 이름으로 검색...',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          filled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Color(0xFF614385),
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: Colors.grey[400]),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterCountries('');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '당신의 여행기록을\nAI가 정리했어요!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${filteredCountries.length}개의 여행지',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: filteredCountries.map((country) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 220,
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
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
