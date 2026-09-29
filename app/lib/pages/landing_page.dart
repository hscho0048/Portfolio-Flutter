import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/intro_frame.dart';

/// '/' route: Three.js intro behind a fading hero, then "Enter portfolio".
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
  late final _ui = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  late final _loading = AnimationController(vsync: this, duration: const Duration(milliseconds: 900), value: 1);
  bool _leaving = false;
  bool _ready = false;

  @override
  void dispose() {
    _ui.dispose();
    _loading.dispose();
    super.dispose();
  }

  void _onIntroLoaded() {
    if (_ready || !mounted) return;
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _ready = true);
      _loading.reverse();
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _ui.forward();
      });
    });
  }

  Future<void> _enter() async {
    if (_leaving) return;
    setState(() => _leaving = true);
    await _ui.reverse();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/portfolio');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: terminalColorMode,
      builder: (context, mode, child) {
        final mobile = MediaQuery.sizeOf(context).width < 760;
        final bg = Palette.background;
        return Scaffold(
          backgroundColor: bg,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: IntroFrame('three_intro/index.html', onLoad: _onIntroLoaded)),
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [bg.op(0.55), bg.op(0.05), bg.op(0.55)],
                      stops: const [0, 0.55, 1],
                    ),
                  ),
                ),
              ),
              IgnorePointer(child: FadeTransition(opacity: _ui, child: _TopBar(mobile: mobile))),
              Align(
                alignment: Alignment(0, mobile ? -0.42 : -0.55),
                child: FadeTransition(opacity: _ui, child: _Hero(mobile: mobile, onEnter: _enter)),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(child: FadeTransition(opacity: _ui, child: _StatusBar(mobile: mobile))),
              ),
              IgnorePointer(
                ignoring: _ready,
                child: FadeTransition(opacity: _loading, child: _ConnectingOverlay()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.mobile, required this.onEnter});

  final bool mobile;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final side = mobile ? 24.0 : 56.0;
    final muted = Palette.muted;
    return Padding(
      padding: EdgeInsets.fromLTRB(side, 0, side, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 24, height: 1, color: muted),
                const SizedBox(width: 12),
                Text('BACKEND · INFRA · DATA', style: label(muted, 11, letterSpacing: 3)),
                const SizedBox(width: 12),
                Container(width: 24, height: 1, color: muted),
              ],
            ),
            SizedBox(height: mobile ? 22 : 30),
            Text(
              '조호성',
              textAlign: TextAlign.center,
              style: label(Palette.ink, mobile ? 52 : 92, letterSpacing: -2, height: 1),
            ),
            SizedBox(height: mobile ? 14 : 18),
            Text(
              'Building reliable backend systems for data-heavy era.',
              textAlign: TextAlign.center,
              style: label(Palette.ink.op(0.78), mobile ? 14 : 17, height: 1.55),
            ),
            SizedBox(height: mobile ? 24 : 32),
            PointerInterceptor(child: _EnterButton(onTap: onEnter)),
          ],
        ),
      ),
    );
  }
}

class _EnterButton extends StatelessWidget {
  const _EnterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) {
        final fg = hovered ? Palette.buttonInk : Palette.ink;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: easeOut,
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
          decoration: BoxDecoration(
            color: hovered ? null : Palette.glass.op(0.18),
            gradient: hovered ? pastelGradient(0.86) : null,
            border: Border.all(color: Palette.ink.op(0.32)),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              ...softShadows(),
              if (hovered)
                BoxShadow(color: Palette.pastelBlue.op(0.36), offset: const Offset(0, 8), blurRadius: 36),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter portfolio', style: label(fg, 14, letterSpacing: 0.3)),
              const SizedBox(width: 10),
              AnimatedSlide(
                offset: hovered ? const Offset(0.25, 0) : Offset.zero,
                duration: const Duration(milliseconds: 220),
                child: Icon(Icons.arrow_forward, color: fg, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final side = mobile ? 24.0 : 56.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(side, mobile ? 28 : 40, side, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandMark(glowBlur: 14),
          const Spacer(),
          if (!mobile) Text('PORTFOLIO · 2026', style: label(Palette.muted, 11, letterSpacing: 3)),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final side = mobile ? 24.0 : 56.0;
    final children = <Widget>[];
    for (var i = 0; i < 3; i++) {
      if (mobile && i > 0) {
        children.add(const SizedBox.shrink());
      } else {
        children.add(_StatusItem(statusItems[i]));
      }
      if (i != 2 && !mobile) {
        children.addAll([
          const SizedBox(width: 32),
          Container(width: 1, height: 22, color: Palette.border),
          const SizedBox(width: 32),
        ]);
      }
    }
    children.add(const Spacer());
    if (!mobile) {
      children.add(Row(
        children: [
          GlowDot(color: Palette.teal, size: 6, blur: 8, glow: 0.7),
          const SizedBox(width: 8),
          Text('ONLINE', style: label(Palette.muted, 10, letterSpacing: 2)),
        ],
      ));
    }
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(side, 18, side, 18),
          decoration: BoxDecoration(
            color: Palette.background.op(0.42),
            border: Border(top: BorderSide(color: Palette.border.op(0.8))),
          ),
          child: Row(children: children),
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem(this.item);

  final LabelValue item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.label, style: label(Palette.muted.op(0.7), 10, letterSpacing: 2)),
        const SizedBox(width: 8),
        Text(item.value, style: label(Palette.ink, 11, letterSpacing: 1.5)),
      ],
    );
  }
}

/// "접속중..." screen shown until the intro scene has loaded.
class _ConnectingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Palette.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('접속중...', style: label(Palette.ink.op(0.12), 88, letterSpacing: -3)),
            const SizedBox(height: 36),
            const _PulseDot(),
          ],
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final accent = Palette.accent;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: accent.op(0.3 + 0.7 * t),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: accent.op(0.55 * t), blurRadius: 20 * t)],
          ),
        );
      },
    );
  }
}
