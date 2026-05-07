//
//  UMTDCustomNativeAdapter.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/10.
//

#import "UMTDCustomKSBaseAdAdapter.h"
#import <UBiMAXAdSDK/UBiMAXAdSDK-umbrella.h>
#import <KSAdSDK/KSAdSDK.h>
#import "UMTDLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMTDCustomKSNativeAdapter : UMTDCustomKSBaseAdAdapter <UMTCustomNativeAdapter>

@property (nonatomic, strong) KSNativeAdsManager *nativeAdsManager;
@property (nonatomic, strong) KSNativeAd *ksNativeAd;
@property (nonatomic, strong) KSFeedAdsManager *feedAdsManager;
@property (nonatomic, strong) KSFeedAd *ksFeedAd;
@property (nonatomic, assign) UMTAdRenderType renderType;
@property (nonatomic, assign) BOOL isLoadSucc;

@end

NS_ASSUME_NONNULL_END
