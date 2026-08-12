//
//  UMTDCustomKSSplashAdapter.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/5.
//

#import "UMTDCustomKSSplashAdapter.h"
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>
#import <KSAdSDK/KSAdSDK.h>
#import "UMTDLogger.h"

@interface UMTDCustomKSSplashAdapter () <UMTCustomSplashAdapter, KSSplashAdViewDelegate>

@property (nonatomic, strong) KSSplashAdView *splash;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation UMTDCustomKSSplashAdapter

/// 加载开屏广告
/// @param slotID 广告位ID
/// @param parameter 广告加载参数
- (void)loadSplashAdWithSlotID:(NSString *)slotID andParameter:(NSDictionary *)parameter {
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
        UIView *bottomView = parameter[UMTAdLoadingParamSPCustomBottomView];
        strongSelf.bottomView = bottomView;
        CGSize adSize = [UIScreen mainScreen].bounds.size;
        if (bottomView) {
            adSize = CGSizeMake(adSize.width, adSize.height - bottomView.frame.size.height);
        }
        KSSplashAdView *splash = [[KSSplashAdView alloc] initWithPosId:slotID];
        splash.frame = CGRectMake(0, 0, adSize.width, adSize.height);
        splash.delegate = strongSelf;
        strongSelf.splash = splash;
        [strongSelf.splash loadAdData];
    });
   
}

/// 展示开屏广告
/// @param window 广告展示窗口
/// @param parameter 广告展示参数
- (void)showSplashAdInWindow:(UIWindow *)window parameter:(NSDictionary *)parameter {
    self.splash.rootViewController = window.rootViewController;
    [self.splash showInView:window.rootViewController.view];
}

/// 在适配器被释放前
- (void)destroyAd {
    [self removeSplash];
}

/// 当前加载的广告的状态
- (UMTMediatedAdStatus)mediatedAdStatus {
    // 调用广告源提供的广告有效性校验方法
    if (self.splash.adInfoData) {
        // 广告有效
        return UMTMediatedAdStatusNormal;
    }
    return UMTMediatedAdStatusUnknown;
}

#pragma mark - Private
- (void)removeSplash {
    if (self.splash.superview) {
        [self.splash removeFromSuperview];
        self.splash = nil;
    }
    
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
        self.bottomView = nil;
    }
}

#pragma mark - KSSplashAdViewDelegate
/**
 * splash ad request done
 */
- (void)ksad_splashAdDidLoad:(KSSplashAdView *)splashAdView {
    [self.bridge splashAd:self didLoadWithExt:@{}];
}
/**
 * splash ad material load, ready to display
 */
- (void)ksad_splashAdContentDidLoad:(KSSplashAdView *)splashAdView {
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    if (self.umtBidType == UMTAdBidType_ClientBidding) {
        NSInteger price = splashAdView.ecpm;
        if (price>0) {
            [extDic setValue:[NSString stringWithFormat:@"%ld", price] forKey:UMTAdnAdLoadedExtECPM];
        }
    }
    
    [self.bridge splashAd:self didRenderSuccessWithExt:extDic];
}
/**
 * splash ad (material) failed to load
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didFailWithError:(NSError *)error {
    [self.bridge splashAd:self didLoadFailWithError:error ext:@{}];
}
/**
 * splash ad did visible
 */
- (void)ksad_splashAdDidVisible:(KSSplashAdView *)splashAdView {
    if (self.bottomView) {
        CGRect frame = splashAdView.frame;
        CGRect bottomFrame = self.bottomView.frame;
        self.bottomView.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, bottomFrame.size.height);
        
        [splashAdView.superview addSubview:self.bottomView];
    }
    
    [self.bridge splashAdDidShow:self];
}
/**
 * splash ad video begin play
 * for video ad only
 */
- (void)ksad_splashAdVideoDidBeginPlay:(KSSplashAdView *)splashAdView {
    
}
/**
 * splash ad clicked
 */
- (void)ksad_splashAdDidClick:(KSSplashAdView *)splashAdView {
    [self.bridge splashAdDidClick:self];
}
/**
 * splash ad skipped
 * @param showDuration  splash show duration (no subsequent callbacks, remove & release KSSplashAdView here)
 */
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didSkip:(NSTimeInterval)showDuration {
    [self.bridge splashAdDidClickSkip:self];
    
    [self.bridge splashAdDidClose:self];
    
    [self removeSplash];
}
/**
 * splash ad did enter conversion view controller
 */
- (void)ksad_splashAdDidOpenConversionVC:(KSSplashAdView *)splashAdView interactionType:(KSAdInteractionType)interactType {
    [self.bridge splashAdWillPresentFullScreenModal:self];
}
/**
 * splash ad close conversion viewcontroller or jump with deeplink
 */
- (void)ksad_splashAdDidCloseConversionVC:(KSSplashAdView *)splashAdView interactionType:(KSAdInteractionType)interactType {
    [self.bridge splashAdWillDismissFullScreenModal:self];
}
/**
 * splash ad play finished & auto dismiss (no subsequent callbacks, remove & release KSSplashAdView here)
 */
- (void)ksad_splashAdDidAutoDismiss:(KSSplashAdView *)splashAdView {
    [self.bridge splashAdDidClose:self];
    
    [self removeSplash];
}


@end
