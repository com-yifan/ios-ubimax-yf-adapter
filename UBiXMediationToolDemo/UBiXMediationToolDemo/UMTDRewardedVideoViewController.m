//
//  UMTDRewardedVideoViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import "UMTDRewardedVideoViewController.h"
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>
#import "UMTDSlotIdDefines.h"
#import "UMTDLogger.h"
#import "UbixMDBulletScreenManager.h"

@interface UMTDRewardedVideoViewController () <UMTRewardedVideoLoadDelegate, UMTRewardedVideoShowDelegate>
@property (nonatomic, strong) UMTRewardedVideo *rewardedVideoAd;
@end

@implementation UMTDRewardedVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)loadAdAction {
    UMTRewardedVideo *ad = [[UMTRewardedVideo alloc] initWithSlotId:RewardSlotID];
    self.rewardedVideoAd = ad;
    [[UMTAdManager sharedManager] loadRewardedVideo:ad extra:@{} delegate:self];
}

- (BOOL)isReadyAction {
    return [[UMTAdManager sharedManager] isReadyForRewardedVideo:_rewardedVideoAd];
}

- (void)showAdAction {
    [[UMTAdManager sharedManager] showRewardedVideo:_rewardedVideoAd inRootVC:self delegate:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UMTRewardedVideoLoadDelegate

- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didLoadWithExtra:(NSDictionary *)extra {
    UMTDLog(@"激励视频-加载成功 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    self.isLoadSucc = YES;
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didLoadFailed:(UMTError *)error {
    UMTDLog(@"激励视频-加载失败 %s， error = %@", __func__, error.localizedDescription);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}


#pragma mark -  UMTRewardedVideoShowDelegate>


- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didShowWithExtra:(NSDictionary *)extra {
    UMTDLog(@"激励视频-展示 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didShowFailed:(UMTError *)error {
    UMTDLog(@"激励视频-展示失败 %s， error= %@", __func__, error.localizedDescription);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didClickWithExtra:(NSDictionary *)extra {
    UMTDLog(@"激励视频-点击 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didCloseWithExtra:(NSDictionary *)extra {
    UMTDLog(@"激励视频-关闭 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didRewardedWithExtra:(NSDictionary *)extra {
    UMTDLog(@"激励视频-奖励 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didPlayStartWithExtra:(NSDictionary *)extra {
    UMTDLog(@"激励视频-播放 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didChangedPlayStatus:(UMTVideoPlayerStatus)status {
    UMTDLog(@"激励视频-播放状态改变 %s， status=%ld", __func__, status);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtRewardedVideo:(UMTRewardedVideo *)rewardedVideoAd didPlayFinishWithExtra:(NSDictionary *)extra failed:(UMTError *)error {
    UMTDLog(@"激励视频-播放完成 %s， error = %@", __func__, error.localizedDescription);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}

@end
