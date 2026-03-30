import 'dart:async';
import 'package:flutter/material.dart';

const List<String> _posters = [
  'assets/images/posters/poster_1.png',
  'assets/images/posters/poster_2.png',
  'assets/images/posters/poster_3.png',
];

const _autoSlideDuration = Duration(seconds: 4);

class PosterCarouselPage extends StatefulWidget {
  const PosterCarouselPage({super.key});

  @override
  State<PosterCarouselPage> createState() => _PosterCarouselPageState();
}

class _PosterCarouselPageState extends State<PosterCarouselPage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _progressController;
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  bool get _isFirst => _currentIndex == 0;
  bool get _isLast => _currentIndex == _posters.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: _autoSlideDuration,
    );
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    if (_isLast) {
      _progressController.stop();
      _progressController.reset();
      return;
    }

    _progressController.forward(from: 0);
    _autoSlideTimer = Timer(_autoSlideDuration, _goNext);
  }

  void _resetAutoSlide() {
    _autoSlideTimer?.cancel();
    _startAutoSlide();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _goPrev() {
    if (_isFirst) {
      return;
    }

    _goToPage(_currentIndex - 1);
  }

  void _goNext() {
    if (_isLast) {
      return;
    }

    _goToPage(_currentIndex + 1);
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
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _resetAutoSlide();
            },
            itemBuilder: (context, index) => SizedBox.expand(
              child: Image.asset(_posters[index], fit: BoxFit.contain),
            ),
          ),
          Positioned(
            right: 90,
            bottom: 13,
            child: _NavButtons(
              isPrevDisabled: _isFirst,
              isNextDisabled: _isLast,
              onHome: () => _goToPage(0),
              onPrev: _goPrev,
              onNext: _goNext,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (_, child) => LinearProgressIndicator(
                value: _progressController.value,
                minHeight: 3,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons({
    required this.isPrevDisabled,
    required this.isNextDisabled,
    required this.onHome,
    required this.onPrev,
    required this.onNext,
  });

  final bool isPrevDisabled;
  final bool isNextDisabled;
  final VoidCallback onHome;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavArrow(
          icon: Icons.chevron_left_rounded,
          onTap: onPrev,
          disabled: isPrevDisabled,
        ),
        const SizedBox(width: 10),
        _NavArrow(
          icon: Icons.home_rounded,
          onTap: onHome,
          backgroundColor: const Color(0xFFDE3A3A),
        ),
        const SizedBox(width: 10),
        _NavArrow(
          icon: Icons.chevron_right_rounded,
          onTap: onNext,
          disabled: isNextDisabled,
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFF234D86),
    this.disabled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFB8C3D1) : backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
