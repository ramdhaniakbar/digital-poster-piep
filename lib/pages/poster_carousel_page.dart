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
  bool _imagesReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesReady) {
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    await Future.wait(
      _posters.map((path) => precacheImage(AssetImage(path), context)),
    );
    if (mounted) {
      setState(() => _imagesReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: !_imagesReady
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _posters.length,
              itemBuilder: (context, index) => SizedBox.expand(
                child: Image.asset(
                  _posters[index],
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
    );
  }
}
