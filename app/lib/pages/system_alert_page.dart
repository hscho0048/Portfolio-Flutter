import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

enum TerminalSection { home, about, projects, contact }

/// Unknown routes land here: a terminal-style shell with a "System Alert" panel.
class SystemAlertPage extends StatelessWidget {
  const SystemAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = Palette.accent;
    return _TerminalShell(
      section: TerminalSection.home,
      onSelect: (section) {
        final navigator = Navigator.of(context);
        if (section == TerminalSection.home) {
          navigator.pushReplacementNamed('/');
        } else {
          navigator.pushReplacementNamed('/desktop', arguments: section);
        }
      },
      child: Center(
        child: _Panel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: accent, size: 58),
              const SizedBox(height: 14),
              Text(
                'System Alert',
                style: TextStyle(color: Palette.ink, fontFamily: 'A2Z', fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text('요청한 화면을 찾을 수 없습니다.', style: TextStyle(color: Palette.muted, fontFamily: 'A2Z')),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/desktop'),
                style: OutlinedButton.styleFrom(foregroundColor: accent, side: BorderSide(color: accent)),
                child: const Text('Back to Projects'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Palette.glass,
        border: Border.all(color: Palette.border),
        borderRadius: BorderRadius.circular(2),
        boxShadow: softShadows(),
      ),
      child: child,
    );
  }
}

class _TerminalShell extends StatelessWidget {
  const _TerminalShell({required this.section, required this.child, required this.onSelect});

  final TerminalSection section;
  final Widget child;
  final void Function(TerminalSection section) onSelect;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: terminalColorMode,
      builder: (context, mode, _) => Scaffold(
        backgroundColor: Palette.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 820;
            final left = wide ? 256.0 : 0.0;
            return Stack(
              fit: StackFit.expand,
              children: [
                _TerminalBackground(key: ValueKey('background-$mode')),
                Positioned(
                  left: left,
                  right: 0,
                  top: 52,
                  bottom: 42,
                  child: KeyedSubtree(key: ValueKey('terminal-body-$mode'), child: child),
                ),
                Positioned(left: 0, right: 0, top: 0, child: _TopBar(compact: !wide)),
                if (wide)
                  Positioned(
                    left: 0,
                    top: 52,
                    bottom: 42,
                    width: 256,
                    child: _Sidebar(section: section, onSelect: onSelect),
                  ),
                Positioned(left: left, right: 0, bottom: 0, child: _Footer(key: ValueKey('footer-$mode'))),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TerminalBackground extends StatelessWidget {
  const _TerminalBackground({super.key});

  // "SYS_INIT_v1.0.4 LOADING.Projects Module Initialized..." in binary, 44 rows.
  static final _ascii = List.filled(
    44,
    '01010011 01011001 01010011 01011111 01001001 01001110 01001001 01010100 01011111 01110110 '
    '00110001 00101110 00110000 00101110 00110100 00100000 01001100 01001111 01000001 01000100 '
    '01001001 01001110 01000111 00101110 01010000 01110010 01101111 01101010 01100101 01100011 '
    '01110100 01110011 00100000 01001101 01101111 01100100 01110101 01101100 01100101 00100000 '
    '01001001 01101110 01101001 01110100 01101001 01100001 01101100 01101001 01111010 01100101 '
    '01100100 00101110 00101110 00101110 ',
  ).join('\n');

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.terminalGradientStart, Palette.background, Palette.glass],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(decoration: BoxDecoration(gradient: pastelGradient(isLight ? 0.18 : 0.04))),
          CustomPaint(painter: _GridPainter(Palette.terminalGrid)),
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Text(
                _ascii,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(
                  color: Palette.terminalAscii,
                  fontFamily: 'A2Z',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.8,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => oldDelegate.color != color;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = Palette.accent;
    final h = compact ? 18.0 : 24.0;
    return Container(
      height: 52,
      padding: EdgeInsets.fromLTRB(h, 0, h, 0),
      decoration: BoxDecoration(
        color: Palette.terminalTopBar,
        border: Border(bottom: BorderSide(color: accent.op(0.2))),
      ),
      child: Row(
        children: [
          Text(
            'SYS_INIT_v1.0.4',
            style: TextStyle(
              color: accent,
              fontFamily: 'A2Z',
              fontSize: compact ? 13 : 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          Icon(Icons.terminal, color: accent, size: 20),
          const SizedBox(width: 12),
          Tooltip(
            message: isLight ? 'Dark mode' : 'Light mode',
            child: IconButton(
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode, color: accent, size: 20),
              onPressed: terminalColorMode.toggle,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.section, required this.onSelect});

  final TerminalSection section;
  final void Function(TerminalSection section) onSelect;

  @override
  Widget build(BuildContext context) {
    final accent = Palette.accent;
    final monoStyle = TextStyle(fontFamily: 'A2Z', fontSize: 12, fontWeight: FontWeight.w600);
    return Container(
      decoration: BoxDecoration(
        color: Palette.terminalSidebar,
        border: Border(right: BorderSide(color: accent.op(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(
                    'assets/hosung.jpg',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.account_circle, color: Palette.teal, size: 48),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ROOT_USER',
                        style: TextStyle(
                          color: accent,
                          fontFamily: 'A2Z',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: Palette.teal, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'status: online',
                            style: TextStyle(color: Palette.muted, fontFamily: 'A2Z', fontSize: 11, letterSpacing: 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: accent.op(0.1)),
          const SizedBox(height: 16),
          _SidebarItem(Icons.html, '01_home.exe', TerminalSection.home, active: section, onSelect: onSelect),
          _SidebarItem(Icons.description, '02_about.json', TerminalSection.about, active: section, onSelect: onSelect),
          _SidebarItem(Icons.terminal, '03_projects.sh', TerminalSection.projects, active: section, onSelect: onSelect),
          _SidebarItem(Icons.contact_mail, '04_contact.log', TerminalSection.contact, active: section, onSelect: onSelect),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18),
            child: OutlinedButton(
              onPressed: () => onSelect(TerminalSection.contact),
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                side: BorderSide(color: accent),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(r'$ sudo connect', style: monoStyle)),
                  const Text('_', style: TextStyle(fontFamily: 'A2Z')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem(this.icon, this.text, this.section, {required this.active, required this.onSelect});

  final IconData icon;
  final String text;
  final TerminalSection section;
  final TerminalSection active;
  final void Function(TerminalSection section) onSelect;

  @override
  Widget build(BuildContext context) {
    final selected = section == active;
    final accent = Palette.accent;
    return InkWell(
      onTap: () => onSelect(section),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: selected ? accent.op(0.1) : Colors.transparent,
          border: Border(left: BorderSide(color: selected ? accent : Colors.transparent, width: 2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? accent : Palette.muted, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: selected ? accent : Palette.muted.op(0.72),
                  fontFamily: 'A2Z',
                  fontSize: 14,
                  height: 1.4,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Palette.terminalFooter;
    final style = TextStyle(color: color, fontFamily: 'A2Z', fontSize: 10, letterSpacing: 0);
    return Container(
      height: 42,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Palette.border))),
      child: Row(
        children: [
          Text('(C) 2024 DEPLOYED_SYS_KERNEL', style: style),
          const Spacer(),
          _FooterLink('github', onTap: openGithub),
          const SizedBox(width: 18),
          _FooterLink('email', onTap: openEmail),
          const SizedBox(width: 18),
          Text('terminal_logs', style: style),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.text, {required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Palette.terminalFooter;
    return Hoverable(
      onTap: onTap,
      builder: (context, hovered) => Text(
        text,
        style: TextStyle(
          color: color,
          fontFamily: 'A2Z',
          fontSize: 10,
          decoration: TextDecoration.underline,
          decorationColor: color.op(0.6),
        ),
      ),
    );
  }
}
