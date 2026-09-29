import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../pages/portfolio_page.dart';
import '../theme.dart';
import '../widgets/common.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key, required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      eyebrow: '02 · WORK',
      title: 'Selected projects.',
      mobile: mobile,
      tinted: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < projects.length; i++)
            _ProjectRow(
              index: i + 1,
              project: projects[i],
              mobile: mobile,
              onTap: () => Navigator.of(context)
                  .pushNamed('/project/${Uri.encodeComponent(projects[i].slug)}'),
            ),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.index, required this.project, required this.mobile, required this.onTap});

  final int index;
  final Project project;
  final bool mobile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final h = mobile ? 4.0 : 8.0;
    final v = mobile ? 24.0 : 36.0;
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Palette.border))),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: hovered ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Palette.pastelBlue.op(0.16),
                        Palette.pastelViolet.op(0.12),
                        Palette.pastelPink.op(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(h, v, h, v),
              child: mobile ? _mobile() : _desktop(hovered),
            ),
          ],
        ),
      ),
    );
  }

  String get _number => index.toString().padLeft(2, '0');

  Widget _desktop(bool hovered) {
    final muted = Palette.muted;
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(_number, style: label(hovered ? Palette.accent : muted, 18, letterSpacing: -0.5)),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: label(Palette.ink, hovered ? 38 : 34, letterSpacing: -1.2, height: 1.1),
                child: Text(project.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 8),
              Text(project.category, style: label(muted, 13, letterSpacing: 1)),
            ],
          ),
        ),
        const SizedBox(width: 32),
        SizedBox(
          width: 220,
          height: 140,
          child: AnimatedScale(
            scale: hovered ? 1.04 : 1,
            duration: const Duration(milliseconds: 220),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Palette.surface,
                child: Image.asset(
                  project.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.image_outlined, color: muted)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(hovered ? 6 : 0, hovered ? -6 : 0, 0),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: hovered ? Palette.ink : Colors.transparent,
              border: Border.all(color: hovered ? Colors.transparent : Palette.border),
              boxShadow: hovered ? softShadows() : [],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.north_east, color: hovered ? Palette.background : Palette.ink, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _mobile() {
    final muted = Palette.muted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(_number, style: label(muted, 12)),
            const SizedBox(width: 14),
            Expanded(child: Text(project.category, style: label(muted, 11, letterSpacing: 1.2))),
            Icon(Icons.north_east, color: Palette.ink, size: 18),
          ],
        ),
        const SizedBox(height: 14),
        Text(project.title, style: label(Palette.ink, 22, letterSpacing: -0.8, height: 1.2)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 1.6,
            child: Container(
              color: Palette.surface,
              child: Image.asset(
                project.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
