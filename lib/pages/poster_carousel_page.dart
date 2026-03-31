import 'package:flutter/material.dart';

const List<String> _posters = [
  'assets/images/posters/poster_1.png',
  'assets/images/posters/poster_2.png',
  'assets/images/posters/poster_3.png',
];

class PosterCarouselPage extends StatelessWidget {
  const PosterCarouselPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _posters.length,
        itemBuilder: (context, index) => SizedBox.expand(
          child: Image.asset(_posters[index], fit: BoxFit.contain),
        ),
      ),
    );
  }
}
