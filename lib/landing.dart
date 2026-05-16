import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ─── Palette: Hitam Monokromatik ─────────────────────────────────────────────
class _C {
  static const bg         = Color(0xFF050A12);
  static const surface    = Color(0xFF0A1525);
  static const card       = Color(0xFF0E1E35);
  static const border     = Color(0xFF162B4A);
  static const borderLit  = Color(0xFF1E3F6E);

  // SEMUA WARNA BIRU DIUBAH MENJADI HITAM
  static const steel      = Color(0xFF000000);   // hitam
  static const blueMid    = Color(0xFF000000);   // hitam
  static const blueLight  = Color(0xFF000000);   // hitam
  static const chrome     = Color(0xFF000000);   // hitam
  static const frost      = Color(0xFF000000);   // hitam

  static const gold       = Color(0xFFD4A843);   // aksen emas metalik
  static const silver     = Color(0xFF8FAFC8);   // perak

  static const text       = Color(0xFFDEEEFB);
  static const textSub    = Color(0xFF6A92B8);
  static const textDim    = Color(0xFF2E4E6E);

  // Gradien diubah menjadi hitam ke abu-abu gelap
  static const LinearGradient primaryGrad = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient metalGrad = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  // Animations
  late AnimationController _bgCtrl;
  late AnimationController _entranceCtrl;
  late AnimationController _logoCtrl;
  late AnimationController _btnCtrl;
  late AnimationController _orbCtrl;

  late Animation<double> _fade;
  late Animation<Offset>  _slide;
  late Animation<double>  _logoPulse;
  late Animation<double>  _logoGlow;
  late Animation<double>  _btnGlow;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 20))
      ..repeat();

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _fade  = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);
    _logoPulse = Tween<double>(begin: 0.94, end: 1.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeInOut));
    _logoGlow = Tween<double>(begin: 0.3, end: 0.8)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeInOut));

    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _btnGlow = Tween<double>(begin: 0.2, end: 0.55)
        .animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    _orbCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 12))
      ..repeat();

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entranceCtrl.dispose();
    _logoCtrl.dispose();
    _btnCtrl.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(child: _AnimatedBg(bgCtrl: _bgCtrl, orbCtrl: _orbCtrl)),

          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),

                      // ── Hero section ──────────────────────────────────
                      _buildHeroSection(),

                      const SizedBox(height: 44),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // ── Sign In button ────────────────────────
                            _buildSignInButton(),
                            const SizedBox(height: 14),

                            // ── Buy Access button ─────────────────────
                            _buildBuyButton(),
                            const SizedBox(height: 32),

                            // ── Divider ───────────────────────────────
                            _buildDivider(),
                            const SizedBox(height: 24),

                            // ── Contact buttons ───────────────────────
                            Row(children: [
                              Expanded(child: _ContactBtn(
                                icon: FontAwesomeIcons.telegram,
                                label: 'Telegram',
                                color: const Color(0xFF39A7E0),
                                colorDim: const Color(0xFF1A4D6E),
                                onTap: () => _openUrl('https://t.me/Fahri_Reals01'),
                              )),
                              const SizedBox(width: 12),
                              Expanded(child: _ContactBtn(
                                icon: FontAwesomeIcons.whatsapp,
                                label: 'WhatsApp',
                                color: const Color(0xFF25D366),
                                colorDim: const Color(0xFF0D4A27),
                                onTap: () => _openUrl('https://wa.me/6282173732375'),
                              )),
                            ]),

                            const SizedBox(height: 40),

                            // ── Footer ────────────────────────────────
                            _buildFooter(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero Section ─────────────────────────────────────────────────────────
  Widget _buildHeroSection() {
    return Column(children: [
      // Logo
      AnimatedBuilder(
        animation: _logoCtrl,
        builder: (_, __) => Transform.scale(
          scale: _logoPulse.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _C.blueMid.withOpacity(_logoGlow.value * 0.2),
                    width: 1,
                  ),
                ),
              ),
              // Mid glow ring
              Container(
                width: 118, height: 118,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _C.blueMid.withOpacity(_logoGlow.value * 0.35),
                    width: 1.5,
                  ),
                ),
              ),
              // Rotating metallic ring (warna hitam)
              Transform.rotate(
                angle: _orbCtrl.value * math.pi * 2,
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        _C.blueMid.withOpacity(_logoGlow.value * 0.6),
                        Colors.transparent,
                        _C.chrome.withOpacity(_logoGlow.value * 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Core logo
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0E1E35), Color(0xFF162B4A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: _C.blueLight.withOpacity(_logoGlow.value * 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _C.blueMid.withOpacity(_logoGlow.value * 0.5),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    'assets/images/reze.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.water_rounded,
                      color: _C.blueLight, size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 28),

      // App name
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [_C.chrome, _C.frost, _C.blueLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(b),
        child: const Text(
          'Tr4sFlox',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
      ),

      const SizedBox(height: 8),

      // Tag line
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _C.border),
        ),
        child: const Text(
          'Powered by @Fahri_Reals01 And @rulz_md',
          style: TextStyle(
            color: _C.textSub,
            fontSize: 12,
            letterSpacing: 0.3,
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Feature pills
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FeaturePill(label: 'Secure', icon: Icons.shield_rounded),
          const SizedBox(width: 8),
          _FeaturePill(label: 'Fast', icon: Icons.bolt_rounded),
          const SizedBox(width: 8),
          _FeaturePill(label: 'Reliable', icon: Icons.verified_rounded),
        ],
      ),
    ]);
  }

  // ─── Sign In Button ───────────────────────────────────────────────────────
  Widget _buildSignInButton() {
    return AnimatedBuilder(
      animation: _btnCtrl,
      builder: (_, __) => _PressableBtn(
        onTap: () => Navigator.pushNamed(context, '/login'),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: _C.metalGrad,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _C.blueMid.withOpacity(_btnGlow.value * 0.55),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
                child: const Icon(Icons.login_rounded,
                    color: Colors.white, size: 17),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Buy Access Button ────────────────────────────────────────────────────
  Widget _buildBuyButton() {
    return _PressableBtn(
      onTap: () => _openUrl('https://t.me/Fahri_Reals01'),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.borderLit),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.gold.withOpacity(0.1),
                border: Border.all(color: _C.gold.withOpacity(0.3)),
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: _C.gold, size: 16),
            ),
            const SizedBox(width: 12),
            const Text(
              'Beli Akses',
              style: TextStyle(
                color: _C.text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _C.gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _C.gold.withOpacity(0.3)),
              ),
              child: const Text('VIA TG',
                  style: TextStyle(color: _C.gold, fontSize: 9,
                      fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(children: [
      Expanded(child: Container(height: 1, color: _C.border)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _C.border),
          ),
          child: const Text('Hubungi Kami',
              style: TextStyle(color: _C.textSub, fontSize: 10,
                  fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ),
      ),
      Expanded(child: Container(height: 1, color: _C.border)),
    ]);
  }

  Widget _buildFooter() {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 30, height: 2,
            decoration: BoxDecoration(
              gradient: _C.metalGrad,
              borderRadius: BorderRadius.circular(1),
            )),
        const SizedBox(width: 10),
        const Text('© 2026 Tr4sFlox',
            style: TextStyle(color: _C.textDim, fontSize: 11,
                letterSpacing: 0.5)),
        const SizedBox(width: 10),
        Container(width: 30, height: 2,
            decoration: BoxDecoration(
              gradient: _C.metalGrad,
              borderRadius: BorderRadius.circular(1),
            )),
      ]),
    ]);
  }
}

// ─── Feature Pill ─────────────────────────────────────────────────────────────
class _FeaturePill extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FeaturePill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: _C.chrome, size: 12),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: _C.textSub, fontSize: 11,
            fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─── Contact Button ───────────────────────────────────────────────────────────
class _ContactBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color colorDim;
  final VoidCallback onTap;

  const _ContactBtn({
    required this.icon, required this.label,
    required this.color, required this.colorDim,
    required this.onTap,
  });

  @override
  State<_ContactBtn> createState() => _ContactBtnState();
}

class _ContactBtnState extends State<_ContactBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52,
          decoration: BoxDecoration(
            color: _pressed
                ? widget.color.withOpacity(0.1)
                : _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _pressed
                  ? widget.color.withOpacity(0.4)
                  : _C.border,
            ),
            boxShadow: _pressed
                ? [BoxShadow(color: widget.color.withOpacity(0.12),
                    blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.colorDim.withOpacity(0.7),
              ),
              child: Center(
                child: FaIcon(widget.icon, color: widget.color, size: 13),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.label,
                style: const TextStyle(color: _C.text, fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}

// ─── Pressable Button ─────────────────────────────────────────────────────────
class _PressableBtn extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableBtn({required this.child, required this.onTap});

  @override
  State<_PressableBtn> createState() => _PressableBtnState();
}

class _PressableBtnState extends State<_PressableBtn> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) { setState(() => _down = false); widget.onTap(); },
      onTapCancel: () => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: _down ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Animated Background ──────────────────────────────────────────────────────
class _AnimatedBg extends StatelessWidget {
  final AnimationController bgCtrl;
  final AnimationController orbCtrl;
  const _AnimatedBg({required this.bgCtrl, required this.orbCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([bgCtrl, orbCtrl]),
      builder: (_, __) => CustomPaint(
        painter: _BgPainter(bgCtrl.value, orbCtrl.value),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final double t;
  final double o;
  _BgPainter(this.t, this.o);

  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    final grid = Paint()
      ..color = _C.border.withOpacity(0.3)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Central glow (warna hitam)
    final glow1 = Paint()
      ..shader = RadialGradient(colors: [
        _C.steel.withOpacity(0.18 + math.sin(t * math.pi * 2) * 0.05),
        Colors.transparent,
      ], radius: 0.7).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.3),
          radius: size.width * 0.7));
    canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.3), size.width * 0.7, glow1);

    // Orbiting accent (warna hitam)
    final angle  = o * math.pi * 2;
    final orbX   = size.width / 2 + math.cos(angle) * size.width * 0.35;
    final orbY   = size.height * 0.28 + math.sin(angle) * 60;
    final glow2  = Paint()
      ..shader = RadialGradient(colors: [
        _C.blueLight.withOpacity(0.08),
        Colors.transparent,
      ], radius: 0.5).createShader(
          Rect.fromCircle(center: Offset(orbX, orbY), radius: 80));
    canvas.drawCircle(Offset(orbX, orbY), 80, glow2);

    // Bottom gradient fade
    final fade = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.transparent, Color(0xFF050A12)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(
          0, size.height * 0.55, size.width, size.height * 0.45));
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45),
        fade);
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.t != t || old.o != o;
}