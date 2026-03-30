import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';

import 'pages/poster_carousel_page.dart';

const MethodChannel _windowChannel = MethodChannel('app.window');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  doWhenWindowReady(() async {
    final win = appWindow;
    const initialSize = Size(2160, 3840);
    const minimumSize = Size(2160, 3840);
    win.size = initialSize;
    win.minSize = minimumSize;
    win.alignment = Alignment.center;
    win.title = "Smart Table";
    win.show();

    if (Platform.isWindows) {
      try {
        await _windowChannel.invokeMethod<bool>('setFullscreen', true);
      } on PlatformException {
        // Ignore and keep the regular resizable window if the runner API fails.
      }
    }
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
