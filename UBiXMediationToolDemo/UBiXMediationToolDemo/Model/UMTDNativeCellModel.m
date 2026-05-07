//
//  UMTDNativeCellModel.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/9/2.
//

#import "UMTDNativeCellModel.h"

@interface UMTDNativeCellModel ()

@property (nonatomic, strong) UMTDSelfRenderNativeView *selfRenderV;

@property (nonatomic, assign) BOOL videoMute;

@end

@implementation UMTDNativeCellModel

- (id)initWithNativeOffer:(UMTNativeOffer *)nativeOffer {
    self = [super init];
    if (self) {
        if (nativeOffer.isExpress) {
            [nativeOffer renderAdView:nativeOffer.canvasView selfRenderView:nil];
        } else {
            UMTDSelfRenderNativeView *selfRenderV = [[UMTDSelfRenderNativeView alloc] initWithNativeOffer:nativeOffer];
            self.selfRenderV = selfRenderV;
            [nativeOffer renderAdView:nativeOffer.canvasView selfRenderView:selfRenderV];
        }
        
        _adView = nativeOffer.canvasView;
        
        _videoMute = YES;
    }
    return self;
}

- (void)updateFrameOfAdView:(UIView *)adView {
    
}

- (void)registerAdView {
    [self.selfRenderV registerAdView];
}

- (void)destroy {
    if (self.selfRenderV) {
        [self.selfRenderV removeFromSuperview];
        self.selfRenderV = nil;
    }
    if (self.adView) {
        [self.adView removeFromSuperview];
        self.adView = nil;
    }
}

- (void)updateVideoAction:(UMTDNativeCellModel_VideoAction)action {
    switch (action) {
        case UMTDVideoAction_PlayStart:
            [self.selfRenderV.offer updateVideoAction:UMTNativeVideoAction_Start];
            break;
        case UMTDVideoAction_PlayPause:
            [self.selfRenderV.offer updateVideoAction:UMTNativeVideoAction_Pause];
            break;
        case UMTDVideoAction_PlayResume:
            [self.selfRenderV.offer updateVideoAction:UMTNativeVideoAction_Resume];
            break;
        case UMTDVideoAction_PlayStop:
            [self.selfRenderV.offer updateVideoAction:UMTNativeVideoAction_Stop];
            break;
            
        default:
            break;
    }
    
}

- (void)setVideoMute {
    _videoMute = !_videoMute;
    [self.selfRenderV.offer setVideoMute:_videoMute];
}

- (BOOL)isNativeVideo {
    return self.selfRenderV.offer.canvasView.native.isVideoAd;
}

+ (CGSize)nativeAdSize{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
}

@end
