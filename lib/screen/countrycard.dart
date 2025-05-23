import 'package:flutter/material.dart';

class CountryCard extends StatelessWidget {
  final String country;

  const CountryCard({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(color: Colors.grey[300], height: 70, width: 100),
          SizedBox(height: 8),
          Text(country, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
