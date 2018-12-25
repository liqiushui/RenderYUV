//
//  VideoCaputure.m
//  RenderYUV
//
//  Created by lunli on 2018/12/25.
//  Copyright © 2018年 lunli. All rights reserved.
//

#import "VideoCaputure.h"

@implementation VideoCaputure

- (void)prepare
{
    _captureSession = [[AVCaptureSession alloc] init];
    
    //ou use this property to customize the quality level or bitrate of the output. For possible values of sessionPreset, see Video Input Presets. The default value is AVCaptureSessionPresetHigh.
    //设置视频输出质量
    _captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:nil];
    if(_captureDeviceInput)
        [_captureSession addInput:_captureDeviceInput];
    
    //设置视频输出参数
    _captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_captureVideoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    NSDictionary *settingsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange],
                                 kCVPixelBufferPixelFormatTypeKey,
                                 nil];
    _captureVideoDataOutput.videoSettings = settingsDic;
    [_captureSession addOutput:_captureVideoDataOutput];
    
    _queue = dispatch_queue_create("VideoCaptureCallBackQueue", NULL);
    [_captureVideoDataOutput setSampleBufferDelegate:self queue:_queue];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if(self.callback) {
        self.callback(sampleBuffer, 0);
    }
}


- (void)start
{
    [_captureSession startRunning];
}

- (void)stop
{
    [_captureSession stopRunning];
}

@end
