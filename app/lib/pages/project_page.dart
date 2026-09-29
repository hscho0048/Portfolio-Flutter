import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final index = projects.indexWhere((p) => p.slug == slug);
    return ValueListenableBuilder(
      valueListenable: terminalColorMode,
      builder: (context, mode, child) => Scaffold(
        backgroundColor: Palette.background,
        body: index < 0 ? _NotFound() : _ProjectView(index: index),
      ),
    );
  }
}

void _backToPortfolio(BuildContext context) => Navigator.of(context).pushReplacementNamed('/portfolio');

class _ProjectView extends StatelessWidget {
  const _ProjectView({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 760;
    final project = projects[index];
    final next = index < projects.length - 1 ? projects[index + 1] : null;
    return Stack(
      children: [
        PageBackground(soft: true),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(mobile: mobile),
              _Header(project: project, index: index, mobile: mobile),
              _Cover(project: project, mobile: mobile),
              _Meta(project: project, mobile: mobile),
              _Body(project: project, mobile: mobile),
              _NextProject(next: next, mobile: mobile),
              SiteFooter(horizontal: mobile ? 24 : 56),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final h = mobile ? 22.0 : 56.0;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(h, 20, h, 20),
          decoration: BoxDecoration(
            color: Palette.background.op(0.65),
            border: Border(bottom: BorderSide(color: Palette.border, width: 0.5)),
          ),
          child: Row(
            children: [
              Hoverable(
                onTap: () => _backToPortfolio(context),
                builder: (context, hovered) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSlide(
                      offset: hovered ? const Offset(-0.2, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.arrow_back, color: Palette.ink, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'All work',
                      style: label(hovered ? Palette.ink : Palette.muted, 13, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              BrandMark(),
              const Spacer(),
              ThemeToggleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Centers [child] in a 1280px column with the page's side padding.
class _Band extends StatelessWidget {
  const _Band({required this.padding, required this.child});

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Center(
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1280), child: child),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.project, required this.index, required this.mobile});

  final Project project;
  final int index;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final number = (index >= 0 ? index + 1 : 1).toString().padLeft(2, '0');
    final accent = Palette.accent;
    return _Band(
      padding: EdgeInsets.fromLTRB(mobile ? 24 : 56, mobile ? 60 : 110, mobile ? 24 : 56, mobile ? 30 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Eyebrow('$number · PROJECT'),
              const SizedBox(width: 12),
              if (project.featured)
                Eyebrow(
                  'FEATURED',
                  color: accent,
                  background: accent.op(0.12),
                  borderColor: accent.op(0.4),
                ),
            ],
          ),
          SizedBox(height: mobile ? 24 : 40),
          Text(
            project.title,
            style: label(Palette.ink, mobile ? 36 : 76, letterSpacing: -2.4, height: 1.02)
                .copyWith(shadows: textShadows()),
          ),
          SizedBox(height: mobile ? 18 : 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Text(project.summary, style: label(Palette.muted, mobile ? 16 : 20, height: 1.55)),
          ),
          if (project.githubUrl != null || project.demoUrl != null) ...[
            SizedBox(height: mobile ? 22 : 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (project.githubUrl != null)
                  _LinkButton(Icons.code_rounded, 'GitHub', project.githubUrl!,
                      primary: project.demoUrl == null, mobile: mobile),
                if (project.demoUrl != null)
                  _LinkButton(Icons.open_in_new_rounded, 'Live Demo', project.demoUrl!,
                      primary: true, mobile: mobile),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton(this.icon, this.text, this.url, {required this.primary, required this.mobile});

  final IconData icon;
  final String text;
  final String url;
  final bool primary;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final fg = primary ? Palette.buttonInk : Palette.ink;
    final h = mobile ? 18.0 : 22.0;
    final v = mobile ? 13.0 : 15.0;
    return Hoverable(
      onTap: () => openUrl(Uri.parse(url)),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: easeOut,
        padding: EdgeInsets.fromLTRB(h, v, h, v),
        transform: hovered ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: primary ? null : (hovered ? Palette.ink.op(0.08) : Palette.glass.op(0.38)),
          gradient: primary ? pastelGradient(hovered ? 0.96 : 0.78) : null,
          border: Border.all(color: primary ? Palette.ink.op(0.16) : Palette.border),
          borderRadius: BorderRadius.circular(999),
          boxShadow: primary ? softShadows() : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 9),
            Text(text, style: label(fg, mobile ? 13 : 14)),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.project, required this.mobile});

  final Project project;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final h = mobile ? 24.0 : 56.0;
    final radius = BorderRadius.circular(mobile ? 14 : 22);
    return Padding(
      padding: EdgeInsets.fromLTRB(h, 0, h, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: ClipRRect(
            borderRadius: radius,
            child: Container(
              decoration: BoxDecoration(
                color: Palette.surface,
                border: Border.all(color: Palette.border),
                borderRadius: radius,
              ),
              child: AspectRatio(
                aspectRatio: mobile ? 16 / 9 : 7 / 3,
                child: Image.asset(
                  project.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.image_outlined, color: Palette.muted, size: 48)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.project, required this.mobile});

  final Project project;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final items = [
      LabelValue('CATEGORY', project.category),
      if (project.period.trim().isNotEmpty) LabelValue('PERIOD', project.period),
      LabelValue('STATUS', project.status == ProjectStatus.completed ? 'Deployed' : 'In Progress'),
      LabelValue('STACK', '${project.stack.length} tools'),
    ];
    return _Band(
      padding: EdgeInsets.fromLTRB(mobile ? 24 : 56, mobile ? 36 : 60, mobile ? 24 : 56, mobile ? 20 : 36),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 760 ? items.length : 2;
          final width = constraints.maxWidth / columns;
          return Wrap(
            runSpacing: 24,
            children: [
              for (var i = 0; i < items.length; i++)
                SizedBox(
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[i].label, style: label(Palette.muted, 10, letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text(
                          items[i].value,
                          style: label(Palette.ink, mobile ? 16 : 20, letterSpacing: -0.4, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.project, required this.mobile});

  final Project project;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    if (project.sections.isNotEmpty) {
      for (final section in project.sections) {
        blocks.add(_Block(section.label, section.title, mobile: mobile, child: _content(section)));
      }
      if (project.stack.isNotEmpty) {
        blocks.add(_Block('TECH STACK', '기술스택.', mobile: mobile, child: _StackGroups(project.stack, mobile: mobile)));
      }
    } else {
      blocks.add(_Block('OVERVIEW', 'What this is.', mobile: mobile, child: _bodyText(project.overview)));
      if (project.stack.isNotEmpty) {
        blocks.add(_Block('TECH STACK', "How it's built.", mobile: mobile, child: _StackGroups(project.stack, mobile: mobile)));
      }
    }
    final h = mobile ? 24.0 : 56.0;
    final v = mobile ? 30.0 : 50.0;
    return _Band(
      padding: EdgeInsets.fromLTRB(h, v, h, v),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: blocks),
    );
  }

  Widget _bodyText(String text) =>
      Text(text, style: label(Palette.ink.op(0.88), mobile ? 16 : 18, height: 1.7));

  Widget _content(DetailSection section) => switch (section.type) {
        DetailSectionType.text => _bodyText(section.body ?? ''),
        DetailSectionType.bullets => _NumberedList(section.items, mobile: mobile),
        DetailSectionType.flowChips => _FlowChips(section.items),
        DetailSectionType.image => _SectionImage(section.image, mobile: mobile),
      };
}

class _Block extends StatelessWidget {
  const _Block(this.eyebrow, this.title, {required this.mobile, required this.child});

  final String eyebrow;
  final String title;
  final bool mobile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: mobile ? 56 : 96),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final heading = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow),
              const SizedBox(height: 18),
              Text(title, style: label(Palette.ink, mobile ? 28 : 44, letterSpacing: -1.2, height: 1.05)),
            ],
          );
          if (constraints.maxWidth < 860) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [heading, const SizedBox(height: 28), child],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(width: 320, child: heading), const SizedBox(width: 64), Expanded(child: child)],
          );
        },
      ),
    );
  }
}

class _NumberedList extends StatelessWidget {
  const _NumberedList(this.items, {required this.mobile});

  final List<String> items;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final v = mobile ? 14.0 : 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++)
          Container(
            padding: EdgeInsets.fromLTRB(0, v, 0, v),
            decoration: BoxDecoration(
              border: i == items.length - 1 ? null : Border(bottom: BorderSide(color: Palette.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 38,
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: label(Palette.accent, 12, letterSpacing: 1),
                  ),
                ),
                Expanded(
                  child: Text(items[i], style: label(Palette.ink.op(0.9), mobile ? 15 : 17, height: 1.6)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FlowChips extends StatelessWidget {
  const _FlowChips(this.items);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final teal = Palette.teal;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            decoration: BoxDecoration(
              color: teal.op(0.08),
              border: Border.all(color: teal.op(0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(items[i], style: label(teal, 12, letterSpacing: 0.2)),
          ),
          if (i != items.length - 1) Icon(Icons.arrow_forward, color: Palette.muted.op(0.6), size: 18),
        ],
      ],
    );
  }
}

class _SectionImage extends StatelessWidget {
  const _SectionImage(this.path, {required this.mobile});

  final String? path;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final image = path;
    if (image == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: BoxConstraints(maxHeight: mobile ? 260 : 420),
        decoration: BoxDecoration(
          color: Palette.surface,
          border: Border.all(color: Palette.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              Center(child: Icon(Icons.image_outlined, color: Palette.muted, size: 40)),
        ),
      ),
    );
  }
}

class _StackGroups extends StatelessWidget {
  const _StackGroups(this.stack, {required this.mobile});

  final List<TechItem> stack;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<TechItem>>{};
    for (final tech in stack) {
      final category = tech.category.trim().isEmpty ? 'ETC' : tech.category;
      groups.putIfAbsent(category, () => []).add(tech);
    }
    final h = mobile ? 16.0 : 22.0;
    final v = mobile ? 16.0 : 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Container(
              padding: EdgeInsets.fromLTRB(h, v, h, v),
              decoration: BoxDecoration(
                color: Palette.glass.op(0.7),
                border: Border.all(color: Palette.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.key.toUpperCase(), style: label(Palette.muted, 10, letterSpacing: 2)),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: [for (final t in group.value) _StackChip(t)]),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _StackChip extends StatelessWidget {
  const _StackChip(this.tech);

  final TechItem tech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      decoration: BoxDecoration(
        color: Palette.background.op(0.6),
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TechIcon(tech, size: 16),
          const SizedBox(width: 8),
          Text(tech.name, style: label(Palette.ink, 12)),
        ],
      ),
    );
  }
}

class _NextProject extends StatelessWidget {
  const _NextProject({required this.next, required this.mobile});

  final Project? next;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final project = next;
    final h = mobile ? 24.0 : 56.0;
    final v = mobile ? 60.0 : 100.0;
    return Hoverable(
      cursor: project == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onTap: project == null
          ? null
          : () => Navigator.of(context).pushReplacementNamed('/project/${Uri.encodeComponent(project.slug)}'),
      builder: (context, hovered) => Container(
        padding: EdgeInsets.fromLTRB(h, v, h, v),
        decoration: BoxDecoration(
          color: hovered && project != null ? Palette.glass.op(0.5) : null,
          border: Border(
            top: BorderSide(color: Palette.border),
            bottom: BorderSide(color: Palette.border),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: project == null ? _end(context) : _next(project, hovered),
          ),
        ),
      ),
    );
  }

  Widget _end(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('END OF WORK', style: label(Palette.muted, 11, letterSpacing: 3)),
          const SizedBox(height: 18),
          PrimaryPillButton('Back to portfolio', onTap: () => _backToPortfolio(context), linear: true),
        ],
      ),
    );
  }

  Widget _next(Project project, bool hovered) {
    final size = mobile ? 56.0 : 72.0;
    final big = hovered ? (mobile ? 32.0 : 56.0) : (mobile ? 28.0 : 50.0);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NEXT PROJECT', style: label(Palette.muted, 11, letterSpacing: 3)),
              SizedBox(height: mobile ? 14 : 22),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: label(Palette.ink, big, letterSpacing: -1.6, height: 1.05),
                child: Text(project.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 8),
              Text(project.category, style: label(Palette.muted, 13, letterSpacing: 1)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          transform: Matrix4.translationValues(hovered ? 8 : 0, hovered ? -8 : 0, 0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: hovered ? Palette.ink : Colors.transparent,
              border: Border.all(color: hovered ? Colors.transparent : Palette.border),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.north_east,
              color: hovered ? Palette.background : Palette.ink,
              size: mobile ? 24 : 30,
            ),
          ),
        ),
      ],
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageBackground(soft: true),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('404', style: label(Palette.ink, 120, letterSpacing: -4)),
              const SizedBox(height: 12),
              Text('project not found', style: label(Palette.muted, 14, letterSpacing: 2)),
              const SizedBox(height: 32),
              PrimaryPillButton('Back to portfolio', onTap: () => _backToPortfolio(context), linear: true),
            ],
          ),
        ),
      ],
    );
  }
}
