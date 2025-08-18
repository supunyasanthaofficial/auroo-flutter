import 'package:flutter/material.dart';
import 'dart:math';

class SpringCurve extends Curve {
  const SpringCurve({this.a = 0.15, this.w = 19.4});
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInWidget({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _buttonController, curve: const SpringCurve()),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _buttonController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _buttonController.reverse();
  }

  void _handleTapCancel() {
    _buttonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://cdn.pixabay.com/photo/2018/11/17/15/31/indonesia-3821296_1280.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey,
                child: const Center(
                  child: Text(
                    'Failed to load background image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          // Content
          FadeInWidget(
            delay: const Duration(milliseconds: 200),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                        'lib/assets/images/auroo1.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image,
                              size: 150,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    // Title
                    const Text(
                      'Welcome to MarketPlace',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Helvetica',
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(1, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Subtitle
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40, top: 16),
                      child: Text(
                        'Explore a world of deals and connect with buyers and sellers.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFE5E7EB),
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.w600,
                          height: 1.56,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                    // Button
                    FadeInWidget(
                      delay: const Duration(milliseconds: 400),
                      child: GestureDetector(
                        onTapDown: _handleTapDown,
                        onTapUp: _handleTapUp,
                        onTapCancel: _handleTapCancel,
                        onTap: () {
                          debugPrint('Get Started button tapped');
                          Navigator.pushNamed(context, '/home');
                        },
                        child: ScaleTransition(
                          scale: _buttonAnimation,
                          child: AnimatedBuilder(
                            animation: _buttonAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity:
                                    (_buttonAnimation.value - 0.97) /
                                        (1 - 0.97) *
                                        (1 - 0.85) +
                                    0.85,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 40,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141313),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 4),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Get Started',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Helvetica',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
