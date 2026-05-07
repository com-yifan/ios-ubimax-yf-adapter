//
//  UMTDBannerViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import "UMTDBannerViewController.h"
#import <UBiMAXBanner/UBiMAXBanner-umbrella.h>
#import <UBiMAXBanner/UMTAdManager+Banner.h>
#import "UMTDSlotIdDefines.h"
#import "UMTDLogger.h"
#import "UbixMDBulletScreenManager.h"

@interface UMTDBannerViewController () <UMTBannerLoadDelegate, UMTBannerShowDelegate>

@property (nonatomic, strong) UMTBanner *bannerAd;

@property (nonatomic, strong) UIView *bannerContainer;

@property (nonatomic, assign) CGSize adSize;


@end

@implementation UMTDBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBannerContainer];
}


- (void)setupBannerContainer {
    CGSize bannerSize = CGSizeMake(320, 50);
    self.adSize = bannerSize;
    
    self.bannerContainer = [[UIView alloc] init];
    CGFloat width = bannerSize.width;
    CGFloat height = bannerSize.height;
    self.bannerContainer.userInteractionEnabled = YES;
    self.bannerContainer.frame = CGRectMake((self.view.frame.size.width - width) / 2, (self.view.frame.size.height - height)/2, width, height);
    [self.view addSubview:self.bannerContainer];
}



- (void)loadAdAction {
    
    if (self.bannerAd) {
        [self.bannerAd destroy];
    }
    
    CGSize bannerSize = self.adSize;
    UMTBanner *bannerAd = [[UMTBanner alloc] initWithSlotId:BannerSlotID adSize:bannerSize];
    self.bannerAd = bannerAd;
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    // 部分广告源需要传递控制器, 必传控制器参数
    [extra setValue:self forKey:(NSString *)kUMTRootViewController];
    
    [[UMTAdManager sharedManager] loadBanner:bannerAd extra:extra delegate:self];
}

- (BOOL)isReadyAction {
    return [[UMTAdManager sharedManager] isReadyForBanner:self.bannerAd];
}

- (void)showAdAction {
    [[UMTAdManager sharedManager] showBanner:self.bannerAd
                                inParentView:self.bannerContainer
                                    delegate:self];
}

#pragma mark - UMTBannerLoadDelegate

- (void)umtBanner:(UMTBanner *)bannerAd didLoadWithExtra:(NSDictionary *)extra {
    CGFloat width = bannerAd.adView.frame.size.width;
    CGFloat height = bannerAd.adView.frame.size.height;
    self.bannerContainer.frame = CGRectMake((self.view.frame.size.width - width) / 2, (self.view.frame.size.height - height)/2, width, height);
    
    self.isLoadSucc = YES;
    uint64_t price = [bannerAd getEcpm];
    UMTAdnInfo *adnInfo = bannerAd.winnerAdnInfo;
    UMTDLog(@"横幅-加载成功，%s, price=%ld, adnName=%@", __func__, price, adnInfo.adnName);
    
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtBanner:(UMTBanner *)bannerAd didLoadFailed:(UMTError *)error {
    UMTDLog(@"横幅-加载失败 %s, error: %@", __func__, error.localizedDescription);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}

#pragma mark -  UMTBannerShowDelegate

- (void)umtBanner:(UMTBanner *)bannerAd didShowWithExtra:(NSDictionary *)extra {
    UMTDLog(@"横幅-展示成功 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtBanner:(UMTBanner *)bannerAd didShowFailed:(UMTError *)error {
    UMTDLog(@"横幅-展示失败 %s， error = %@", __func__, error);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}

- (void)umtBanner:(UMTBanner *)bannerAd didClickWithExtra:(NSDictionary *)extra {
    UMTDLog(@"横幅-点击 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtBanner:(UMTBanner *)bannerAd didCloseWithExtra:(NSDictionary *)extra {
    UMTDLog(@"横幅-关闭 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    
    [self.bannerAd destroy];
}

- (void)umtBanner:(UMTBanner *)bannerAd willPresentDetailWithExtra:(NSDictionary *)extra {
    UMTDLog(@"横幅-详情打开 %s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtBanner:(UMTBanner *)bannerAd didDetailCloseWithExtra:(NSDictionary *)extra {
    UMTDLog(@"横幅-详情关闭 %s", __func__);
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
