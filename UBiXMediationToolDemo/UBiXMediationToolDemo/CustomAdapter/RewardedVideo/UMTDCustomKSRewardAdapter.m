//
//  UMTDCustomKSRewardAdapter.m
//  
//
//  Created by guoqiang on 2024/12/17.
//

#import "UMTDCustomKSRewardAdapter.h"
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>
#import <KSAdSDK/KSAdSDK.h>
#import "UMTDLogger.h"

@interface UMTDCustomKSRewardAdapter () <UMTCustomRewardedVideoAdapter, KSRewardedVideoAdDelegate>

@property (nonatomic, strong) NSString *placementId;
@property (nonatomic, strong) KSRewardedVideoAd *rewardedVideoAd;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) BOOL isLoadSucc;

@end

@implementation UMTDCustomKSRewardAdapter

- (UMTMediatedAdStatus)mediatedAdStatus {
    if (self.isLoadSucc && self.rewardedVideoAd.isValid) {
        return UMTMediatedAdStatusNormal;
    }
    return UMTMediatedAdStatusUnknown;
}

/// 加载广告的方法
/// @param slotID adn的广告位ID
/// @param parameter 广告加载的参数
- (void)loadRewardedVideoAdWithSlotID:(NSString *)slotID andParameter:(NSDictionary *)parameter {
    NSNumber *bidType = parameter[UMTAdLoadingParamBiddingType];
    self.umtBidType = (UMTAdBidType)bidType.integerValue;
    NSNumber *videoMuteNum = parameter[UMTAdLoadingParamVideoMute];
    self.umtVideoMuteType = (UMTVideoMuteType)videoMuteNum.integerValue;
    NSNumber *videoPlayNet = parameter[UMTAdLoadingParamVideoPlayNet];
    self.umtVideoPlayNetType = (UMTVideoPlayNetType)videoPlayNet.integerValue;
    
    KSRewardedVideoModel *model = [KSRewardedVideoModel new];
    // 如果开启服务端回调的话，userId和extra会通过回调接口回传给接入方
    //    model.userId = @"123234";
    //    model.extra = @"test extra";
    KSRewardedVideoAd *rewardAd = [[KSRewardedVideoAd alloc] initWithPosId:slotID rewardedVideoModel:model];
    self.rewardedVideoAd = rewardAd;
    rewardAd.delegate = self;
    rewardAd.innerDelegate = self;
    // 静音
    switch (self.umtVideoMuteType) {
        case UMTVideoMuteType_NoMute:
            rewardAd.shouldMuted = NO;
            break;
        case UMTVideoMuteType_Mute:
            rewardAd.shouldMuted = YES;
            break;
            
        default:
            break;
    }
    
    [rewardAd loadAdData];
}

/// 展示广告的方法
/// @param viewController 控制器对象
/// @param parameter 展示广告的参数，接入媒体配置
- (void)showAdFromRootViewController:(UIViewController *_Nonnull)viewController parameter:(NSDictionary *)parameter {
    [self.rewardedVideoAd showAdFromRootViewController:viewController];
}

- (void)didReceiveBidResult:(UMTMediaBidResult *)result {
    
}


#pragma mark - KSRewardedVideoAdDelegate
/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    self.isLoadSucc = YES;
    
    [self.bridge rewardedVideoAd:self didLoadWithExt:@{}];
}
/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    UMTDLog(@"%s, error = %@", __func__, error.localizedDescription);
    
    [self.bridge rewardedVideoAd:self didLoadFailWithError:error ext:@{}];
}
/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdVideoDidLoad:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    
    NSDictionary *mediaExtra = rewardedVideoAd.mediaExtraInfo;
    
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    if (self.umtBidType == UMTAdBidType_ClientBidding) {
        NSInteger price = rewardedVideoAd.ecpm;
        if (price>0) {
            [extDic setValue:[NSString stringWithFormat:@"%ld", price] forKey:UMTAdnAdLoadedExtECPM];
        }
    }
    
    [self.bridge rewardedVideoAd:self videoDidLoadWithExt:extDic];
}
/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardedVideoAdWillVisible:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
}
/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    [self.bridge rewardedVideoAdDidVisible:self];
}
/**
 This method is called when video ad is about to close.
 */
- (void)rewardedVideoAdWillClose:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
}
/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    [self.bridge rewardedVideoAdDidClose:self];
}

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    [self.bridge rewardedVideoAdDidClick:self];
}
/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    UMTDLog(@"%s, error = %@", __func__, error.localizedDescription);
    [self.bridge rewardedVideoAd:self didPlayFinishWithError:error];
}
/**
 This method is called when the user clicked skip button.
 */
- (void)rewardedVideoAdDidClickSkip:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    [self.bridge rewardedVideoAdDidClickSkip:self];
    
}
/**
 This method is called when the user clicked skip button.
 @param currentTime played duration
 */
- (void)rewardedVideoAdDidClickSkip:(KSRewardedVideoAd *)rewardedVideoAd currentTime:(NSTimeInterval)currentTime {
    UMTDLog(@"%s", __func__);
}
/**
 This method is called when the video begin to play.
 */
- (void)rewardedVideoAdStartPlay:(KSRewardedVideoAd *)rewardedVideoAd {
    UMTDLog(@"%s", __func__);
    [self.bridge rewardedVideoAd:self didChangeState:UMTVideoPlayerStatusStarted];
}
/**
 This method is called when the user is rewarded.
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd hasReward:(BOOL)hasReward {
    UMTDLog(@"%s", __func__);
    [self.bridge rewardedVideoAd:self didServerRewardSuccessWithInfo:^(UMTAdapterRewardAdInfo *info) {
        
    }];
}
/**
 This method is called when the user close video ad,support staged rewards.
 */
/**
 * 激励|分阶段奖励回调（激励广告新玩法，相关政策请联系商务或技术支持）
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd
              hasReward:(BOOL)hasReward
               taskType:(KSAdRewardTaskType)taskType
        currentTaskType:(KSAdRewardTaskType)currentTaskType {
    UMTDLog(@"%s", __func__);
}
/**
 This method is called when the user close video ad,extra rewards verify.
 */
- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd extraRewardVerify:(KSAdExtraRewardType)extraRewardType {
    UMTDLog(@"%s", __func__);
}

#pragma mark - KSInnerAdDelegate
- (void)onInnerAdClick:(KSInnerVideoAd *)innerAd {
    NSString *text = @"Unknown";
    if (innerAd.adType == KSInnerAdReflow) {
        text = @" reflowPage";
    }
    if (innerAd.adType == KSInnerAdAggregation) {
        text = @" AdAggregation";
    }
    UMTDLog(@"%s", __func__);
}

- (void)onInnerAdShow:(KSInnerVideoAd *)innerAd {
    
    NSString *text = @" Unknown";
    if (innerAd.adType == KSInnerAdReflow) {
        text = @" reflowPage";
    }
    if (innerAd.adType == KSInnerAdAggregation) {
        text = @" AdAggregation";
    }
    
    UMTDLog(@"%s", __func__);
}

@end
