import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'pages/poster_carousel_page.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    win.size = const Size(600, 1000);
    win.minSize = const Size(600, 1000);
    win.maxSize = const Size(600, 1000);
    win.alignment = Alignment.center;
    win.title = "Smart Table";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PosterCarouselPage(),
    );
  }
}
