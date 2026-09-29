import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../pages/portfolio_page.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      eyebrow: '01 · ABOUT',
      title: 'On the work.',
      mobile: mobile,
      gap: mobile ? 36 : 52,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileCard(mobile: mobile),
          const SizedBox(height: 24),
          _Stats(),
          const SizedBox(height: 56),
          _ToolkitCard(items: toolkit.take(21).toList()),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final pad = mobile ? 18.0 : 24.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Palette.glass.op(0.9), Palette.surface.op(0.68)],
            ),
            border: Border.all(color: Palette.border),
            borderRadius: BorderRadius.circular(24),
            boxShadow: liftShadows(),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final intro = _Intro(mobile: mobile);
              final photo = _Photo(mobile: mobile);
              if (width < 900) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [intro, const SizedBox(height: 24), photo],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: intro),
                  const SizedBox(width: 30),
                  SizedBox(width: width < 1120 ? 360 : 430, child: photo),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 10, runSpacing: 10, children: [for (final chip in aboutChips) _RoleChip(chip)]),
        SizedBox(height: mobile ? 22 : 30),
        Text(
          '조호성',
          style: label(Palette.ink, mobile ? 34 : 52, letterSpacing: -0.8, height: 0.95)
              .copyWith(shadows: textShadows()),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            '분산 시스템과 클라우드 위에 서비스를 올리고 오래 버티게 합니다.',
            style: label(Palette.ink, mobile ? 19 : 25, letterSpacing: -0.2, height: 1.38),
          ),
        ),
        SizedBox(height: mobile ? 24 : 34),
        _ContactRow(Icons.mail_outline_rounded, 'Email', email, onTap: openEmail),
        _ContactRow(Icons.call_outlined, 'Phone', '82-10-9757-0148', onTap: openPhone),
        _ContactRow(Icons.code_rounded, 'GitHub', 'github.com/hscho0048', onTap: openGithub),
        SizedBox(height: mobile ? 22 : 30),
        _Traits(),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
      decoration: BoxDecoration(
        color: Palette.teal.op(0.1),
        border: Border.all(color: Palette.teal.op(0.22)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: label(Palette.muted, 11, letterSpacing: 0.8)),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow(this.icon, this.name, this.value, {required this.onTap});

  final IconData icon;
  final String name;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Palette.border))),
        child: Row(
          children: [
            Icon(icon, color: Palette.teal, size: 20),
            const SizedBox(width: 12),
            SizedBox(width: 66, child: Text(name, style: label(Palette.muted, 12))),
            Expanded(
              child: Text(value, overflow: TextOverflow.ellipsis, style: label(Palette.ink, 15)),
            ),
            Icon(Icons.north_east_rounded, color: Palette.muted, size: 16),
          ],
        ),
      ),
    );
  }
}

class _Traits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardWidth = width >= 560 ? (width - 12) / 2 : width;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final trait in traits.take(4))
              SizedBox(
                width: cardWidth,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                  decoration: BoxDecoration(
                    color: Palette.surface.op(0.35),
                    border: Border.all(color: Palette.border),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trait.label, style: label(Palette.ink, 14)),
                      const SizedBox(height: 8),
                      Text(trait.value, style: label(Palette.muted, 13, height: 1.45)),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final pad = mobile ? 10.0 : 12.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: Palette.glass.op(0.72),
          border: Border.all(color: Palette.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: AspectRatio(
          aspectRatio: mobile ? 0.82 : 0.72,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/hosung.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Palette.surface,
                child: Icon(Icons.account_circle, color: Palette.muted, size: mobile ? 72 : 96),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  static const _stats = [
    LabelValue('15', 'projects shipped'),
    LabelValue('6', 'awards earned'),
    LabelValue('21+', 'tools in toolkit'),
  ];

  @override
  Widget build(BuildContext context) {
    final divider = Palette.border;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final children = <Widget>[];
          for (var i = 0; i < 3; i++) {
            final stat = _stats[i];
            if (wide) {
              children.add(Expanded(child: _Stat(value: stat.label, name: stat.value, wide: true)));
              if (i != 2) children.add(Container(width: 1, height: 48, color: divider));
            } else {
              children.add(_Stat(value: stat.label, name: stat.value, wide: false));
              if (i != 2) children.add(Container(height: 1, color: divider));
            }
          }
          return wide ? Row(children: children) : Column(children: children);
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.name, required this.wide});

  final String value;
  final String name;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final nameText = Text(name, style: label(Palette.muted, 13));
    final valueText = Text(value, style: label(Palette.ink, 22, letterSpacing: -0.8));
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: wide
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [nameText, const SizedBox(height: 6), valueText],
            )
          : Row(children: [Expanded(child: nameText), valueText]),
    );
  }
}

List<ToolkitGroup> _groups(List<TechItem> items) {
  List<TechItem> of(String category) => items.where((t) => t.category == category).toList();
  return [
    ToolkitGroup('CLOUD', const Color(0xFF4285F4), of('Cloud'), 250),
    ToolkitGroup('BACKEND', const Color(0xFF5FA04E), of('Backend'), 540),
    ToolkitGroup('DATABASE', const Color(0xFFF7931E), of('Database'), 450),
    ToolkitGroup('LANGUAGE', const Color(0xFF5FA04E), of('Language'), 500),
    ToolkitGroup('AI / DATA', const Color(0xFFF7931E), of('AI/Data'), 320),
    ToolkitGroup('WORKFLOW', const Color(0xFFFF7262), of('ETC'), 300),
    ToolkitGroup('MATERIALS', const Color(0xFF00B881), of('Materials'), 540),
  ].where((g) => g.items.isNotEmpty).toList();
}

class _ToolkitCard extends StatelessWidget {
  const _ToolkitCard({required this.items});

  final List<TechItem> items;

  @override
  Widget build(BuildContext context) {
    final groups = _groups(items);
    final teal = Palette.teal;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Palette.glass.op(0.62),
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(8),
        boxShadow: softShadows(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GlowDot(color: teal, size: 8, blur: 10, glow: 0.55),
              const SizedBox(width: 10),
              Text('TOOLKIT', style: label(Palette.muted, 11, letterSpacing: 2.5)),
              const Spacer(),
              Text('${items.length} CORE', style: label(Palette.muted.op(0.72), 10, letterSpacing: 1.4)),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final narrow = width < 760;
              return Wrap(
                spacing: narrow ? 18 : 28,
                runSpacing: 22,
                children: [
                  for (final group in groups) _Group(group, width: narrow ? width : group.width),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group(this.group, {required this.width});

  final ToolkitGroup group;
  final double width;

  @override
  Widget build(BuildContext context) {
    final color = group.color;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GlowDot(color: color, size: 7, blur: 8, glow: 0.42),
              const SizedBox(width: 8),
              Text(group.label, style: label(Palette.muted, 10, letterSpacing: 1.8)),
              const SizedBox(width: 10),
              Expanded(child: Container(height: 1, color: color.op(0.24))),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 10, runSpacing: 10, children: [for (final t in group.items) _ToolChip(t)]),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip(this.tech);

  final TechItem tech;

  @override
  Widget build(BuildContext context) {
    final color = Color(tech.color);
    return Hoverable(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovered) => AnimatedScale(
        scale: hovered ? 1.025 : 1,
        curve: easeOutCubic,
        duration: const Duration(milliseconds: 160),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: easeOutCubic,
          padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Palette.background.op(0.78), Color.lerp(Palette.glass, color, 0.1)!.op(0.82)],
            ),
            border: Border.all(color: hovered ? color.op(0.58) : Palette.border),
            borderRadius: BorderRadius.circular(999),
            boxShadow: hovered
                ? [BoxShadow(color: color.op(0.18), offset: const Offset(0, 9), blurRadius: 18)]
                : softShadows(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TechIcon(tech, size: 22),
              const SizedBox(width: 9),
              Text(tech.name, style: label(Palette.ink, 13, letterSpacing: 0)),
              const SizedBox(width: 9),
              GlowDot(color: color, size: 5, blur: 8, glow: 0.45),
            ],
          ),
        ),
      ),
    );
  }
}
