//
//  UMTDCustomBaseAdAdapter.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/10.
//

#import <Foundation/Foundation.h>
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMTDCustomKSBaseAdAdapter : NSObject

@property (nonatomic, assign) UMTAdBidType umtBidType;
@property (nonatomic, assign) UMTVideoMuteType umtVideoMuteType;
@property (nonatomic, assign) UMTVideoPlayNetType umtVideoPlayNetType;

@end

NS_ASSUME_NONNULL_END
