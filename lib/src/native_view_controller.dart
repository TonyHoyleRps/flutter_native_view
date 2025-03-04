// This file is a part of flutter_native_view (https://github.com/alexmercerind/flutter_native_view).
//
// Copyright (c) 2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:ui';
import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:flutter_native_view/src/ffi.dart';
import 'package:flutter_native_view/src/widgets.dart';

/// [NativeViewController] creates a new controller to control an instance of [NativeView].
///
/// ```dart
/// final controller = NativeViewController(
///   handle: FindWindow(
///     nullptr,
///     'VLC Media Player'.toNativeUtf16(),
///   ),
/// );
/// ```
///
/// Pass the `HWND` of the window as [handle].
/// In above example, we are using `FindWindow` from `package:win32` to discover handle of the `VLC Media Player`'s window.
///
///
/// **Other Notes**
///
/// When [NativeView] is no longer in use always make sure to dispose it using [dispose].
///
/// ```dart
/// controller.dispose();
/// ```
///
/// The [NativeView] can be explicitly re-drawn using [refresh].
///
/// ```dart
/// controller.refresh();
/// ```
///
class NativeViewController {
  final int handle;
  final GlobalKey painterKey = GlobalKey();

  /// [StreamController] to avoid race & send [Rect]s synchronously.
  final StreamController<void> resizeNativeViewStreamController =
      StreamController<void>();
  late final StreamSubscription<void> resizeNativeViewStreamSubscription;

  NativeViewController({
    required this.handle
  }) {
    resizeNativeViewStreamSubscription =
        resizeNativeViewStreamController.stream.listen(
      (event) {
        resize();
      },
    );
  }

  /// Disposes the [NativeViewController] instance & releases the resources.
  Future<void> dispose() {
    FFI.nativeViewCoreDisposeNativeView(handle);
    return resizeNativeViewStreamSubscription.cancel();
  }

  /// Creates a new [NativeView].
  void createNativeView() {
    FFI.nativeViewCoreCreateNativeView(
      handle,
      (painterKey.rect!.left * window.devicePixelRatio).toInt(),
      (painterKey.rect!.top * window.devicePixelRatio).toInt(),
      (painterKey.rect!.right * window.devicePixelRatio).toInt(),
      (painterKey.rect!.bottom * window.devicePixelRatio).toInt(),
      window.devicePixelRatio,
    );
  }

  /// Causes [NativeView] associated with this [NativeViewController] to update its positioning.
  ///
  void resize() {
    FFI.nativeViewCoreResizeNativeView(
      handle,
      (painterKey.rect!.left * window.devicePixelRatio).toInt(),
      (painterKey.rect!.top * window.devicePixelRatio).toInt(),
      (painterKey.rect!.right * window.devicePixelRatio).toInt(),
      (painterKey.rect!.bottom * window.devicePixelRatio).toInt(),
    );
  }
}
