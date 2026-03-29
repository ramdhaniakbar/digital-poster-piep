import 'dart:async';
import 'dart:ui' show ImageFilter;
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
    _progressController.forward(from: 0);
    _autoSlideTimer = Timer(_autoSlideDuration, () {
      _goToPage((_currentIndex + 1) % _posters.length);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Poster area ──────────────────────────────────────────────────
          Expanded(
            child: PageView.builder(
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
          ),

          // ── Navigation bar ───────────────────────────────────────────────
          _NavBar(
            currentIndex: _currentIndex,
            total: _posters.length,
            progressController: _progressController,
            onPrev: () => _goToPage(
              (_currentIndex - 1 + _posters.length) % _posters.length,
            ),
            onNext: () => _goToPage(
              (_currentIndex + 1) % _posters.length,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav bar widget ─────────────────────────────────────────────────────────────

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.currentIndex,
    required this.total,
    required this.progressController,
    required this.onPrev,
    required this.onNext,
  });

  final int currentIndex;
  final int total;
  final AnimationController progressController;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == total - 1;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Controls row
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    // Prev
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _NavArrow(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: onPrev,
                          disabled: isFirst,
                        ),
                      ),
                    ),

                    // Pill dots
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(total, (i) {
                        final isActive = i == currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: isActive ? 24.0 : 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white
                                .withValues(alpha: isActive ? 1.0 : 0.4),
                          ),
                        );
                      }),
                    ),

                    // Next
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _NavArrow(
                          icon: Icons.arrow_forward_ios_rounded,
                          onTap: onNext,
                          disabled: isLast,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Auto-slide progress bar
              AnimatedBuilder(
                animation: progressController,
                builder: (_, child) => LinearProgressIndicator(
                  value: progressController.value,
                  minHeight: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Arrow button ───────────────────────────────────────────────────────────────

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.3 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
