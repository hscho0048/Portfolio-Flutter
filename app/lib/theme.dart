import 'package:flutter/material.dart';

enum TerminalColorMode { dark, light }

class TerminalColorModeController extends ValueNotifier<TerminalColorMode> {
  TerminalColorModeController(super.value);

  void toggle() => value = value == TerminalColorMode.light
      ? TerminalColorMode.dark
      : TerminalColorMode.light;
}

/// Global light/dark switch. Pages rebuild through a ValueListenableBuilder on
/// it, so widgets that read [Palette] must not be const.
final terminalColorMode = TerminalColorModeController(TerminalColorMode.light);

bool get isLight => terminalColorMode.value == TerminalColorMode.light;

/// Every color the site uses; light/dark pairs pick by [isLight].
abstract final class Palette {
  static Color get ink => isLight ? const Color(0xFF222832) : const Color(0xFFEEF3F8);
  static Color get muted => isLight ? const Color(0xFF657084) : const Color(0xFFAEBBD0);
  static Color get border => isLight ? const Color(0x55AEB6C5) : const Color(0x6674879C);
  static Color get accent => isLight ? const Color(0xFF6F7B90) : const Color(0xFFA8DFF3);
  static Color get teal => isLight ? const Color(0xFF7EA9B5) : const Color(0xFFBDEEE5);
  static Color get glass => isLight ? const Color(0xEEF4F4F4) : const Color(0xEE1B2533);
  static Color get background => isLight ? const Color(0xFFD9DADF) : const Color(0xFF121924);
  static Color get surface => isLight ? const Color(0xECECEEF3) : const Color(0xF0243042);
  static Color get backgroundDeep => isLight ? const Color(0xFFBFC3CC) : const Color(0xFF0B111A);
  static Color get error => isLight ? const Color(0xFF9C6F77) : pastelPink;

  static const buttonInk = Color(0xFF202734);
  static const backgroundHighlight = Color(0xFFEEF0F3);
  static const shadowCool = Color(0xFF8C97AA);
  static const textShadowLight = Color(0xFF7E899A);

  static const pastelBlue = Color(0xFFC9F1FF);
  static const pastelViolet = Color(0xFFE5D7FF);
  static const pastelPink = Color(0xFFFFD6E5);
  static const pastelYellow = Color(0xFFFFF1C7);
  static const pastelMint = Color(0xFFD6FFF2);

  // Terminal (system alert) screen.
  static Color get terminalFooter => isLight ? const Color(0xFF7B8496) : const Color(0xFF8F98AA);
  static Color get terminalSidebar => isLight ? const Color(0xDED1D5DC) : const Color(0xFF0F141E);
  static Color get terminalTopBar => isLight ? const Color(0xDDECEEF3) : const Color(0xCC111620);
  static Color get terminalGradientStart => isLight ? const Color(0xFFC8CBD2) : backgroundDeep;
  static Color get terminalGrid => isLight ? const Color(0x26AEB6C5) : const Color(0x18F4F4F4);
  static Color get terminalAscii => isLight ? const Color(0x1F758095) : const Color(0x24C9F1FF);
}

extension Alpha on Color {
  Color op(double alpha) => withValues(alpha: alpha);
}

const easeOutCubic = Cubic(0.215, 0.61, 0.355, 1);
const easeOut = Cubic(0, 0, 0.58, 1);

TextStyle label(Color color, double size, {double? letterSpacing, double? height}) => TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
      letterSpacing: letterSpacing,
      height: height,
    );

List<Shadow> textShadows() => isLight
    ? [
        Shadow(color: Colors.white.op(0.58), offset: const Offset(-1.4, -1.4), blurRadius: 2),
        Shadow(color: Palette.textShadowLight.op(0.34), offset: const Offset(0, 10), blurRadius: 20),
      ]
    : [
        Shadow(color: Colors.black.op(0.68), offset: const Offset(0, 12), blurRadius: 22),
        Shadow(color: Palette.pastelBlue.op(0.18), blurRadius: 18),
      ];

List<BoxShadow> softShadows() => isLight
    ? [
        BoxShadow(color: Colors.white.op(0.58), offset: const Offset(-8, -8), blurRadius: 18),
        BoxShadow(color: Palette.shadowCool.op(0.22), offset: const Offset(10, 12), blurRadius: 22),
      ]
    : [
        BoxShadow(color: Colors.black.op(0.38), offset: const Offset(10, 14), blurRadius: 26),
        BoxShadow(color: Palette.pastelViolet.op(0.08), offset: const Offset(-6, -6), blurRadius: 20),
      ];

List<BoxShadow> liftShadows() => isLight
    ? [
        BoxShadow(color: Colors.white.op(0.72), offset: const Offset(-12, -12), blurRadius: 28),
        BoxShadow(color: Palette.shadowCool.op(0.34), offset: const Offset(18, 20), blurRadius: 34),
      ]
    : [
        BoxShadow(color: Colors.black.op(0.56), offset: const Offset(18, 22), blurRadius: 38),
        BoxShadow(color: Palette.pastelBlue.op(0.12), offset: const Offset(-10, -10), blurRadius: 28),
      ];

LinearGradient pastelGradient(double opacity) => LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Palette.pastelBlue,
        Palette.pastelViolet,
        Palette.pastelPink,
        Palette.pastelYellow,
        Palette.pastelMint,
      ].map((c) => c.op(opacity)).toList(),
      stops: const [0, 0.26, 0.5, 0.72, 1],
    );

ThemeData buildTheme() {
  final brightness = isLight ? Brightness.light : Brightness.dark;
  final base = ThemeData(brightness: brightness);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.accent,
      brightness: brightness,
      error: Palette.error,
      primary: Palette.accent,
      secondary: Palette.teal,
      surface: Palette.glass,
    ),
    fontFamily: 'A2Z',
    fontFamilyFallback: const ['Malgun Gothic', 'Arial', 'sans-serif'],
    scaffoldBackgroundColor: Palette.background,
    textTheme: base.textTheme.apply(
      bodyColor: Palette.ink,
      displayColor: Palette.ink,
      fontFamily: 'A2Z',
    ),
    useMaterial3: true,
  );
}
