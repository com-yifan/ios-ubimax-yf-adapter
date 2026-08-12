//
//  AppDelegate.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/7/3.
//

#import "AppDelegate.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import "UMTDSlotIdDefines.h"
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>
#import <UbiXDaq/UbiXDaq.h>
//#import <UbiXAdSDK/UbiXAdSDK.h>
//#import <UbiXMediation/UbiXMediation.h>
//#import <UBiddindAdSDK/UBiddingAdSDK-umbrella.h>
//#import <UBiMAXSplash/UBiMAXSplash-umbrella.h>
//#import <UBiMAXInterstitial/UBiMAXInterstitial-umbrella.h>
//#import <UBiMAXRewardedVideo/UBiMAXRewardedVideo-umbrella.h>
//#import <UBiMAXNative/UBiMAXNative-umbrella.h>
//#import <UBiMAXBanner/UBiMAXBanner-umbrella.h>
//#import <UBiMAXUBiXAdapter/UBiMAXUBiXAdapter-umbrella.h>
//#import <MSAdSDK/MSAdSDK.h>
//#import <KSAdSDK/KSAdSDK.h>
//#import <GDTMobSDK/GDTMobSDK.h>
//#import <BaiduMobAdSDK/BaiduMobAdSDK.h>
//#import <SmartdigimktSDK/SmartdigimktSDK.h>
//#import <AnyThinkSDK/AnyThinkSDK.h>
//#import <BUAdSDK/BUAdSDKManager.h>
//#import <WindMillSDK/WindMillSDK.h>
//#import <WindSDK/WindAds.h>
//#import <WindFoundation/WindFoundation.h>
//#import <BeiZiSDK/BeiZiSDK.h>
//#import <EdiMobSDK/EdiMobSDK.h>
//#import <OctAdSDK/OctAdManager.h>
//#import <YFAdsSDK/YFAdsSDK.h>
//#import <MSaas/MSaas.h>
//#import <XingheMediation/XingheMediation.h>
//#import <DMAdSDK/DMAdSDK.h>
//#import <DomobSDKAdapter/DomobSDKAdapter.h>
//#import <AdScopeFoundation/AdScopeFoundation.h>
//#import <AMPSAdSDK/AMPSAdSDK.h>
//#import <ADSuyiSDK/ADSuyiSDK.h>
//#import <DirichletMediationSDK/DirichletMediationSDK.h>
//#import <KSCrash/KSCrash.h>
//#import <WechatOpenSDK/WechatAuthSDK.h>
//#import <libwebp/libwebp-umbrella.h>
//#import <JADYun/JADYun.h>
//#import <KTVHTTPCache/KTVHTTPCache.h>
//#import <CJMobileAd/CJMobileAd.h>
//#import <CJZFAdSDK/CJZFAdSDK.h>
//#import <LYJTAdSDK/LYJTAdSDK.h>
//#import <LYAdSDK/LYAdSDK.h>
//#import <LY_AdSDK/LY_AdSDK.h>
//#import <LingYeAdSDK/LingYeAdSDK.h>
//#import <AdWangMaiSDK/AdWangMaiSDK.h>

#if __has_include(<BUAdSDK/BUAdSDK.h>)
#import <BUAdSDK/BUAdSDK.h>
#endif
//#import <UbiXMediation/UbiXMediation.h>

#import "UMTDLogger.h"
#import "UMTDAuthViewController.h"

@interface AppDelegate () <UMTSplashDelegate>

@property (nonatomic, strong) UMTSplash * splashAd;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"Daq, v%@", UBIX_DAQ_VERSION);
//    NSLog(@"UbiX, v%2", [UBiXAdSDKManager SDKVersion]);
//    NSLog(@"NOW, v%@", [UbiXMediationSDK sdkVersion]);
    NSLog(@"UBidding, v%@", [UMTAdSDKManager SDKVersion]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isAuthed = [[defaults objectForKey:UMTDemoAuthorized] boolValue];
    
    if (isAuthed) {
        
        [self setupUMTAdSDK];
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)setupUMTAdSDK {
    UMTDLog(@"UBidding, v%@", [UMTAdSDKManager SDKVersion]);
    
    UMTAdSDKConfiguration *config = [[UMTAdSDKConfiguration alloc] init];
    config.appID = APP_ID;
    config.debugLogEnabled = YES;
    config.canReadNetType = YES;
    config.canReadIDFA = YES;
    //config.customIDFA = @"D0000004-400C-400E-B00E-E00000000004";
    // 是否允许UBidding对于定位信息的获取
    config.locationEnabled = YES;
    // 允许个性化推荐
    config.limitPersonalAds = NO;
    
    // 用户信息，流量分组
    UMTUserInfoConfig *userInfo = [[UMTUserInfoConfig alloc] init];
    userInfo.userId = @"YOU_USER_ID";
    userInfo.channel = @"AppleStore";
    userInfo.subChannel=@"subChannel";
    userInfo.isSubscriber = UMTUserInfoSubscribe_Yes;
    
    config.userInfoConfig = userInfo;
    
    __weak typeof(self) weakSelf = self;
    [UMTAdSDKManager startSyncWithConfig:config completionHandler:^(BOOL succ, NSError *err) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (succ) {
            // 初始化完成，处理广告请求
            
            UMTSplash *splash = [[UMTSplash alloc] initWithSlotId:SplashSlotID];
            strongSelf.splashAd = splash;
            [[UMTAdManager sharedManager] loadSplashAd:splash extra:@{} delegate:strongSelf];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestIDFATracking];
    });
}

- (void)requestIDFATracking {
if (@available(iOS 14, *)) {
    // iOS14及以上版本需要先请求权限
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        // 获取到权限后，依然使用老方法获取idfa
        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            UMTDLog(@"IDFA: %@",idfa);
        } else {
            UMTDLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
        }
    }];
} else {
    // iOS14以下版本依然使用老方法
    // 判断在设置-隐私里用户是否打开了广告跟踪
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        UMTDLog(@"IDFA: %@",idfa);
    } else {
        UMTDLog(@"请在设置-隐私-广告中打开广告跟踪功能");
    }
}
}

#pragma mark - UMTSplashDelegate
/// 开屏广告加载成功
- (void)umtSplashAd:(UMTSplash *)splash didLoadSuccWithExt:(NSDictionary *)ext {
    UMTDLog(@"加载成功，%s", __func__);
    
    if ([[UMTAdManager sharedManager] isReadyForSplash:splash]) {
        [[UMTAdManager sharedManager] showSplash:splash
                                          window:[UIApplication sharedApplication].keyWindow
                                        delegate:self];
    }
}
/// 开屏广告加载失败
- (void)umtSplashAd:(UMTSplash *)splash didLoadFailed:(UMTError *)error {
    UMTDLog(@"加载失败，%s， error: %@", __func__, error.localizedDescription);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.splashAd = nil;
    });
}

- (void)umtSplashAd:(UMTSplash *)splash didShowSuccWithExt:(NSDictionary *)ext {
    UMTDLog(@"展示成功，%s, ext= %@", __func__, ext);
}

- (void)umtSplashAd:(UMTSplash *)splash didClickWithExt:(NSDictionary *)ext {
    UMTDLog(@"广告点击，%s", __func__);
}

- (void)umtSplashAd:(UMTSplash *)splash didCloseWithExt:(NSDictionary *)ext {
    UMTDLog(@"广告关闭，%s", __func__);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.splashAd = nil;
    });
}

- (void)umtSplashAd:(UMTSplash *)splash didDetailCloseWithExt:(NSDictionary *)ext {
    UMTDLog(@"广告详情关闭，%s", __func__);
}

@end
