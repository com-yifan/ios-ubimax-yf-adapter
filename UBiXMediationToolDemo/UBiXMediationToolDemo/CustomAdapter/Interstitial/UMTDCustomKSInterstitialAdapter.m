//
//  UMTDCustomKSInterstitialAdapter.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/17.
//

#import "UMTDCustomKSInterstitialAdapter.h"
#import <UBiMAXAdSDK/UBiMAXAdSDK-umbrella.h>
#import <KSAdSDK/KSAdSDK.h>
#import "UMTDLogger.h"

@interface UMTDCustomKSInterstitialAdapter () <UMTCustomInterstitialAdapter, KSInterstitialAdDelegate>

@property (nonatomic, strong) KSInterstitialAd *interstitialAd;
@property (nonatomic, assign) UMTAdRenderType renderType;
@property (nonatomic, assign) BOOL isLoadSucc;

@end

@implementation UMTDCustomKSInterstitialAdapter

- (UMTMediatedAdStatus)mediatedAdStatus {
    if (self.isLoadSucc && _interstitialAd.isValid) {
        return UMTMediatedAdStatusNormal;
    }
    return UMTMediatedAdStatusUnknown;
}

- (void)loadInterstitialAdWithSlotID:(NSString *)slotID andSize:(CGSize)size parameter:(NSDictionary *)parameter {
    NSNumber *bidType = parameter[UMTAdLoadingParamBiddingType];
    self.umtBidType = (UMTAdBidType)bidType.integerValue;
    NSNumber *videoMuteNum = parameter[UMTAdLoadingParamVideoMute];
    self.umtVideoMuteType = (UMTVideoMuteType)videoMuteNum.integerValue;
    NSNumber *videoPlayNet = parameter[UMTAdLoadingParamVideoPlayNet];
    self.umtVideoPlayNetType = (UMTVideoPlayNetType)videoPlayNet.integerValue;
    
    KSInterstitialAd *interstitial = [[KSInterstitialAd alloc] initWithPosId:slotID];
    interstitial.delegate = self;
    // 静音
    switch (self.umtVideoMuteType) {
        case UMTVideoMuteType_NoMute:
            interstitial.videoSoundEnabled = YES;
            break;
        case UMTVideoMuteType_Mute:
            interstitial.videoSoundEnabled = NO;
            break;
            
        default:
            break;
    }
    
    self.interstitialAd = interstitial;
    [interstitial loadAdData];
}

/// 展示广告的方法
/// @param viewController 控制器对象
/// @param parameter 展示广告的参数，由UMT接入媒体配置
- (void)showAdFromRootViewController:(UIViewController *_Nonnull)viewController parameter:(NSDictionary *)parameter {
    [self.interstitialAd showFromViewController:viewController];
}

- (void)didReceiveBidResult:(UMTMediaBidResult *)result {
    
}

#pragma mark - KSInterstitialAdDelegate

/**
 * interstitial ad data loaded
 */
- (void)ksad_interstitialAdDidLoad:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
    self.isLoadSucc = YES;
    
    NSDictionary *mediaExtra = interstitialAd.mediaExtraInfo;
    
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    if (self.umtBidType == UMTAdBidType_ClientBidding) {
        NSInteger price = interstitialAd.ecpm;
        if (price>0) {
            [extDic setValue:[NSString stringWithFormat:@"%ld", price] forKey:UMTAdnAdLoadedExtECPM];
        }
    }
   
    [self.bridge interstitialAd:self didLoadWithExt:extDic];
}
/**
 * interstitial ad render success
 */
- (void)ksad_interstitialAdRenderSuccess:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    if (self.umtBidType == UMTAdBidType_ClientBidding) {
        NSInteger price = interstitialAd.ecpm;
        if (price>0) {
            [extDic setValue:[NSString stringWithFormat:@"%ld", price] forKey:UMTAdnAdLoadedExtECPM];
        }
    }
    [self.bridge interstitialAd:self didRenderSuccessWithExt:extDic];
}
/**
 * interstitial ad load or render failed
 */
- (void)ksad_interstitialAdRenderFail:(KSInterstitialAd *)interstitialAd error:(NSError * _Nullable)error {
    UMTDLog(@"%s, error= %@", __func__, error.localizedDescription);
    [self.bridge interstitialAd:self renderFailedWithError:error];
}
/**
 * interstitial ad will visible
 */
- (void)ksad_interstitialAdWillVisible:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
}
/**
 * interstitial ad did visible
 */
- (void)ksad_interstitialAdDidVisible:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
    
    [self.bridge interstitialAdDidVisible:self];
}
/**
 * interstitial ad did click
 */
- (void)ksad_interstitialAdDidClick:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
    
    [self.bridge interstitialAdDidClick:self];
}
/**
 * interstitial ad did click skip
 */
- (void)ksad_interstitialAdDidClickSkip:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
}
/**
 * interstitial ad will close
 */
- (void)ksad_interstitialAdWillClose:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
}
/**
 * interstitial ad did close
 */
- (void)ksad_interstitialAdDidClose:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
    
    [self.bridge interstitialAdDidClose:self];
}
/**
 * interstitial ad did close other controller
 */
- (void)ksad_interstitialAdDidCloseOtherController:(KSInterstitialAd *)interstitialAd interactionType:(KSAdInteractionType)interactionType {
    UMTDLog(@"%s", __func__);
    
    [self.bridge interstitialAdWillDismissFullScreenModal:self];
}
/**
 * interstitial ad video start play
 */
- (void)ksad_interstitialVideoAdStartPlay:(KSInterstitialAd *)interstitialAd {
    UMTDLog(@"%s", __func__);
}
/**
 * interstitial ad video play finish or play error
 */
- (void)ksad_interstitialVideoAdDidPlayFinish:(KSInterstitialAd *)interstitialAd didFailWithError:(NSError *_Nullable)error {
    UMTDLog(@"%s", __func__);
}

@end
