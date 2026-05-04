import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'permission_screen.dart';
import '../theme.dart';
import '../services/app_init_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _exitController;
  late final Animation<double> _exitOpacity;

  // Logo scale + fade
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  // Each bar grows from 0 → 1 width (staggered)
  late final Animation<double> _bar1;
  late final Animation<double> _bar2;
  late final Animation<double> _bar3;

  // Dot pops in last
  late final Animation<double> _dot;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _scale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3),
      ),
    );

    _bar1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.55, curve: Curves.easeOut),
      ),
    );
    _bar2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
      ),
    );
    _bar3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.82, curve: Curves.easeOut),
      ),
    );
    _dot = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.0, curve: Curves.elasticOut),
      ),
    );

    Future.wait([
      _controller.forward(),
      AppInitService.initialize(),
    ]).then((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      await _exitController.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondary) =>
              const PermissionScreen(child: HomeScreen()),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandGreen,
      body: AnimatedBuilder(
        animation: _exitController,
        builder: (context, child) => Opacity(
          opacity: _exitOpacity.value,
          child: child,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _scale.value,
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(42),
                    child: CustomPaint(
                      painter: _LogoPainter(
                        bar1: _bar1.value,
                        bar2: _bar2.value,
                        bar3: _bar3.value,
                        dot: _dot.value,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double bar1;
  final double bar2;
  final double bar3;
  final double dot;

  const _LogoPainter({
    required this.bar1,
    required this.bar2,
    required this.bar3,
    required this.dot,
  });

  static const _bg = kBrandGreen;
  static const _fg = kBrandDark;

  // Original SVG viewBox is 432×432; we scale to whatever size is painted.
  static const _svgSize = 432.0;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _svgSize;
    final paint = Paint()..color = _fg;

    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = _bg);

    // Bar 1 — translate(94,122) rotate(-4°), w=244 h=36 rx=18
    _drawBar(canvas, paint, s,
      tx: 94, ty: 122, angleDeg: -4,
      width: 244, height: 36, rx: 18, progress: bar1,
    );

    // Bar 2 — translate(82,192) rotate(2°), w=208 h=36 rx=18
    _drawBar(canvas, paint, s,
      tx: 82, ty: 192, angleDeg: 2,
      width: 208, height: 36, rx: 18, progress: bar2,
    );

    // Bar 3 — translate(94,262) rotate(0°), w=170 h=36 rx=18
    _drawBar(canvas, paint, s,
      tx: 94, ty: 262, angleDeg: 0,
      width: 170, height: 36, rx: 18, progress: bar3,
    );

    // Dot — cx=338 cy=280 r=14
    if (dot > 0) {
      canvas.drawCircle(
        Offset(338 * s, 280 * s),
        14 * s * dot,
        paint,
      );
    }
  }

  void _drawBar(
    Canvas canvas,
    Paint paint,
    double s, {
    required double tx,
    required double ty,
    required double angleDeg,
    required double width,
    required double height,
    required double rx,
    required double progress,
  }) {
    if (progress <= 0) return;

    canvas.save();
    canvas.translate(tx * s, ty * s);
    canvas.rotate(angleDeg * 3.14159265 / 180);

    // Clip to animated width so the bar draws left → right
    canvas.clipRect(Rect.fromLTWH(0, 0, width * s * progress, height * s));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width * s, height * s),
        Radius.circular(rx * s),
      ),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.bar1 != bar1 ||
      old.bar2 != bar2 ||
      old.bar3 != bar3 ||
      old.dot != dot;
}
