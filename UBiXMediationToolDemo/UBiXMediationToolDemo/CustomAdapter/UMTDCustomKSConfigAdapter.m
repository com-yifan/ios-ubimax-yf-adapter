//
//  UMTDCustomConfigAdapter.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/5.
//

#import "UMTDCustomKSConfigAdapter.h"
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>
#import <KSAdSDK/KSAdSDK.h>

@interface UMTDCustomKSConfigAdapter () <UMTCustomConfigAdapter>

@end

@implementation UMTDCustomKSConfigAdapter

/// 该自定义adapter是基于哪个版本实现的，填写编写时的最新值即可，UMT会根据该值进行兼容处理
- (NSString *)basedOnCustomAdapterVersion {
    return nil;
}

/// adn初始化方法
/// @param initConfig 初始化配置，包括appid、appkey基本信息和部分用户传递配置
- (void)initializeAdapterWithConfiguration:(UMTAdnSDKInitConfig *_Nullable)initConfig completed:(void (^)(BOOL, NSError *))handler {
    NSString *customParamJsonStr = initConfig.customExtParamsStr;
    if (customParamJsonStr) {
        NSData *data = [customParamJsonStr dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSError *error = nil;
            NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!error && paramDic) {
                NSLog(@"自定义参数，param: %@", paramDic);
            }
        }
    }
    
    NSString *appId = initConfig.appID;
    if ([[KSAdSDKConfiguration configuration] respondsToSelector:@selector(setAppId:)]) {
        [[KSAdSDKConfiguration configuration] setAppId:appId];
    }
    if ([KSAdSDKManager respondsToSelector:@selector(startSyncWithCompletionHandler:)]) {
        [KSAdSDKManager startSyncWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (handler) {
                handler(success, error);
            }
        }];
    } else {
        if (handler) {
            NSError *err = [[NSError alloc] initWithDomain:@"com.ubixai.umtd.customKS"
                                                      code:404
                                                  userInfo:@{NSLocalizedDescriptionKey: @"KS startSync Failed"}];
            handler(NO, err);
        }
    }
}

/// adapter的版本号
- (NSString *_Nonnull)adapterVersion {
    return @"1.0.0";
}

/// adn的版本号
- (NSString *_Nonnull)adnSdkVersion {
    return [KSAdSDKManager SDKVersion];
}

/// 隐私权限更新，用户更新隐私配置时触发，初始化方法调用前一定会触发一次
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
    // 个性化推荐
    NSNumber *limitPersonl = config[kUMTPrivacyLimitPersonalAds];
    if (limitPersonl) {
        if([KSAdSDKManager respondsToSelector:@selector(setEnablePersonalRecommend:)]) {
            [KSAdSDKManager setEnablePersonalRecommend: !limitPersonl];
        }
    }
    // 定位权限
    NSNumber *location = config[kUMTPrivacyCanLocation];
    if (location) {
        [KSAdSDKManager setDisableUseLocationStatus:!location];
    }
    // IDFA
    NSNumber *forbidIDFA = config[kUMTPrivacyForbiddenIDFA];
    if (forbidIDFA) {
        
    }
    
    NSString *customIDFA = config[kUMTPrivacyCustomIDFA];
    if (customIDFA) {
       
    }
}

@end
