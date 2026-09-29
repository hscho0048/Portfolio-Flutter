import 'dart:ui';

import 'package:flutter/material.dart';

import '../sections/about_section.dart';
import '../sections/awards_section.dart';
import '../sections/contact_section.dart';
import '../sections/hero_section.dart';
import '../sections/work_section.dart';
import '../theme.dart';
import '../widgets/common.dart';

const _headerHeight = 72.0;

/// Single scrolling page: home, about, work, awards, contact.
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, this.initialSection});

  /// Section to jump to on open ('/desktop' route arguments).
  final String? initialSection;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _keys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'work': GlobalKey(),
    'awards': GlobalKey(),
    'contact': GlobalKey(),
  };
  String _active = 'home';
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    final initial = widget.initialSection;
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(initial, animate: false));
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scroll.positions.last.pixels;
    var active = 'home';
    for (final entry in _keys.entries) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      if (box.localToGlobal(Offset.zero).dy - _headerHeight - 40 <= 0) active = entry.key;
    }
    final scrolled = offset > 8;
    if (active != _active || scrolled != _scrolled) {
      setState(() {
        _active = active;
        _scrolled = scrolled;
      });
    }
  }

  void _scrollTo(String section, {bool animate = true}) {
    final box = _keys[section]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final position = _scroll.positions.last;
    final target = (box.localToGlobal(Offset.zero).dy + position.pixels - _headerHeight)
        .clamp(0.0, position.maxScrollExtent);
    if (animate) {
      _scroll.animateTo(target, curve: easeOutCubic, duration: const Duration(milliseconds: 700));
    } else {
      _scroll.jumpTo(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: terminalColorMode,
      builder: (context, mode, child) {
        final mobile = MediaQuery.sizeOf(context).width < 760;
        return Scaffold(
          backgroundColor: Palette.background,
          body: Stack(
            children: [
              PageBackground(),
              SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KeyedSubtree(
                      key: _keys['home'],
                      child: HeroSection(
                        headerHeight: _headerHeight,
                        mobile: mobile,
                        onSeeWork: () => _scrollTo('work'),
                        onContact: () => _scrollTo('contact'),
                      ),
                    ),
                    KeyedSubtree(key: _keys['about'], child: AboutSection(mobile: mobile)),
                    KeyedSubtree(key: _keys['work'], child: WorkSection(mobile: mobile)),
                    KeyedSubtree(key: _keys['awards'], child: AwardsSection(mobile: mobile)),
                    KeyedSubtree(key: _keys['contact'], child: ContactSection(mobile: mobile)),
                    SiteFooter(horizontal: mobile ? 24 : 56, bordered: true),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: _Header(
                  active: _active,
                  scrolled: _scrolled,
                  mobile: mobile,
                  onNavigate: _scrollTo,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.active,
    required this.scrolled,
    required this.mobile,
    required this.onNavigate,
  });

  final String active;
  final bool scrolled;
  final bool mobile;
  final void Function(String section) onNavigate;

  @override
  Widget build(BuildContext context) {
    final horizontal = mobile ? 22.0 : 56.0;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _headerHeight,
          padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 0),
          decoration: BoxDecoration(
            color: scrolled ? Palette.background.op(0.65) : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: scrolled ? Palette.border : Colors.transparent, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Hoverable(
                onTap: () => onNavigate('home'),
                builder: (context, hovered) => BrandMark(fontSize: 13, letterSpacing: 2),
              ),
              const Spacer(),
              if (!mobile) ...[
                _NavItem('About', '01', active: active == 'about', onTap: () => onNavigate('about')),
                _NavItem('Work', '02', active: active == 'work', onTap: () => onNavigate('work')),
                _NavItem('Awards', '03', active: active == 'awards', onTap: () => onNavigate('awards')),
                _NavItem('Contact', '04', active: active == 'contact', onTap: () => onNavigate('contact')),
                const SizedBox(width: 16),
              ],
              ThemeToggleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(this.text, this.number, {required this.active, required this.onTap});

  final String text;
  final String number;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(number, style: label(Palette.muted.op(0.6), 10, letterSpacing: 1)),
            const SizedBox(width: 8),
            Text(text, style: label(active || hovered ? Palette.ink : Palette.muted, 13, letterSpacing: 0)),
          ],
        ),
      ),
    );
  }
}

/// Padded, width-capped section with an eyebrow pill and a large title.
class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.mobile,
    required this.child,
    this.tinted = false,
    this.gap,
  });

  final String eyebrow;
  final String title;
  final bool mobile;
  final Widget child;
  final bool tinted;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final h = mobile ? 24.0 : 56.0;
    final v = mobile ? 80.0 : 140.0;
    return Container(
      width: double.infinity,
      color: tinted ? Palette.glass.op(0.32) : null,
      padding: EdgeInsets.fromLTRB(h, v, h, v),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Eyebrow(eyebrow),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      title,
                      style: label(Palette.ink, mobile ? 30 : 56, letterSpacing: -1.4, height: 1)
                          .copyWith(shadows: textShadows()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap ?? (mobile ? 48 : 80)),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
