import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models.dart';
import '../theme.dart';

const email = 'chohosung27@gmail.com';
const githubUrl = 'https://github.com/hscho0048';

void openUrl(Uri uri) => launchUrl(uri);
void openEmail() => openUrl(Uri(scheme: 'mailto', path: email));
void openPhone() => openUrl(Uri(scheme: 'tel', path: '+82-10-9757-0148'));
void openGithub() => openUrl(Uri.parse(githubUrl));

/// MouseRegion + GestureDetector that rebuilds with the hover state.
class Hoverable extends StatefulWidget {
  const Hoverable({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor cursor;

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(context, _hovered),
      ),
    );
  }
}

class GlowDot extends StatelessWidget {
  const GlowDot({super.key, required this.color, this.size = 8, this.blur = 12, this.glow = 0.6});

  final Color color;
  final double size;
  final double blur;
  final double glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.op(glow), blurRadius: blur)],
      ),
    );
  }
}

/// Small bordered capsule used for section eyebrows ("01 · ABOUT").
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color, this.background, this.borderColor});

  final String text;
  final Color? color;
  final Color? background;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor ?? Palette.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: label(color ?? Palette.muted, 10, letterSpacing: 2.5)),
    );
  }
}

/// Pastel gradient pill with a north-east arrow.
class PrimaryPillButton extends StatelessWidget {
  const PrimaryPillButton(this.text, {super.key, required this.onTap, this.linear = false});

  final String text;
  final VoidCallback onTap;

  /// Back-to-portfolio variant: linear curve and a slightly softer glow.
  final bool linear;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: linear ? Curves.linear : easeOut,
        padding: const EdgeInsets.fromLTRB(26, 18, 26, 18),
        transform: hovered ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: pastelGradient(hovered ? 0.96 : 0.78),
          border: Border.all(color: Palette.ink.op(0.16)),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            ...liftShadows(),
            if (hovered)
              BoxShadow(
                color: Palette.pastelBlue.op(linear ? 0.36 : 0.42),
                offset: const Offset(0, 6),
                blurRadius: linear ? 32 : 34,
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: label(Palette.buttonInk, 14, letterSpacing: linear ? null : 0)),
            const SizedBox(width: 10),
            const Icon(Icons.north_east, color: Palette.buttonInk, size: 16),
          ],
        ),
      ),
    );
  }
}

class SecondaryPillButton extends StatelessWidget {
  const SecondaryPillButton(this.text, {super.key, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(26, 18, 26, 18),
        decoration: BoxDecoration(
          color: hovered ? Palette.glass.op(0.68) : Colors.transparent,
          border: Border.all(color: Palette.border),
          borderRadius: BorderRadius.circular(999),
          boxShadow: hovered ? softShadows() : [],
        ),
        child: Text(text, style: label(Palette.ink, 14)),
      ),
    );
  }
}

/// Square tile with a devicon / fontawesome SVG.
class TechIcon extends StatelessWidget {
  const TechIcon(this.tech, {super.key, required this.size});

  final TechItem tech;
  final double size;

  @override
  Widget build(BuildContext context) {
    final pad = size <= 20 ? 3.0 : 5.0;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: Colors.white.op(isLight ? 0.94 : 0.9),
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(2),
        boxShadow: isLight
            ? [
                BoxShadow(color: Colors.white.op(0.55), offset: const Offset(-3, -3), blurRadius: 10),
                BoxShadow(color: Palette.shadowCool.op(0.18), offset: const Offset(4, 5), blurRadius: 12),
              ]
            : [BoxShadow(color: Colors.black.op(0.32), offset: const Offset(4, 5), blurRadius: 10)],
      ),
      child: _TechGlyph(tech.icon, Color(tech.color)),
    );
  }
}

class _TechGlyph extends StatelessWidget {
  const _TechGlyph(this.path, this.color);

  final String path;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final devicon = path.startsWith('assets/devicons/');
    final fontawesome = path.startsWith('assets/fontawesome/');
    final fallback = Icon(Icons.code_rounded, color: color, size: 14);
    if (!devicon && !fontawesome) return fallback;
    return SvgPicture.asset(
      path,
      fit: BoxFit.contain,
      colorFilter: fontawesome ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}

/// Layered gradient backdrop behind the portfolio (and, softer, project) pages.
class PageBackground extends StatelessWidget {
  const PageBackground({super.key, this.soft = false});

  final bool soft;

  @override
  Widget build(BuildContext context) {
    final light = isLight;
    final third = light ? (soft ? const Color(0xEEF4F4F4) : Palette.backgroundHighlight) : Palette.surface;
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Palette.backgroundDeep, Palette.background, third],
                  stops: soft ? null : const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.op(light ? (soft ? 0.22 : 0.28) : (soft ? 0.06 : 0.07)),
                    Colors.transparent,
                    Colors.black.op(light ? (soft ? 0.05 : 0.06) : (soft ? 0.28 : 0.3)),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: pastelGradient(light ? (soft ? 0.1 : 0.12) : (soft ? 0.03 : 0.035)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.fontSize = 12, this.letterSpacing = 2.5, this.glowBlur = 12});

  final double fontSize;
  final double letterSpacing;
  final double glowBlur;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlowDot(color: Palette.accent, blur: glowBlur),
        const SizedBox(width: 12),
        Text('CHO HOSUNG', style: label(Palette.ink, fontSize, letterSpacing: letterSpacing)),
      ],
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined, color: Palette.ink, size: 18),
      onPressed: terminalColorMode.toggle,
      tooltip: isLight ? 'Dark mode' : 'Light mode',
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.horizontal, this.bordered = false});

  final double horizontal;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final style = label(Palette.muted, 11, letterSpacing: 1.5);
    return Container(
      padding: EdgeInsets.fromLTRB(horizontal, 32, horizontal, 32),
      decoration: bordered ? BoxDecoration(border: Border(top: BorderSide(color: Palette.border))) : null,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            children: [
              Text('© 2026 CHO HOSUNG', style: style),
              const Spacer(),
              Text('Built with Flutter', style: style),
            ],
          ),
        ),
      ),
    );
  }
}
