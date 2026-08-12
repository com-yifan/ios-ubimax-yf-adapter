//
//  UMTDCustomKSBannerAdapter.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/5.
//

#import "UMTDCustomKSBannerAdapter.h"
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>
#import <KSAdSDK/KSAdSDK.h>
#import "UMTDLogger.h"

@interface UMTDCustomKSBannerAdapter () <UMTCustomBannerAdapter, KSBannerAdDelegate>

@property (nonatomic, strong) KSBannerAd *bannerAd;

@end

@implementation UMTDCustomKSBannerAdapter

/// 加载广告的方法
/// @param slotID adn的广告位ID
/// @param size 广告展示尺寸
/// @param parameter 广告加载的参数
- (void)loadBannerAdWithSlotID:(NSString *)slotID andSize:(CGSize)size parameter:(NSDictionary *)parameter {
    NSNumber *bidType = parameter[UMTAdLoadingParamBiddingType];
    self.umtBidType = (UMTAdBidType)bidType.integerValue;
    
    NSString *extJson = parameter[UMTAdLoadingParamExtJson];
    NSData *data = [extJson dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSError *error = nil;
        NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error && paramDic) {
            NSLog(@"扩展参数，param: %@", paramDic);
        }
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        KSBannerAd *ad = [[KSBannerAd alloc] initWithPosId:slotID];
        switch (strongSelf.umtVideoMuteType) {
            case UMTVideoMuteType_Mute:
                [ad setVideoSoundEnable:NO];
                break;
            case UMTVideoMuteType_NoMute:
                [ad setVideoSoundEnable:YES];
                break;
            default:
                break;
        }
        strongSelf.bannerAd = ad;
        ad.delegate = strongSelf;
        [ad loadAdData];
    });
   
}

/// 展示开屏广告
/// @param parentView 广告展示窗口
/// @param parameter 广告展示参数
- (void)showBannerAdInParentView:(UIView *)parentView parameter:(NSDictionary *)parameter {
    UIViewController *rootVC = self.bridge.viewControllerForPresentingModalView;
    [self.bannerAd showFromViewController:rootVC];
    [parentView addSubview:self.bannerAd.bannerAdView];
}

/// 在适配器被释放前
- (void)destroyAd {
    [self removeSplash];
}

/// 当前加载的广告的状态
- (UMTMediatedAdStatus)mediatedAdStatus {
    // 调用广告源提供的广告有效性校验方法
    if (self.bannerAd.adReady) {
        // 广告有效
        return UMTMediatedAdStatusNormal;
    }
    return UMTMediatedAdStatusUnknown;
}

#pragma mark - Private
- (void)removeSplash {
    if (self.bannerAd.bannerAdView.superview) {
        [self.bannerAd.bannerAdView removeFromSuperview];
        self.bannerAd = nil;
    }
    
}

#pragma mark - KSBannerAdDelegate
/**
 * banner 广告请求完成
 */
- (void)ksad_bannerAdViewDidLoad:(KSBannerAd *)bannerAdView {
    [self.bridge bannerAd:self didLoad:bannerAdView.bannerAdView ext:@{}];

}
/**
 * banner 广告请求失败
 */
- (void)ksad_bannerAdView:(KSBannerAd *)bannerAdView didFailWithError:(NSError *_Nullable)error {
    [self.bridge bannerAd:self didLoadFailWithError:error ext:@{}];
}
/**
 * banner 广告渲染成功
 */
- (void)ksad_bannerAdViewRenderSuccess:(KSBannerAd *)bannerAd {
    [self.bridge bannerAd:self didRenderSuccessWithExt:@{}];
}
/**
 * banner 广告曝光
 */
- (void)ksad_bannerAdViewBecomVisible:(KSBannerAd *)bannerAd {
    [self.bridge bannerAdDidVisible:self bannerView:bannerAd.bannerAdView];

}
/**
 * banner 广告点击
 */
- (void)ksad_bannerAdViewDidClick:(KSBannerAd *)bannerAd {
    [self.bridge bannerAdDidClick:self bannerView:bannerAd.bannerAdView];
}
/**
 * banner 广告关闭
 */
- (void)ksad_bannerAdViewDidClose:(KSBannerAd *)bannerAd {
    [self.bridge bannerAdDidClose:self bannerView:bannerAd.bannerAdView];

}
/**
 * banner 广告打开详情页
 */
- (void)ksad_bannerAdViewDidShowOtherController:(KSBannerAd *)bannerAd interactionType:(KSAdInteractionType)interactionType {
    [self.bridge bannerAdWillPresentFullScreenModal:self];
}
/**
 * banner 广告关闭详情页
 */
- (void)ksad_bannerAdViewDidCloseOtherController:(KSBannerAd *)bannerAd interactionType:(KSAdInteractionType)interactionType {
    [self.bridge bannerAdWillDismissFullScreenModal:self];

}


@end
