//
//  UMTDSelfRenderNativeView.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/9/2.
//

#import <UIKit/UIKit.h>
#import <UBiMAXNative/UMTNativeOffer.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMTDMeidaContainerView : UIView

@end

@interface UMTDSelfRenderNativeView : UIView <UMTMediationNativeSelfRenderViewCreator>

@property (nonatomic, weak) UMTNativeOffer *offer;

- (id)initWithNativeOffer:(UMTNativeOffer *)offer;

- (void)registerAdView;

@end

NS_ASSUME_NONNULL_END
