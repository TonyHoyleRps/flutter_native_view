// This file is a part of flutter_native_view
// (https://github.com/alexmercerind/flutter_native_view).
//
// Copyright (c) 2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#ifndef FFI_API_H_
#define FFI_API_H_

#include "native_view_core.h"

#ifndef DLLEXPORT
#define DLLEXPORT __declspec(dllexport)
#endif

#ifdef __cplusplus
extern "C" {
#endif

DLLEXPORT void NativeViewCoreEnsureInitialized();

DLLEXPORT void NativeViewCoreCreateNativeView(uint32_t native_view,
                                              uint32_t left, uint32_t top,
                                              uint32_t right, uint32_t bottom,
                                              double device_pixel_ratio);

DLLEXPORT void NativeViewCoreDisposeNativeView(uint32_t native_view);

DLLEXPORT void NativeViewCoreResizeNativeView(uint32_t native_view,
                                              uint32_t left, uint32_t top,
                                              uint32_t right, uint32_t bottom);

#ifdef __cplusplus
}
#endif

#endif
