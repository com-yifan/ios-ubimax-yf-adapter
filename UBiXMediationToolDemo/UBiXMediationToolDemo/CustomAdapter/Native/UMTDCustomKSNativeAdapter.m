//
//  UMTDCustomNativeAdapter.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/10.
//

#import "UMTDCustomKSNativeAdapter.h"
#import "UMTDCustomKSNativeHelper.h"


@interface UMTDCustomKSNativeAdapter () <KSNativeAdsManagerDelegate>

@property (nonatomic, strong) UMTDCustomKSNativeHelper *ksNativeHelper;

@end

@implementation UMTDCustomKSNativeAdapter

- (UMTMediatedAdStatus)mediatedAdStatus {
    if (self.isLoadSucc) {
        if (self.renderType == UMTAdRenderType_Temple && self.ksFeedAd.materialReady) {
            return UMTMediatedAdStatusNormal;
        } else if (self.renderType == UMTAdRenderType_Custom && self.ksNativeAd.data) {
            return UMTMediatedAdStatusNormal;
        }
    }
    return UMTMediatedAdStatusUnknown;
}

/// 加载广告的方法
/// @param slotID adn的广告位ID
/// @param size 广告展示尺寸
/// @param imageSize 图片或视频展示尺寸
/// @param parameter 广告加载的参数
- (void)loadNativeAdWithSlotID:(NSString *)slotID andSize:(CGSize)size imageSize:(CGSize)imageSize parameter:(NSDictionary *)parameter {
    NSNumber *bidType = parameter[UMTAdLoadingParamBiddingType];
    self.umtBidType = (UMTAdBidType)bidType.integerValue;
    NSNumber *videoMuteNum = parameter[UMTAdLoadingParamVideoMute];
    self.umtVideoMuteType = (UMTVideoMuteType)videoMuteNum.integerValue;
    NSNumber *videoPlayNet = parameter[UMTAdLoadingParamVideoPlayNet];
    self.umtVideoPlayNetType = (UMTVideoPlayNetType)videoPlayNet.integerValue;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSNumber *renderTypeNum = parameter[UMTAdLoadingParamRenderType];
        strongSelf.renderType = (UMTAdRenderType)renderTypeNum.integerValue;
        if (strongSelf.renderType == UMTAdRenderType_Temple) {
            KSFeedAdsManager *adsManager = [[KSFeedAdsManager alloc] initWithPosId:slotID size:size];
            strongSelf.feedAdsManager = adsManager;
            adsManager.delegate = strongSelf;
            [adsManager loadAdDataWithCount:1];
        } else if (strongSelf.renderType == UMTAdRenderType_Custom) {
            KSNativeAdsManager *adsManager = [[KSNativeAdsManager alloc] initWithPosId:slotID];
            strongSelf.nativeAdsManager = adsManager;
            adsManager.delegate = strongSelf;
            
//            KSAdNativeAdExtraDataModel *extraModel = [KSAdNativeAdExtraDataModel new];
//            extraModel.enableShake = KSADDemoGlobalConfig.shareGlobalConfig.isNativeAdEnableShake;
//            [self.nativeAdsManager setExtraData:extraModel];
            
            [adsManager loadAdDataWithCount:1];
        }
    });
}


/// 渲染广告，为非模板广告时会回调该方法
- (void)renderView:(UMTNativeAdView *)nativeAdView selfRenderView:(nonnull UIView *)selfRenderView {
    UMTMediationNativeAd *mNativeAd = nativeAdView.native;
    if ([mNativeAd.originMediatedNativeAd isKindOfClass:[KSNativeAd class]]) {
        KSNativeAd *ksNativeAd = mNativeAd.originMediatedNativeAd;
        
        if (ksNativeAd.data.materialType == KSAdMaterialTypeVideo) {
            // 静音
            KSVideoAdView *videoView = self.ksNativeHelper.relatedView.videoAdView;
            switch (self.umtVideoMuteType) {
                case UMTVideoMuteType_Mute:
                    videoView.videoSoundEnable = NO;
                    break;
                case UMTVideoMuteType_NoMute:
                    videoView.videoSoundEnable = YES;
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}

/// 为非模板广告设置控制器
/// @param viewController 控制器
/// @param nativeAd 非模板广告
- (void)setRootViewController:(UIViewController *)viewController forNativeAd:(UMTMediationNativeAd *)nativeAd {
    KSNativeAd *ksNativeAd = nativeAd.originMediatedNativeAd;
    ksNativeAd.rootViewController = viewController;
}

/// 注册容器和可点击区域
/// @param containerView 容器视图
/// @param views 可点击视图组
- (void)registerContainerView:(__kindof UIView *)containerView andClickableViews:(NSArray<__kindof UIView *> *)views closableViews:(NSArray *)closableViews forNativeAd:(UMTMediationNativeAd *)nativeAd {
    if ([nativeAd.originMediatedNativeAd isKindOfClass:[KSNativeAd class]]) {
        KSNativeAd *adDataObj = (KSNativeAd *)nativeAd.originMediatedNativeAd;
        
        KSNativeAdRelatedView *relatedView = self.ksNativeHelper.relatedView;
        [relatedView refreshData:adDataObj];
        [relatedView.videoAdView setVideoSoundEnable:NO];
        
        [adDataObj registerContainer:containerView withClickableViews:views containerClickable:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapAction:)];
        for (UIView *v in closableViews) {
            [v addGestureRecognizer:tap];
        }
    }
}

- (void)didReceiveBidResult:(UMTMediaBidResult *)result {
    
}

#pragma mark - private
- (void)closeTapAction:(UIGestureRecognizer *)sender {
    UIView *view = sender.view;
    
    [self.bridge nativeAd:self dislikeWithMediatedNativeAd:self.ksNativeAd closeReasons:@[@"关闭"]];
    
}

#pragma mark - KSNativeAdsManagerDelegate

- (void)nativeAdsManagerSuccessToLoad:(KSNativeAdsManager *)adsManager nativeAds:(NSArray<KSNativeAd *> *_Nullable)nativeAdDataArray {
    UMTDLog(@"%s", __func__);
    
    if (!nativeAdDataArray || nativeAdDataArray.count <= 0) {
        NSError *error = [NSError errorWithDomain:@"com.ubixai.umt.iosDemo.KSNativeAdapter" code:500400 userInfo:@{NSLocalizedDescriptionKey: @"ks native 无填充"}];
        [self.bridge nativeAd:self didLoadFailWithError:error];
    } else {
        self.isLoadSucc = YES;
        NSMutableArray *adList = [NSMutableArray arrayWithCapacity:5];
        NSMutableArray *extDicList = [NSMutableArray array];
        KSNativeAd *adObj = nativeAdDataArray.firstObject;

        if (adObj) {
            self.ksNativeAd = adObj;
            
            adObj.delegate = self;
            adObj.rootViewController = self.bridge.viewControllerForPresentingModalView;
            
            id<UMTMediationNativeAdData, UMTMediationNativeAdViewCreator> helper = [[UMTDCustomKSNativeHelper alloc] initWithAdData:adObj];
            self.ksNativeHelper = helper;
            
            UMTMediationNativeAd *ad = [[UMTMediationNativeAd alloc] init];
            ad.originMediatedNativeAd = adObj;
            ad.viewCreator = helper;
            ad.adData = helper;
            
            [adList addObject:ad];
            
            NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
            if (self.umtBidType == UMTAdBidType_ClientBidding) {
                NSInteger price = adObj.ecpm;
                if (price > 0) {
                    // 参竞价格 该值为NSString类型，单位为分
                    [extDic setValue: [NSString stringWithFormat:@"%ld", (long)price] forKey:UMTAdnAdLoadedExtECPM];
                }
            }
            [extDicList addObject:extDic];
        }
        
        [self.bridge nativeAd:self didLoadWithNativeAds:adList exts:extDicList];
    }
}

- (void)nativeAdsManager:(KSNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    UMTDLog(@"%s, error=%@", __func__, error.localizedDescription);
    [self.bridge nativeAd:self didLoadFailWithError:error];
}

#pragma mark - KSNativeAdDelegate
/**
 * 自渲染|广告素材获取成功
 */
- (void)nativeAdDidLoad:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
}
/**
 * 自渲染|广告素材获取失败
 */
- (void)nativeAd:(KSNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    UMTDLog(@"%s, error=%@", __func__, error.localizedDescription);
}
/**
 * 自渲染|每次广告展示都会调用此方法,请不要用于曝光计数,请使用"nativeAdDidShow"作为曝光计数。
 */
- (void)nativeAdDidBecomeVisible:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
}
/**
 * 自渲染|广告被点击
 */
- (void)nativeAdDidClick:(KSNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didClickWithMediatedNativeAd:nativeAd];
}
/**
 * 自渲染|广告详情页打开
 */
- (void)nativeAdDidShowOtherController:(KSNativeAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self willPresentFullScreenModalWithMediatedNativeAd:nativeAd];
}
/**
 * 自渲染|广告详情页关闭
 */
- (void)nativeAdDidCloseOtherController:(KSNativeAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didDismissFullScreenModalWithMediatedNativeAd:nativeAd];
}
/**
 * 自渲染|广告曝光（每个广告只回调一次，可用于广告曝光计数）
 */
- (void)nativeAdDidShow:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self didVisibleWithMediatedNativeAd:nativeAd];
}
/**
 * 自渲染|视频广告资源准备就绪
 */
- (void)nativeAdVideoReadyToPlay:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self videoStateDidChangedWithState:UMTVideoPlayerStatusPrepared andNativeAd:nativeAd];
}
/**
 * 自渲染|视频广告开始播放
 */
- (void)nativeAdVideoStartPlay:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self videoStateDidChangedWithState:UMTVideoPlayerStatusStarted andNativeAd:nativeAd];
}
/**
 * 自渲染|视频广告播放结束
 */
- (void)nativeAdVideoPlayFinished:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self videoDidPlayFinish:nativeAd];
}
/**
 * 自渲染|视频广告播放错误
 */
- (void)nativeAdVideoPlayError:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self videoStateDidChangedWithState:UMTVideoPlayerStatusError andNativeAd:nativeAd];
}
/**
 * 自渲染|视频广告播放暂停（包括系统暂停和用户手动暂停）
 */
- (void)nativeAdVideoPause:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self videoStateDidChangedWithState:UMTVideoPlayerStatusPaused andNativeAd:nativeAd];
}
/**
 * 自渲染|视频广告播放恢复（包括系统恢复和用户恢复）,视频第一次开始播放时不调用该方法
 */
- (void)nativeAdVideoResume:(KSNativeAd *)nativeAd {
    UMTDLog(@"%s", __func__);
    [self.bridge nativeAd:self videoStateDidChangedWithState:UMTVideoPlayerStatusPlaying andNativeAd:nativeAd];
}



@end
