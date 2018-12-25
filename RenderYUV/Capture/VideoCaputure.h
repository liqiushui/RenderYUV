//
//  VideoCaputure.h
//  RenderYUV
//
//  Created by lunli on 2018/12/25.
//  Copyright © 2018年 lunli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^VideoCaputureCallBack) (CMSampleBufferRef buf, int state);

NS_ASSUME_NONNULL_BEGIN

@interface VideoCaputure : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession                *_captureSession;
    AVCaptureDevice                 *_captureDevice;
    AVCaptureDeviceInput            *_captureDeviceInput;
    AVCaptureVideoDataOutput        *_captureVideoDataOutput;
    dispatch_queue_t    _queue;
}

@property (nonatomic, copy)  VideoCaputureCallBack  callback;

- (void)prepare;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
