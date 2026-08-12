//
//  UMTDInterstitialViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import "UMTDInterstitialViewController.h"
#import "UMTDSlotIdDefines.h"
#import "UMTDLogger.h"
#import "UbixMDBulletScreenManager.h"

@interface UMTDInterstitialViewController () <UMTInterstitialLoadDelegate, UMTInterstitialShowDelegate>

@property (nonatomic, strong) UMTInterstitial *interstitialAd;

@end

@implementation UMTDInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)loadAdAction {
    UMTInterstitial *interstitialAd = [[UMTInterstitial alloc] initWithSlotId:InterstitialSlotID];
    self.interstitialAd = interstitialAd;
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    if (self) {
        [extra setValue:self forKey:(NSString *)kUMTRootViewController];
    }
    //插屏点击后关闭广告, @YES:关闭, @NO:不关闭,  默认不关闭
//    [extra setValue:@YES forKey:UMTAdLoadingParamInter_CloseAfterClick];
    [[UMTAdManager sharedManager] loadInterstitial:interstitialAd extra:extra delegate:self];
}

- (BOOL)isReadyAction {
    return [[UMTAdManager sharedManager] isReadyForInterstitial:self.interstitialAd];
}

- (void)showAdAction {
    [[UMTAdManager sharedManager] showInterstitial:_interstitialAd inRootVC:self delegate:self];
}

#pragma mark - UMTInterstitialLoadDelegate

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didLoadWithExtra:(NSDictionary *)extra {
    self.isLoadSucc = YES;
    UMTDLog(@"插屏-加载成功 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didLoadFailed:(UMTError *)error {
    UMTDLog(@"插屏-加载失败 %s, error: %@", __func__, error.localizedDescription);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}

#pragma mark -  UMTInterstitialShowDelegate

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didShowWithExtra:(NSDictionary *)extra {
    UMTDLog(@"插屏-展示成功 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didShowFailed:(UMTError *)error {
    UMTDLog(@"插屏-展示失败 %s， error = %@", __func__, error);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didClickWithExtra:(NSDictionary *)extra {
    UMTDLog(@"插屏-点击 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didCloseWithExtra:(NSDictionary *)extra {
    UMTDLog(@"插屏-关闭 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtInterstitial:(UMTInterstitial *)interstitialAd didDetailCloseWithExtra:(NSDictionary *)extra {
    UMTDLog(@"插屏-详情关闭 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
