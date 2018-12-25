/*
 *  Copyright 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCCVPixelBuffer.h"

#if !defined(NDEBUG) && defined(WEBRTC_IOS)
#import <UIKit/UIKit.h>
#import <VideoToolbox/VideoToolbox.h>
#endif

@implementation RTCCVPixelBuffer {
  int _width;
  int _height;
  int _bufferWidth;
  int _bufferHeight;
  int _cropWidth;
  int _cropHeight;
}

@synthesize pixelBuffer = _pixelBuffer;
@synthesize cropX = _cropX;
@synthesize cropY = _cropY;
@synthesize cropWidth = _cropWidth;
@synthesize cropHeight = _cropHeight;

+ (NSSet<NSNumber*>*)supportedPixelFormats {
  return [NSSet setWithObjects:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
                               @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange),
                               @(kCVPixelFormatType_32BGRA),
                               @(kCVPixelFormatType_32ARGB),
                               nil];
}

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
  return [self initWithPixelBuffer:pixelBuffer
                      adaptedWidth:(int)CVPixelBufferGetWidth(pixelBuffer)
                     adaptedHeight:(int)CVPixelBufferGetHeight(pixelBuffer)
                         cropWidth:(int)CVPixelBufferGetWidth(pixelBuffer)
                        cropHeight:(int)CVPixelBufferGetHeight(pixelBuffer)
                             cropX:0
                             cropY:0];
}

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                       adaptedWidth:(int)adaptedWidth
                      adaptedHeight:(int)adaptedHeight
                          cropWidth:(int)cropWidth
                         cropHeight:(int)cropHeight
                              cropX:(int)cropX
                              cropY:(int)cropY {
  if (self = [super init]) {
    _width = adaptedWidth;
    _height = adaptedHeight;
    _pixelBuffer = pixelBuffer;
    _bufferWidth = (int)CVPixelBufferGetWidth(_pixelBuffer);
    _bufferHeight = (int)CVPixelBufferGetHeight(_pixelBuffer);
    _cropWidth = cropWidth;
    _cropHeight = cropHeight;
    // Can only crop at even pixels.
    _cropX = cropX & ~1;
    _cropY = cropY & ~1;
    CVBufferRetain(_pixelBuffer);
  }

  return self;
}

- (void)dealloc {
  CVBufferRelease(_pixelBuffer);
}

- (int)width {
  return _width;
}

- (int)height {
  return _height;
}

- (BOOL)requiresCropping {
  return _cropWidth != _bufferWidth || _cropHeight != _bufferHeight;
}

- (BOOL)requiresScalingToWidth:(int)width height:(int)height {
  return _cropWidth != width || _cropHeight != height;
}

- (int)bufferSizeForCroppingAndScalingToWidth:(int)width height:(int)height {
  const OSType srcPixelFormat = CVPixelBufferGetPixelFormatType(_pixelBuffer);
  switch (srcPixelFormat) {
    case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
    case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange: {
      int srcChromaWidth = (_cropWidth + 1) / 2;
      int srcChromaHeight = (_cropHeight + 1) / 2;
      int dstChromaWidth = (width + 1) / 2;
      int dstChromaHeight = (height + 1) / 2;

      return srcChromaWidth * srcChromaHeight * 2 + dstChromaWidth * dstChromaHeight * 2;
    }
    case kCVPixelFormatType_32BGRA:
    case kCVPixelFormatType_32ARGB: {
      return 0;  // Scaling RGBA frames does not require a temporary buffer.
    }
  }
  return 0;
}

- (BOOL)cropAndScaleTo:(CVPixelBufferRef)outputPixelBuffer
        withTempBuffer:(nullable uint8_t*)tmpBuffer {
  const OSType srcPixelFormat = CVPixelBufferGetPixelFormatType(_pixelBuffer);
  const OSType dstPixelFormat = CVPixelBufferGetPixelFormatType(outputPixelBuffer);

  switch (srcPixelFormat) {
    case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
    case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange: {
      size_t dstWidth = CVPixelBufferGetWidth(outputPixelBuffer);
      size_t dstHeight = CVPixelBufferGetHeight(outputPixelBuffer);
      if (dstWidth > 0 && dstHeight > 0) {

        if ([self requiresScalingToWidth:dstWidth height:dstHeight]) {
        }
        [self cropAndScaleNV12To:outputPixelBuffer withTempBuffer:tmpBuffer];
      }
      break;
    }
    case kCVPixelFormatType_32BGRA:
    case kCVPixelFormatType_32ARGB: {
      [self cropAndScaleARGBTo:outputPixelBuffer];
      break;
    }
    default: {  }
  }

  return YES;
}

- (id<RTCI420Buffer>)toI420 {


  return nil;
}

#pragma mark - Debugging

#if !defined(NDEBUG) && defined(WEBRTC_IOS)
- (id)debugQuickLookObject {
  CGImageRef cgImage;
  VTCreateCGImageFromCVPixelBuffer(_pixelBuffer, NULL, &cgImage);
  UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
  CGImageRelease(cgImage);
  return image;
}
#endif

#pragma mark - Private

- (void)cropAndScaleNV12To:(CVPixelBufferRef)outputPixelBuffer withTempBuffer:(uint8_t*)tmpBuffer {

}

- (void)cropAndScaleARGBTo:(CVPixelBufferRef)outputPixelBuffer {
 
}
@end
