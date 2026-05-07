//
//  UMTDNativeCellModel.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/9/2.
//

#import <Foundation/Foundation.h>
#import "UMTDSelfRenderNativeView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UMTDVideoAction_MuteSwitch = 1,
    UMTDVideoAction_PlayStart,
    UMTDVideoAction_PlayPause,
    UMTDVideoAction_PlayResume,
    UMTDVideoAction_PlayStop,
} UMTDNativeCellModel_VideoAction;

@interface UMTDNativeCellModel : NSObject

@property (nonatomic, assign) BOOL isNativeVideo;

@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) UIView *adView;

- (id)initWithNativeOffer:(UMTNativeOffer *)nativeOffer;

- (void)registerAdView;

- (void)updateVideoAction:(UMTDNativeCellModel_VideoAction)action;
- (void)setVideoMute;
- (void)destroy;

+ (CGSize)nativeAdSize;


@end

NS_ASSUME_NONNULL_END
