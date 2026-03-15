import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MediRadarApp());
}

// ─── DESIGN TOKENS ────────────────────────────────────────────────────────────

class C {
  // Rich deep-space dark palette with electric teal + gold accents
  static const bg          = Color(0xFF060D1A);   // near-black navy
  static const bgDeep      = Color(0xFF030810);
  static const surface     = Color(0xFF0D1F35);   // card base
  static const surfaceHigh = Color(0xFF122540);   // elevated card
  static const border      = Color(0xFF1C3550);
  static const borderGlow  = Color(0xFF00E5CC);

  static const teal        = Color(0xFF00E5CC);   // electric teal
  static const tealMid     = Color(0xFF00BFA5);
  static const tealDark    = Color(0xFF00897B);
  static const tealGlow    = Color(0x3300E5CC);
  static const tealFaint   = Color(0x1100E5CC);

  static const gold        = Color(0xFFFFD54F);
  static const goldGlow    = Color(0x33FFD54F);

  static const blue        = Color(0xFF448AFF);
  static const blueGlow    = Color(0x33448AFF);

  static const purple      = Color(0xFFAB47BC);
  static const purpleGlow  = Color(0x33AB47BC);

  static const green       = Color(0xFF69F0AE);
  static const red         = Color(0xFFFF5252);

  static const w100  = Color(0xFFFFFFFF);
  static const w80   = Color(0xCCFFFFFF);
  static const w60   = Color(0x99FFFFFF);
  static const w40   = Color(0x66FFFFFF);
  static const w20   = Color(0x33FFFFFF);
  static const w10   = Color(0x1AFFFFFF);
  static const w05   = Color(0x0DFFFFFF);
}

// ─── APP ──────────────────────────────────────────────────────────────────────

class MediRadarApp extends StatelessWidget {
  const MediRadarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediRadar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: C.bg,
        colorScheme: const ColorScheme.dark(primary: C.teal, surface: C.surface),
      ),
      home: const SplashScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SPLASH SCREEN  (animated logo reveal)
// ═══════════════════════════════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ring1, _ring2, _logo, _text, _bg;
  late final Animation<double> _ring1Scale, _ring2Scale, _logoScale,
      _logoFade, _textFade, _textSlide, _bgFade;

  @override
  void initState() {
    super.initState();

    _bg = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600))..forward();
    _bgFade = CurvedAnimation(parent: _bg, curve: Curves.easeIn);

    _ring1 = AnimationController(vsync: this,
        duration: const Duration(seconds: 3))..repeat();
    _ring2 = AnimationController(vsync: this,
        duration: const Duration(seconds: 4))..repeat();
    _ring1Scale = Tween<double>(begin: 0.8, end: 1.5).animate(
        CurvedAnimation(parent: _ring1, curve: Curves.easeOut));
    _ring2Scale = Tween<double>(begin: 0.6, end: 1.8).animate(
        CurvedAnimation(parent: _ring2, curve: Curves.easeOut));

    _logo = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900));
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logo, curve: Curves.elasticOut));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logo, curve: Curves.easeIn));

    _text = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 700));
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _text, curve: Curves.easeIn));
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
        CurvedAnimation(parent: _text, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 400), () => _logo.forward());
    Future.delayed(const Duration(milliseconds: 900), () => _text.forward());
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context,
            PageRouteBuilder(
              pageBuilder: (_, a, __) => const MainShell(),
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder: (_, a, __, child) => FadeTransition(
                opacity: a, child: child),
            ));
      }
    });
  }

  @override
  void dispose() {
    _ring1.dispose(); _ring2.dispose();
    _logo.dispose(); _text.dispose(); _bg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bgDeep,
      body: FadeTransition(
        opacity: _bgFade,
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center, radius: 1.2,
              colors: [Color(0xFF0A2540), C.bgDeep],
            ),
          ),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Pulsing rings + logo
              SizedBox(width: 200, height: 200,
                child: Stack(alignment: Alignment.center, children: [
                  // Outer ring
                  AnimatedBuilder(
                    animation: _ring2Scale,
                    builder: (_, __) => Opacity(
                      opacity: (1.0 - _ring2.value).clamp(0.0, 0.5),
                      child: Transform.scale(
                        scale: _ring2Scale.value,
                        child: Container(
                          width: 160, height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: C.teal, width: 1),
                          )),
                      ),
                    ),
                  ),
                  // Inner ring
                  AnimatedBuilder(
                    animation: _ring1Scale,
                    builder: (_, __) => Opacity(
                      opacity: (1.0 - _ring1.value).clamp(0.0, 0.7),
                      child: Transform.scale(
                        scale: _ring1Scale.value,
                        child: Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: C.teal, width: 1.5),
                          )),
                      ),
                    ),
                  ),
                  // Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF00E5CC), Color(0xFF00897B)],
                          ),
                          boxShadow: [
                            BoxShadow(color: C.teal.withOpacity(0.5),
                              blurRadius: 30, spreadRadius: 4),
                          ],
                        ),
                        child: const _MediRadarLogo(size: 56),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 28),
              AnimatedBuilder(
                animation: _text,
                builder: (_, __) => FadeTransition(
                  opacity: _textFade,
                  child: Transform.translate(
                    offset: Offset(0, _textSlide.value),
                    child: Column(children: [
                      const Text('MediRadar',
                        style: TextStyle(
                          color: C.w100, fontSize: 36,
                          fontWeight: FontWeight.w800, letterSpacing: 1.0,
                        )),
                      const SizedBox(height: 6),
                      Text('Smart Medicine Finder',
                        style: TextStyle(color: C.teal,
                          fontSize: 14, fontWeight: FontWeight.w500,
                          letterSpacing: 2.0)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(width: 40, height: 40,
                child: CircularProgressIndicator(
                  color: C.teal.withOpacity(0.6),
                  strokeWidth: 2,
                )),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─── APP LOGO WIDGET ──────────────────────────────────────────────────────────

class _MediRadarLogo extends StatelessWidget {
  final double size;
  final Color color;
  const _MediRadarLogo({this.size = 28, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    // Cross (medical) + radar arc — custom painted logo
    return CustomPaint(
      size: Size(size, size),
      painter: _LogoPainter(color: color),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  const _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.width * 0.09;

    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.38;

    // Medical cross
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), p);
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), p);

    // Radar arc (top-right quarter + small extra)
    final arcRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: s.width * 0.72,
      height: s.height * 0.72,
    );
    canvas.drawArc(arcRect, -math.pi * 0.1, math.pi * 0.7, false,
      p..color = color.withOpacity(0.85)..strokeWidth = s.width * 0.08);

    // Center dot
    canvas.drawCircle(Offset(cx, cy), s.width * 0.08,
      Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN SHELL
// ═══════════════════════════════════════════════════════════════════════════════

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _tab = 0;
  late AnimationController _navAnim;

  final _pages = const [
    HomePage(), SearchPage(), PharmaciesPage(), ChatPage(),
  ];

  @override
  void initState() {
    super.initState();
    _navAnim = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 300));
    _navAnim.forward();
  }

  @override
  void dispose() {
    _navAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04), end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_tab),
          child: _pages[_tab],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        current: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ─── BOTTOM NAV ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.search_rounded, 'Search'),
      (Icons.local_pharmacy_rounded, 'Pharmacies'),
      (Icons.chat_bubble_rounded, 'Chat'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: C.surface,
        border: const Border(top: BorderSide(color: C.border, width: 1)),
        boxShadow: [
          BoxShadow(color: C.teal.withOpacity(0.05),
            blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final sel = current == i;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: sel ? 20 : 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? C.tealGlow : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: sel
                      ? Border.all(color: C.teal.withOpacity(0.3))
                      : null,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    AnimatedScale(
                      scale: sel ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(items[i].$1,
                        color: sel ? C.teal : C.w40, size: 22),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: sel ? C.teal : C.w40,
                        fontSize: 10,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                      child: Text(items[i].$2),
                    ),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HOME PAGE
// ═══════════════════════════════════════════════════════════════════════════════

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _fades, _slides;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1200));

    _fades = List.generate(6, (i) =>
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(i * 0.12, (i * 0.12 + 0.5).clamp(0, 1),
          curve: Curves.easeOut),
      )));

    _slides = List.generate(6, (i) =>
      Tween<double>(begin: 40, end: 0).animate(CurvedAnimation(
        parent: _ctrl,
        curve: Interval(i * 0.12, (i * 0.12 + 0.5).clamp(0, 1),
          curve: Curves.easeOutCubic),
      )));

    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Widget _animated(int i, Widget child) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => FadeTransition(
        opacity: _fades[i],
        child: Transform.translate(
          offset: Offset(0, _slides[i].value),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _animated(0, _HeroSection()),
          const SizedBox(height: 24),
          _animated(1, _StatsSection()),
          const SizedBox(height: 28),
          _animated(2, _SectionLabel('Explore Features')),
          const SizedBox(height: 14),
          _animated(3, _FeaturesList()),
          const SizedBox(height: 28),
          _animated(4, _ProTipCard()),
          const SizedBox(height: 28),
          _animated(5, _QuickActionsRow()),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

// ─── HERO ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatefulWidget {
  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2540), Color(0xFF06172B), Color(0xFF091E34)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(color: C.teal.withOpacity(0.08),
            blurRadius: 40, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(children: [
        // Animated grid mesh background
        Positioned.fill(child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36)),
          child: CustomPaint(painter: _GridMeshPainter()),
        )),
        // Glow orbs
        Positioned(top: -20, right: -20,
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Opacity(
              opacity: _pulseAnim.value * 0.15,
              child: Container(width: 200, height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.teal)),
            ),
          )),
        Positioned(bottom: 20, left: -40,
          child: Container(width: 140, height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: C.blue.withOpacity(0.06)))),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 36),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Top bar
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  // App logo
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [C.teal, C.tealDark],
                      ),
                      boxShadow: [
                        BoxShadow(color: C.teal.withOpacity(0.4),
                          blurRadius: 12, spreadRadius: 1),
                      ],
                    ),
                    child: const Center(
                      child: _MediRadarLogo(size: 24, color: Colors.white))),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('MediRadar',
                      style: TextStyle(color: C.w100, fontSize: 17,
                        fontWeight: FontWeight.w800, letterSpacing: 0.3)),
                    Text('Smart Medicine Finder',
                      style: TextStyle(color: C.teal,
                        fontSize: 9, fontWeight: FontWeight.w500,
                        letterSpacing: 1.2)),
                  ]),
                ]),
                Row(children: [
                  _TopBtn(Icons.notifications_outlined),
                  const SizedBox(width: 8),
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1C3550), Color(0xFF0D2137)]),
                      border: Border.all(color: C.border)),
                    child: const Icon(Icons.person_rounded,
                      color: C.w60, size: 20)),
                ]),
              ]),
              const SizedBox(height: 34),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: C.tealFaint,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.teal.withOpacity(0.25))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Container(
                      width: 7, height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.teal.withOpacity(_pulseAnim.value))),
                  ),
                  const SizedBox(width: 7),
                  const Text('Premium Healthcare',
                    style: TextStyle(color: C.teal,
                      fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              ),
              const SizedBox(height: 18),
              // Title
              RichText(text: const TextSpan(
                style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 32, fontWeight: FontWeight.w800, height: 1.15),
                children: [
                  TextSpan(text: 'Welcome to\n',
                    style: TextStyle(color: C.w100)),
                  TextSpan(text: 'Medi',
                    style: TextStyle(color: C.w100)),
                  TextSpan(text: 'Radar',
                    style: TextStyle(color: C.teal)),
                ],
              )),
              const SizedBox(height: 14),
              const Text(
                'Your one-stop solution for finding medicines,\ncomparing prices, and connecting with local pharmacies.',
                style: TextStyle(color: C.w60, fontSize: 13, height: 1.7)),
              const SizedBox(height: 28),
              // Buttons
              Row(children: [
                Expanded(
                  child: _GlowButton(
                    label: 'Search Medicines',
                    icon: Icons.search_rounded,
                    onTap: () {},
                  )),
                const SizedBox(width: 12),
                Expanded(
                  child: _OutlineButton(
                    label: 'Explore Features',
                    onTap: () {},
                  )),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _TopBtn extends StatelessWidget {
  final IconData icon;
  const _TopBtn(this.icon);
  @override
  Widget build(BuildContext context) => Container(
    width: 38, height: 38,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(11),
      color: C.w10,
      border: Border.all(color: C.border)),
    child: Icon(icon, color: C.w60, size: 19));
}

class _GlowButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [C.teal, C.tealMid]),
          boxShadow: [
            BoxShadow(color: C.teal.withOpacity(0.35),
              blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.teal.withOpacity(0.4)),
          color: C.tealFaint),
        child: Center(child: Text(label, style: const TextStyle(
          color: C.teal, fontWeight: FontWeight.w700, fontSize: 13))),
      ),
    );
  }
}

// ─── STATS ────────────────────────────────────────────────────────────────────

class _StatsSection extends StatefulWidget {
  @override
  State<_StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<_StatsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 800))..forward();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('💊', '2,000+', 'Medicines', C.teal),
      ('🏪', '150+', 'Pharmacies', C.blue),
      ('👥', '5,000+', 'Active Users', C.gold),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 6),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: C.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3),
              blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(children: List.generate(stats.length, (i) {
          final s = stats[i];
          return Expanded(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final delay = i * 0.2;
                final t = (((_ctrl.value - delay) / 0.6).clamp(0.0, 1.0));
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - t)),
                    child: Column(children: [
                      Text(s.$1, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text(s.$2, style: TextStyle(
                        color: s.$4, fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(s.$3, style: const TextStyle(
                        color: C.w60, fontSize: 11, fontWeight: FontWeight.w500)),
                      if (i < stats.length - 1) ...[],
                    ]),
                  ),
                );
              },
            ),
          );
        })..insert(1, Container(width: 1, height: 56, color: C.border))
          ..insert(3, Container(width: 1, height: 56, color: C.border))),
      ),
    );
  }
}

// ─── SECTION LABEL ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  final String? action;
  const _SectionLabel(this.title, {this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(width: 4, height: 20,
              decoration: BoxDecoration(
                color: C.teal, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(
              color: C.w100, fontSize: 18, fontWeight: FontWeight.w800)),
          ]),
          if (action != null)
            Text(action!, style: const TextStyle(
              color: C.teal, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── FEATURES LIST ────────────────────────────────────────────────────────────

class _FeaturesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatData(Icons.search_rounded, 'Search Medicines',
        'Find medicines with real-time availability\nand price comparison',
        C.teal, const Color(0xFF0A2E30)),
      _FeatData(Icons.local_pharmacy_rounded, 'Find Pharmacies',
        'Locate nearby pharmacies with directions\nand opening hours',
        C.blue, const Color(0xFF0A1E35)),
      _FeatData(Icons.chat_bubble_rounded, 'Chat with Pharmacies',
        'Connect directly with pharmacy owners\nfor inquiries',
        C.gold, const Color(0xFF2A1E0A)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: features.asMap().entries.map((e) =>
        Padding(
          padding: EdgeInsets.only(bottom: e.key < features.length - 1 ? 12 : 0),
          child: _FeatureCard(data: e.value),
        )).toList()),
    );
  }
}

class _FeatData {
  final IconData icon;
  final String title, desc;
  final Color accent, bg;
  const _FeatData(this.icon, this.title, this.desc, this.accent, this.bg);
}

class _FeatureCard extends StatefulWidget {
  final _FeatData data;
  const _FeatureCard({required this.data});
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 120), value: 1.0);
    _scale = Tween<double>(begin: 0.97, end: 1.0).animate(
        CurvedAnimation(parent: _press, curve: Curves.easeOut));
  }
  @override void dispose() { _press.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: (_) => _press.reverse(),
      onTapUp: (_) => _press.forward(),
      onTapCancel: () => _press.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2),
                blurRadius: 12, offset: const Offset(0, 4)),
              BoxShadow(color: d.accent.withOpacity(0.04),
                blurRadius: 20, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: d.bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: d.accent.withOpacity(0.2))),
              child: Icon(d.icon, color: d.accent, size: 26)),
            const SizedBox(width: 16),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.title, style: const TextStyle(
                color: C.w100, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text(d.desc, style: const TextStyle(
                color: C.w60, fontSize: 12, height: 1.5)),
            ])),
            const SizedBox(width: 8),
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: d.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.arrow_forward_ios_rounded,
                color: d.accent, size: 14)),
          ]),
        ),
      ),
    );
  }
}

// ─── PRO TIP ──────────────────────────────────────────────────────────────────

class _ProTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [C.teal.withOpacity(0.15), C.tealDark.withOpacity(0.05)]),
          border: Border.all(color: C.teal.withOpacity(0.22))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: C.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13)),
            child: const Center(child: Text('💡', style: TextStyle(fontSize: 22)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(children: [
              const Text('Pro Tip',
                style: TextStyle(color: C.teal, fontSize: 13,
                  fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: C.goldGlow,
                  borderRadius: BorderRadius.circular(6)),
                child: const Text('SAVE MONEY',
                  style: TextStyle(color: C.gold,
                    fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5))),
            ]),
            const SizedBox(height: 7),
            const Text(
              'Always check for generic alternatives to save money. Our app suggests cheaper alternatives for your searched medicines!',
              style: TextStyle(color: C.w80, fontSize: 13, height: 1.6)),
          ])),
        ]),
      ),
    );
  }
}

// ─── QUICK ACTIONS ────────────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionLabel('Quick Actions'),
        const SizedBox(height: 14),
        Row(children: [
          _QAction(Icons.qr_code_scanner_rounded, 'Scan\nPrescription', C.teal),
          const SizedBox(width: 12),
          _QAction(Icons.compare_arrows_rounded, 'Compare\nPrices', C.blue),
          const SizedBox(width: 12),
          _QAction(Icons.favorite_rounded, 'Saved\nItems', C.purple),
          const SizedBox(width: 12),
          _QAction(Icons.history_rounded, 'Recent\nSearches', C.gold),
        ]),
      ]),
    );
  }
}

class _QAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QAction(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2))),
        child: Column(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center,
            style: const TextStyle(color: C.w80,
              fontSize: 10, fontWeight: FontWeight.w600, height: 1.3)),
        ]),
      ),
    );
  }
}

// ─── GRID MESH PAINTER ────────────────────────────────────────────────────────

class _GridMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF00E5CC).withOpacity(0.04)
      ..strokeWidth = 0.8;
    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SEARCH PAGE
// ═══════════════════════════════════════════════════════════════════════════════

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  String _query = '';
  String _filter = 'All';
  final _filters = ['All', 'In Stock', 'Lowest Price', 'Nearest'];
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 600))..forward();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  List<_Med> get _results => _meds
      .where((m) => m.name.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [C.teal, C.tealDark])),
                  child: const Center(
                    child: _MediRadarLogo(size: 20))),
                const SizedBox(width: 10),
                const Text('Search Medicines',
                  style: TextStyle(color: C.w100,
                    fontSize: 20, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 46),
                child: Text('Real-time availability & price comparison',
                  style: TextStyle(color: C.w40, fontSize: 12))),
              const SizedBox(height: 20),
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.border),
                  boxShadow: [
                    BoxShadow(color: C.teal.withOpacity(0.06),
                      blurRadius: 12),
                  ],
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(color: C.w100, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search medicines, brands...',
                    hintStyle: const TextStyle(color: C.w40, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                      color: C.teal, size: 22),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [C.teal, C.tealDark]),
                        borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.qr_code_scanner_rounded,
                        color: Colors.white, size: 18)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14)),
                ),
              ),
              const SizedBox(height: 14),
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final sel = _filter == f;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? C.teal : C.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: sel ? C.teal : C.border),
                          boxShadow: sel ? [
                            BoxShadow(color: C.teal.withOpacity(0.3),
                              blurRadius: 8)
                          ] : null,
                        ),
                        child: Text(f, style: TextStyle(
                          color: sel ? Colors.white : C.w60,
                          fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _query.isEmpty
              ? _SearchEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _results.length,
                  itemBuilder: (_, i) => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + i * 60),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, child) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - v)),
                        child: child)),
                    child: _MedTile(med: _results[i]),
                  ),
                ),
          ),
        ]),
      ),
    );
  }
}

class _SearchEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text('Recent Searches', style: TextStyle(
          color: C.w40, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...['Panadol Extra', 'Augmentin 625mg', 'Disprin'].map((q) =>
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: C.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: C.border)),
            child: Row(children: [
              const Icon(Icons.history_rounded, color: C.teal, size: 17),
              const SizedBox(width: 12),
              Text(q, style: const TextStyle(color: C.w80, fontSize: 13)),
              const Spacer(),
              const Icon(Icons.north_west_rounded, color: C.w20, size: 13),
            ]))),
        const SizedBox(height: 20),
        const Text('Popular Medicines', style: TextStyle(
          color: C.w40, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8,
          children: ['Paracetamol', 'Amoxicillin', 'Metformin',
            'Omeprazole', 'Vitamin C', 'Brufen']
              .map((m) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: C.tealFaint,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.teal.withOpacity(0.25))),
                child: Text(m, style: const TextStyle(
                  color: C.teal, fontSize: 12, fontWeight: FontWeight.w600)),
              )).toList()),
      ],
    );
  }
}

class _MedTile extends StatelessWidget {
  final _Med med;
  const _MedTile({required this.med});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.surface, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15),
            blurRadius: 8, offset: const Offset(0, 3))]),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: med.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: med.color.withOpacity(0.2))),
          child: Icon(Icons.medication_rounded, color: med.color, size: 26)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(med.name, style: const TextStyle(
            color: C.w100, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(med.category, style: const TextStyle(
            color: C.w40, fontSize: 11)),
          const SizedBox(height: 7),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: C.tealFaint,
                borderRadius: BorderRadius.circular(8)),
              child: Text('Rs. ${med.price}',
                style: const TextStyle(color: C.teal,
                  fontSize: 13, fontWeight: FontWeight.w800))),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: med.available
                  ? C.green.withOpacity(0.1) : C.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
              child: Text(med.available ? '✓ In Stock' : '✗ Out of Stock',
                style: TextStyle(
                  color: med.available ? C.green : C.red,
                  fontSize: 10, fontWeight: FontWeight.w700))),
          ]),
        ])),
        const Icon(Icons.chevron_right_rounded, color: C.teal, size: 20),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHARMACIES PAGE
// ═══════════════════════════════════════════════════════════════════════════════

class PharmaciesPage extends StatelessWidget {
  const PharmaciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [C.teal, C.tealDark])),
                  child: const Center(child: _MediRadarLogo(size: 20))),
                const SizedBox(width: 10),
                const Text('Find Pharmacies', style: TextStyle(
                  color: C.w100, fontSize: 20, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 46),
                child: Text('Nearby with live status & directions',
                  style: TextStyle(color: C.w40, fontSize: 12))),
              const SizedBox(height: 20),
              // Map preview
              Container(
                height: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.border),
                  boxShadow: [
                    BoxShadow(color: C.teal.withOpacity(0.08),
                      blurRadius: 20)]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomPaint(
                    painter: _DarkMapPainter(),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [C.teal, C.tealDark]),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: C.teal.withOpacity(0.45),
                              blurRadius: 14)]),
                        child: const Row(mainAxisSize: MainAxisSize.min,
                          children: [
                          Icon(Icons.navigation_rounded,
                            color: Colors.white, size: 16),
                          SizedBox(width: 7),
                          Text('Open Full Map', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700, fontSize: 13)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Nearby Pharmacies', style: TextStyle(
                color: C.w100, fontSize: 17, fontWeight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: C.tealFaint,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: C.teal.withOpacity(0.2))),
                child: const Text('8 found', style: TextStyle(
                  color: C.teal, fontSize: 11, fontWeight: FontWeight.w700))),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _pharmacies.length,
              itemBuilder: (_, i) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + i * 70),
                curve: Curves.easeOutCubic,
                builder: (_, v, child) => Opacity(opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, 24 * (1 - v)), child: child)),
                child: _PharmTile(p: _pharmacies[i]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _PharmTile extends StatelessWidget {
  final _Pharm p;
  const _PharmTile({required this.p});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.surface, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.18),
            blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(width: 52, height: 52,
          decoration: BoxDecoration(
            color: C.tealFaint,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: C.teal.withOpacity(0.2))),
          child: const Icon(Icons.local_pharmacy_rounded,
            color: C.teal, size: 26)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(p.name, style: const TextStyle(
            color: C.w100, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on_rounded, color: C.teal, size: 12),
            const SizedBox(width: 3),
            Text(p.distance, style: const TextStyle(
              color: C.w60, fontSize: 11)),
            const SizedBox(width: 8),
            const Icon(Icons.star_rounded, color: C.gold, size: 12),
            const SizedBox(width: 3),
            Text(p.rating.toString(), style: const TextStyle(
              color: C.w60, fontSize: 11)),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: p.isOpen
                  ? C.green.withOpacity(0.1) : C.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7)),
              child: Text(p.isOpen ? 'Open Now' : 'Closed',
                style: TextStyle(
                  color: p.isOpen ? C.green : C.red,
                  fontSize: 10, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Text(p.hours, style: const TextStyle(
              color: C.w20, fontSize: 10)),
          ]),
        ])),
        Column(children: [
          _ActionCircle(Icons.navigation_rounded, C.teal, () {}),
          const SizedBox(height: 8),
          _ActionCircle(Icons.call_rounded, C.blue, () {}),
        ]),
      ]),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionCircle(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Icon(icon, color: color, size: 17)));
}

class _DarkMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF060F1C));
    final grid = Paint()..color = const Color(0xFF0C1E30)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final road = Paint()..color = const Color(0xFF142030)..strokeWidth = 16;
    canvas.drawLine(Offset(0, size.height * 0.42),
      Offset(size.width, size.height * 0.46), road);
    canvas.drawLine(Offset(size.width * 0.46, 0),
      Offset(size.width * 0.5, size.height), road);
    for (final d in [
      (0.25, 0.3), (0.7, 0.65), (0.78, 0.22), (0.15, 0.7)
    ]) {
      final pos = Offset(size.width * d.$1, size.height * d.$2);
      canvas.drawCircle(pos, 11,
        Paint()..color = C.teal.withOpacity(0.85));
      canvas.drawCircle(pos, 5, Paint()..color = Colors.white);
      canvas.drawCircle(pos, 18,
        Paint()..color = C.teal.withOpacity(0.12)
          ..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
    // User dot
    final center = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(center, 22,
      Paint()..color = C.blue.withOpacity(0.15));
    canvas.drawCircle(center, 11, Paint()..color = C.blue);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }
  @override bool shouldRepaint(_) => false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHAT PAGE
// ═══════════════════════════════════════════════════════════════════════════════

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _sel = 0;
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _msgs = <_Msg>[
    _Msg('Hello! Do you have Panadol Extra in stock?', true, '10:02 AM'),
    _Msg('Yes, we have it available. Price is Rs. 85 per pack.', false, '10:03 AM'),
    _Msg('Do you also have Augmentin 625mg?', true, '10:04 AM'),
    _Msg('Yes, Rs. 340 per strip. Would you like to reserve?', false, '10:05 AM'),
  ];

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _msgs.add(_Msg(_ctrl.text.trim(), true, 'Now'));
      _ctrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 80), () {
      _scroll.animateTo(_scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            decoration: BoxDecoration(
              color: C.surface,
              border: const Border(bottom: BorderSide(color: C.border))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [C.teal, C.tealDark])),
                  child: const Center(child: _MediRadarLogo(size: 20))),
                const SizedBox(width: 10),
                const Text('Chat with Pharmacies', style: TextStyle(
                  color: C.w100, fontSize: 18, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: _pharmacies.take(3).toList()
                  .asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _sel = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: _sel == e.key ? C.tealGlow : C.bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _sel == e.key ? C.teal : C.border)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: e.value.isOpen ? C.green : C.red)),
                        const SizedBox(width: 8),
                        Text(e.value.name, style: TextStyle(
                          color: _sel == e.key ? C.teal : C.w60,
                          fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  )).toList()),
              ),
            ]),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _msgs.length,
              itemBuilder: (_, i) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + i * 40),
                curve: Curves.easeOutCubic,
                builder: (_, v, child) => Opacity(opacity: v,
                  child: Transform.translate(
                    offset: Offset(_msgs[i].isUser ? 20*(1-v) : -20*(1-v), 0),
                    child: child)),
                child: _Bubble(msg: _msgs[i]),
              ),
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: BoxDecoration(
              color: C.surface,
              border: const Border(top: BorderSide(color: C.border))),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: C.bg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: C.border)),
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(color: C.w100, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: C.w40, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.attach_file_rounded,
                          color: C.w20, size: 20),
                        onPressed: () {})),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [C.teal, C.tealDark]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: C.teal.withOpacity(0.4),
                        blurRadius: 12)]),
                  child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20))),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: msg.isUser
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [C.teal, C.tealDark])
            : null,
          color: msg.isUser ? null : C.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16)),
          border: msg.isUser ? null : Border.all(color: C.border),
          boxShadow: msg.isUser ? [
            BoxShadow(color: C.teal.withOpacity(0.25), blurRadius: 8)
          ] : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(msg.text, style: TextStyle(
            color: msg.isUser ? Colors.white : C.w80,
            fontSize: 13, height: 1.5)),
          const SizedBox(height: 4),
          Text(msg.time, style: TextStyle(
            color: msg.isUser
              ? Colors.white.withOpacity(0.55) : C.w20,
            fontSize: 10)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DATA
// ═══════════════════════════════════════════════════════════════════════════════

class _Med {
  final String name, category;
  final int price;
  final bool available;
  final Color color;
  const _Med(this.name, this.category, this.price, this.available, this.color);
}

class _Pharm {
  final String name, distance, hours;
  final double rating;
  final bool isOpen;
  const _Pharm(this.name, this.distance, this.hours, this.rating, this.isOpen);
}

class _Msg {
  final String text, time;
  final bool isUser;
  const _Msg(this.text, this.isUser, this.time);
}

const _meds = [
  _Med('Panadol Extra', 'Analgesic / Antipyretic', 85, true, C.teal),
  _Med('Augmentin 625mg', 'Antibiotic', 340, true, Color(0xFFAB47BC)),
  _Med('Metformin 500mg', 'Antidiabetic', 120, false, Color(0xFF26A69A)),
  _Med('Omeprazole 20mg', 'Antacid / PPI', 95, true, Color(0xFFFF7043)),
  _Med('Vitamin C 500mg', 'Supplement', 180, true, C.gold),
  _Med('Disprin Tablet', 'Analgesic', 45, true, Color(0xFFEF5350)),
];

const _pharmacies = [
  _Pharm('MedLife Pharmacy', '0.3 km', '8AM – 11PM', 4.8, true),
  _Pharm('Apollo Pharmacy', '0.8 km', '24 Hours', 4.5, true),
  _Pharm('Kausar Medical', '1.2 km', '9AM – 9PM', 4.2, false),
  _Pharm('City Pharmacy', '1.5 km', '8AM – 10PM', 4.6, true),
  _Pharm('Health Plus', '2.1 km', '10AM – 8PM', 4.0, false),
];
