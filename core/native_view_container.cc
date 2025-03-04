// This file is a part of flutter_native_view
// (https://github.com/alexmercerind/flutter_native_view).
//
// Copyright (c) 2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#include "native_view_container.h"

#include <ShObjIdl.h>

#include "utils.h"

namespace flutternativeview {

NativeViewContainer* NativeViewContainer::GetInstance() {
  return instance_.get();
}

HWND NativeViewContainer::Create() {
  auto window_class = WNDCLASSEX{};
  ::SecureZeroMemory(&window_class, sizeof(window_class));
  window_class.cbSize = sizeof(window_class);
  window_class.style = CS_HREDRAW | CS_VREDRAW;
  window_class.lpfnWndProc = WindowProc;
  window_class.hInstance = 0;
  window_class.lpszClassName = kClassName;
  window_class.hCursor = ::LoadCursorW(nullptr, IDC_ARROW);
  window_class.hbrBackground = ::CreateSolidBrush(0);
  ::RegisterClassExW(&window_class);
  handle_ =
      ::CreateWindowEx(WS_EX_TOOLWINDOW, kClassName, kWindowName, WS_OVERLAPPEDWINDOW,
                     CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                     nullptr, nullptr, GetModuleHandle(nullptr), nullptr);
  // Disable DWM animations on |native_view_container|.
  auto disable_window_transitions = TRUE;
  DwmSetWindowAttribute(handle_, DWMWA_TRANSITIONS_FORCEDISABLED,
                        &disable_window_transitions,
                        sizeof(disable_window_transitions));
  return handle_;
}

HWND NativeViewContainer::Get(HWND window) {
  RECT window_rect;
  ::GetWindowRect(window, &window_rect);
  ::SetWindowPos(handle_, window, window_rect.left, window_rect.top,
                 window_rect.right - window_rect.left,
                 window_rect.bottom - window_rect.top, SWP_NOACTIVATE);
  ::ShowWindow(handle_, SW_SHOWNOACTIVATE);
  ::SetFocus(window);
  return handle_;
}

LRESULT CALLBACK NativeViewContainer::WindowProc(HWND const window,
                                                 UINT const message,
                                                 WPARAM const wparam,
                                                 LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY: {
      ::PostQuitMessage(0);
      return 0;
    }
            
    case WM_ERASEBKGND: {
      // Prevent erasing of |window| when it is unfocused and minimized or
      // moved out of screen etc.
      return 1;
    }

    default:
      break;
  }
  return ::DefWindowProc(window, message, wparam, lparam);
}

std::unique_ptr<NativeViewContainer> NativeViewContainer::instance_ =
    std::make_unique<NativeViewContainer>();

}  // namespace flutternativeview
