//
//  UMTDSplashViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import "UMTDSplashViewController.h"
#import <UBiMAXAdSDK/UMTAdSDK.h>
#import <UBiMAXSplash/UBiMAXSplash-umbrella.h>
#import "UMTDLogger.h"
#import "UbixMDBulletScreenManager.h"
#import "Masonry/Masonry.h"

@interface UMTDSplashViewController () <UMTSplashDelegate>
@property (nonatomic, strong) UMTSplash *splashAd;
@property (nonatomic, strong) UISwitch *bottomSwitch;
@end

@implementation UMTDSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *switchLb = [[UILabel alloc] initWithFrame:CGRectMake(self.padding_x, self.y+10 , 50, 40)];
    switchLb.text = @"Logo";
    [self.view addSubview:switchLb];
    
    self.bottomSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.padding_x, self.y, 100, 40)];
    [self.view addSubview:self.bottomSwitch];
    [self.bottomSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchLb.mas_right);
        make.centerY.equalTo(switchLb.mas_centerY);
    }];
    
}

- (void)loadAdAction {
    _splashAd = [[UMTSplash alloc] initWithSlotId:self.slotId];
    if (self.bottomSwitch.on) {
        UILabel *bottom = [[UILabel alloc] init];
        bottom.backgroundColor = [UIColor lightGrayColor];
        bottom.text =[NSString stringWithFormat:@"开发者自定义view"];
        bottom.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        bottom.contentMode = UIViewContentModeCenter;
        bottom.textAlignment = NSTextAlignmentCenter;
        _splashAd.bottomView = bottom;
    }

    [[UMTAdManager sharedManager] loadSplashAd:_splashAd extra:@{} delegate:self];
}

- (BOOL)isReadyAction {
    return [[UMTAdManager sharedManager] isReadyForSplash:_splashAd];
}

- (void)showAdAction {
    if ([[UMTAdManager sharedManager] isReadyForAd:_splashAd]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [[UMTAdManager sharedManager] showSplash:_splashAd 
                                          window:window
                                        delegate:self];
    }
}

#pragma mark - UMTSplashAdDelegate
/// 开屏广告加载失败
- (void)umtSplashAd:(UMTSplash *)splash didLoadSuccWithExt:(nonnull NSDictionary *)ext {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    UMTDLog(@"加载成功，%s", __func__);
    
    self.isLoadSucc = YES;
    
}
/// 开屏广告加载失败
- (void)umtSplashAd:(UMTSplash *)splash didLoadFailed:(UMTError *)error {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s, errCode:%d", __func__, error.code]];
    UMTDLog(@"加载失败，%s， error: %@", __func__, error.localizedDescription);
}

- (void)umtSplashAd:(UMTSplash *)splash didShowSuccWithExt:(NSDictionary *)ext {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    UMTDLog(@"展示成功，%s", __func__);
}

- (void)umtSplashAd:(UMTSplash *)splash didShowFailed:(UMTError *)error {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s, errCode:%d", __func__, error.code]];
    UMTDLog(@"展示失败，%s, error: %@", __func__, error.localizedDescription);
}

- (void)umtSplashAd:(UMTSplash *)splash didClickWithExt:(NSDictionary *)ext {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    UMTDLog(@"广告点击，%s", __func__);
}

- (void)umtSplashAd:(UMTSplash *)splash didCloseWithExt:(NSDictionary *)ext {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    UMTDLog(@"广告关闭，%s", __func__);
}

- (void)umtSplashAd:(UMTSplash *)splash didDetailCloseWithExt:(NSDictionary *)ext {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    UMTDLog(@"广告详情关闭，%s", __func__);
}
#pragma mark - Private

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
