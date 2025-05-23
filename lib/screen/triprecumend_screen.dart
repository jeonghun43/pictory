import 'package:flutter/material.dart';

class TripRecumendPage extends StatefulWidget {
  const TripRecumendPage({super.key});

  @override
  State<TripRecumendPage> createState() => _TripRecumendPageState();
}

class _TripRecumendPageState extends State<TripRecumendPage> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
            child: Text(
          'Recummend trip area is making ...',
        )),
      ),
    );
  }
}
