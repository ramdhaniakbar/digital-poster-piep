import 'package:flutter/material.dart';

const List<String> _posters = [
  'assets/images/posters/poster_1.png',
  'assets/images/posters/poster_2.png',
  'assets/images/posters/poster_3.png',
];

class PosterCarouselPage extends StatefulWidget {
  const PosterCarouselPage({super.key});

  @override
  State<PosterCarouselPage> createState() => _PosterCarouselPageState();
}

class _PosterCarouselPageState extends State<PosterCarouselPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _posters.length,
            itemBuilder: (context, index) => SizedBox.expand(
              child: Image.asset(_posters[index], fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
