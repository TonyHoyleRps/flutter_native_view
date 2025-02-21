// This file is a part of flutter_native_view
// (https://github.com/alexmercerind/flutter_native_view).
//
// Copyright (c) 2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

import 'package:flutter/widgets.dart';

import 'package:flutter_native_view/src/ffi.dart';
import 'package:flutter_native_view/src/native_view_controller.dart';

/// NativeView
/// ----------
/// Create a [NativeView] & pass [NativeViewController] as controller to render it's window.
///
/// ```dart
/// class _MyAppState extends State<MyApp> {
///   final controller = NativeViewController(
///     handle: FindWindow(nullptr, 'VLC Media Player'.toNativeUtf16()));
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Scaffold(
///         body: Center(
///             child: Padding(
///               padding: const EdgeInsets.all(24.0),
///               child: Stack(
///                 children: [
///                   LayoutBuilder(
///                     builder: (context, constraints) => NativeView(
///                       // Pass [NativeViewController] to render the window.
///                       controller: controller,
///                       width: constraints.maxWidth,
///                       height: constraints.maxHeight,
///                     ),
///                   ),
///                   Padding(
///                     padding: const EdgeInsets.all(16.0),
///                     child: FloatingActionButton(
///                       onPressed: () {},
///                       child: const Icon(Icons.edit),
///                     ),
///                   ),
///                 ],
///               ),
///             ),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class NativeView extends StatefulWidget {
  final NativeViewController controller;
  final Size size;
  const NativeView({
    Key? key,
    required this.controller,
    this.size = Size.infinite
  }) : super(key: key);

  @override
  State<NativeView> createState() => _NativeViewState();
}

class _NativeViewState extends State<NativeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        widget.controller.createNativeView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomPaint(
          key: widget.controller.painterKey,
          painter: _NativeViewPainter(widget.controller),
          size: widget.size,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _NativeViewPainter extends CustomPainter {
  final NativeViewController controller;

  const _NativeViewPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    controller.resizeNativeViewStreamController.add(null);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..blendMode = BlendMode.clear
        ..color = const Color(0x00000000),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get rect {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
