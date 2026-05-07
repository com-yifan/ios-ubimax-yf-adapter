//
//  UMTDCustomKSNativeHelper.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/17.
//

#import <Foundation/Foundation.h>
#import <UBiMAXAdSDK/UBiMAXAdSDK-umbrella.h>
#import <KSAdSDK/KSNativeAd.h>
#import <KSAdSDK/KSNativeAdRelatedView.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMTDCustomKSNativeHelper : NSObject<UMTMediationNativeAdData, UMTMediationNativeAdViewCreator>

@property (nonatomic, strong) KSNativeAdRelatedView *relatedView;

- (instancetype)initWithAdData:(KSNativeAd *)data;
@end

NS_ASSUME_NONNULL_END
