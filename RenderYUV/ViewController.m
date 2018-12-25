//
//  ViewController.m
//  RenderYUV
//
//  Created by lunli on 2018/12/25.
//  Copyright © 2018年 lunli. All rights reserved.
//

#import "ViewController.h"
#import "VideoCaputure.h"
#import "RTCEAGLVideoView.h"
#import "RTCVideoFrame.h"
#import "RTCCVPixelBuffer.h"

@interface ViewController ()<RTCVideoViewDelegate>

@property (nonatomic, strong)   VideoCaputure   *vc;
@property (nonatomic, strong)   RTCEAGLVideoView    *vv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view insertSubview:self.vv atIndex:0];
    [self.vc prepare];
    [self.vc setCallback:^(CMSampleBufferRef buf, int state) {
        NSLog(@"Video Callbacl buf = %@", buf);
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(buf);
        pts = CMTimeConvertScale(pts, 1000, kCMTimeRoundingMethod_Default);
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(buf);
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        RTCCVPixelBuffer *pixbuf = [[RTCCVPixelBuffer alloc] initWithPixelBuffer:imageBuffer];
        RTCVideoFrame *frame = [[RTCVideoFrame alloc] initWithBuffer:pixbuf rotation:0 timeStampNs:pts.value];
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        [self.vv renderFrame:frame];
    }];
}

- (VideoCaputure *)vc
{
    if(!_vc)
    {
        _vc = [[VideoCaputure alloc] init];
    }
    
    return _vc;
}

- (RTCEAGLVideoView *)vv
{
    if(!_vv)
    {
        _vv = [[RTCEAGLVideoView alloc] initWithFrame:self.view.bounds];
    }
    
    return _vv;
}

- (IBAction)clickStart:(id)sender {
    NSLog(@"%s excuted", __FUNCTION__);
    [self.vc start];

}
- (IBAction)clickStop:(id)sender {
    NSLog(@"%s excuted", __FUNCTION__);
    [self.vc stop];

}

- (void)videoView:(id<RTCVideoRenderer>)videoView didChangeVideoSize:(CGSize)size
{
    NSLog(@"%s excuted", __FUNCTION__);
}
@end
