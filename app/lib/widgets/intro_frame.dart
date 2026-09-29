import 'dart:ui_web' as ui_web;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Full-bleed iframe (the Three.js intro scene) that reports when it loaded.
class IntroFrame extends StatefulWidget {
  const IntroFrame(this.src, {super.key, this.onLoad});

  final String src;
  final VoidCallback? onLoad;

  @override
  State<IntroFrame> createState() => _IntroFrameState();
}

class _IntroFrameState extends State<IntroFrame> {
  late final String _viewType = 'three-intro-${widget.src.hashCode}';
  VoidCallback? _onLoad;

  @override
  void initState() {
    super.initState();
    _onLoad = widget.onLoad;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final frame = web.HTMLIFrameElement()
        ..src = widget.src
        ..setAttribute('frameborder', '0');
      frame.style
        ..border = '0'
        ..width = '100%'
        ..height = '100%'
        ..background = 'transparent';
      frame.onLoad.listen((_) => _onLoad?.call());
      return frame;
    });
  }

  @override
  void didUpdateWidget(IntroFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onLoad = widget.onLoad;
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType, hitTestBehavior: PlatformViewHitTestBehavior.opaque);
  }
}
