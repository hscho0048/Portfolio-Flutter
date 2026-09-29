import 'package:flutter/material.dart';

import 'pages/landing_page.dart';
import 'pages/portfolio_page.dart';
import 'pages/project_page.dart';
import 'pages/system_alert_page.dart';
import 'theme.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: terminalColorMode,
      builder: (context, child) => MaterialApp(
        title: 'Hosung Cho — Portfolio',
        theme: buildTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: _route,
      ),
    );
  }
}

Route<Object?> _route(RouteSettings settings) {
  final name = settings.name ?? '/';
  final Widget page;
  if (name == '/') {
    page = const LandingPage();
  } else if (name == '/portfolio') {
    page = const PortfolioPage();
  } else if (name == '/desktop') {
    final section = switch (settings.arguments) {
      TerminalSection.about => 'about',
      TerminalSection.projects => 'work',
      TerminalSection.contact => 'contact',
      TerminalSection.home => 'home',
      _ => null,
    };
    page = PortfolioPage(initialSection: section);
  } else if (name.startsWith('/project/')) {
    page = ProjectPage(slug: Uri.decodeComponent(name.substring('/project/'.length)));
  } else {
    page = const SystemAlertPage();
  }
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 400),
  );
}
