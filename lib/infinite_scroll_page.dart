import 'package:flutter/material.dart';

class InfiniteScrollPage extends StatelessWidget {
  const InfiniteScrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Page'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final imageIndex = index % 5;
          return Image.asset('images/image$imageIndex.jpg');
        },
      ),
    );
  }
}
