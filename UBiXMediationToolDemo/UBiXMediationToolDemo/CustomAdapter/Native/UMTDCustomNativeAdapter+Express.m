//
//  UMTDCustomNativeAdapter+Express.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/17.
//

#import "UMTDCustomNativeAdapter+Express.h"

@implementation UMTDCustomKSNativeAdapter (Express)


/// 渲染广告，为模板广告时会回调该方法，需对广告进行渲染
/// @param expressAdView 模板广告
- (void)renderForExpressAdView:(UIView *)expressAdView {
    // 如不adn广告不需要render，请尽量模拟回调renderSuccess
    [self.bridge nativeAd:self renderSuccessWithExpressView:expressAdView];
}

/// 为模板广告设置控制器
/// @param viewController 控制器
/// @param expressAdView 模板广告
- (void)setRootViewController:(UIViewController *)viewController forExpressAdView:(UIView *)expressAdView {
    
}

#pragma mark - KSFeedAdsManagerDelegate
- (void)feedAdsManagerSuccessToLoad:(KSFeedAdsManager *)adsManager nativeAds:(NSArray<KSFeedAd *> *_Nullable)feedAdDataArray {
    UMTDLog(@"%s", __func__);
    for (KSFeedAd *feedAd in feedAdDataArray) {
        
    }
}

- (void)feedAdsManager:(KSFeedAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    UMTDLog(@"%s, error= %@", __func__, error.localizedDescription);
    [self.bridge nativeAd:self didLoadFailWithError:error];
}

- (void)feedAdsManagerReadyToRender:(KSFeedAdsManager *)adsManager feedAds:(NSArray<KSFeedAd *> *_Nullable)feedAdDataArray {
    UMTDLog(@"%s", __func__);
    self.isLoadSucc = YES;
    NSMutableArray *views = [NSMutableArray array];
    NSMutableArray *exts = [NSMutableArray array];
    self.ksFeedAd = feedAdDataArray.firstObject;
    
    for (KSFeedAd *feedAd in feedAdDataArray) {
        feedAd.delegate = self;
        
        // 静音
        switch (self.umtVideoMuteType) {
            case UMTVideoMuteType_Mute:
                [feedAd setVideoSoundEnable:NO];
                break;
            case UMTVideoMuteType_NoMute:
                [feedAd setVideoSoundEnable:YES];
                break;
                
            default:
                break;
        }
        
        if (feedAd.feedView) {
            [views addObject:feedAd.feedView];
        }
        
        NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
        if (self.umtBidType == UMTAdBidType_ClientBidding) {
            NSInteger price = feedAd.ecpm;
            if (price>0) {
                [extDic setValue:[NSString stringWithFormat:@"%ld", (long)price] forKey:UMTAdnAdLoadedExtECPM];
                
            }
        }
        
        [exts addObject: extDic];
    }
    
    [self.bridge nativeAd:self didLoadWithExpressViews:views exts:exts];
}


#pragma mark - KSFeedAdDelegate
/**
 * 信息流|每次广告展示都会调用此方法,请不要用于曝光计数,请使用"feedAdDidShow"作为曝光计数。
 */
- (void)feedAdViewWillShow:(KSFeedAd *)feedAd {
    UMTDLog(@"%s", __func__);
}
/**
 * 信息流|广告被点击
 */
- (void)feedAdDidClick:(KSFeedAd *)feedAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didClickWithMediatedNativeAd:feedAd.feedView];
}
/**
 * 信息流|用户手动点击不喜欢按钮
 */
- (void)feedAdDislike:(KSFeedAd *)feedAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didCloseWithExpressView:feedAd.feedView closeReasons:@[]];
}
/**
 * 信息流|广告详情页打开
 */
- (void)feedAdDidShowOtherController:(KSFeedAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self willPresentFullScreenModalWithMediatedNativeAd:nativeAd.feedView];
}
/**
 * 信息流|广告详情页关闭
 */
- (void)feedAdDidCloseOtherController:(KSFeedAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didDismissFullScreenModalWithMediatedNativeAd:nativeAd.feedView];
}
/**
 * 信息流|广告曝光（每个广告只回调一次，可用于广告曝光计数）
 */
- (void)feedAdDidShow:(KSFeedAd *)feedAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didVisibleWithMediatedNativeAd:feedAd.feedView];
}

@end
