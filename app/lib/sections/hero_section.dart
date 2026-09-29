import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.headerHeight,
    required this.mobile,
    required this.onSeeWork,
    required this.onContact,
  });

  final double headerHeight;
  final bool mobile;
  final VoidCallback onSeeWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height.clamp(640.0, 980.0);
    final side = mobile ? 24.0 : 56.0;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: mobile ? -40 : -20,
            top: headerHeight + (mobile ? 12 : 28),
            child: IgnorePointer(child: _Outline2026(mobile: mobile)),
          ),
          Positioned(
            left: side,
            right: side,
            top: headerHeight,
            bottom: 80,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 24, height: 1, color: Palette.muted),
                              const SizedBox(width: 12),
                              Text('PORTFOLIO · 2026', style: label(Palette.muted, 11, letterSpacing: 3)),
                            ],
                          ),
                          SizedBox(height: mobile ? 20 : 28),
                          Text(
                            mobile
                                ? 'Backend for\nthe big\ndata era.'
                                : 'Building reliable\nbackend systems for\ndata-heavy products.',
                            style: label(Palette.ink, mobile ? 44 : 96, letterSpacing: 0, height: 0.98)
                                .copyWith(shadows: textShadows()),
                          ),
                          SizedBox(height: mobile ? 22 : 32),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: Text(
                              '조호성 — 데이터가 많이 오가는 서비스의 백엔드를 만드는 엔지니어입니다.',
                              style: label(Palette.ink.op(0.78), mobile ? 15 : 18, height: 1.6),
                            ),
                          ),
                          SizedBox(height: mobile ? 28 : 40),
                          Wrap(
                            spacing: 14,
                            runSpacing: 14,
                            children: [
                              PrimaryPillButton('See selected work', onTap: onSeeWork),
                              SecondaryPillButton('Get in touch', onTap: onContact),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!mobile) _ScrollCue(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: TechMarquee()),
        ],
      ),
    );
  }
}

/// Three stacked outlined "2026" numerals behind the headline.
class _Outline2026 extends StatelessWidget {
  const _Outline2026({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final size = mobile ? 220.0 : 420.0;
    final ink = Palette.ink;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.translate(
          offset: const Offset(12, 12),
          child: _OutlineText(size: size, color: ink.op(isLight ? 0.045 : 0.08), stroke: 1.6),
        ),
        Transform.translate(
          offset: const Offset(6, 6),
          child: _OutlineText(
            size: size,
            color: ink.op(isLight ? 0.07 : 0.12),
            stroke: 1.35,
            shadows: textShadows(),
          ),
        ),
        _OutlineText(
          size: size,
          color: ink.op(isLight ? 0.1 : 0.18),
          stroke: 1.15,
          shadows: [
            Shadow(
              color: isLight ? Colors.white.op(0.68) : Palette.pastelBlue.op(0.12),
              offset: const Offset(-1.2, -1.2),
              blurRadius: 2,
            ),
          ],
        ),
      ],
    );
  }
}

class _OutlineText extends StatelessWidget {
  const _OutlineText({required this.size, required this.color, required this.stroke, this.shadows});

  final double size;
  final Color color;
  final double stroke;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Text(
      '2026',
      style: TextStyle(
        fontFamily: 'Arial',
        fontSize: size,
        fontWeight: FontWeight.w600,
        height: 0.85,
        letterSpacing: 0,
        shadows: shadows,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = color,
      ),
    );
  }
}

class _ScrollCue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(quarterTurns: 1, child: Text('SCROLL', style: label(Palette.muted, 10, letterSpacing: 3))),
        const SizedBox(height: 12),
        Container(width: 1, height: 48, color: Palette.muted.op(0.5)),
      ],
    );
  }
}

/// Endless horizontal strip of toolkit names at the bottom of the hero.
class TechMarquee extends StatefulWidget {
  const TechMarquee({super.key});

  @override
  State<TechMarquee> createState() => _TechMarqueeState();
}

class _TechMarqueeState extends State<TechMarquee> with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  late final List<String> _names;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final names = toolkit.map((t) => t.name).toList();
    _names = [...names, ...names, ...names];
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 120))
      ..addListener(_tick);
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.repeat());
  }

  void _tick() {
    if (!_scroll.hasClients) return;
    final max = _scroll.positions.last.maxScrollExtent;
    if (max <= 0) return;
    _scroll.jumpTo((_controller.value * max) % max);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ink = Palette.ink;
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Palette.border),
          bottom: BorderSide(color: Palette.border),
        ),
      ),
      child: SizedBox(
        height: 22,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, ink, ink, Colors.transparent],
            stops: const [0, 0.06, 0.94, 1],
          ).createShader(rect),
          child: ListView.separated(
            controller: _scroll,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _names.length,
            itemBuilder: (context, i) => Center(
              child: Text(_names[i].toUpperCase(), style: label(Palette.muted, 12, letterSpacing: 2.5)),
            ),
            separatorBuilder: (context, i) => Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(color: Palette.accent, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
