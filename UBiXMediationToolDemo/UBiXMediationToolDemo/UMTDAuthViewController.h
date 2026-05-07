//
//  UMTDAuthViewController.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2025/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const UMTDemoAuthorized;

@interface UMTDUITools : NSObject

@end

@interface UMTDAuthViewController : UIViewController
@property (nonatomic, copy) void(^agreeBlock)(void);
@end

NS_ASSUME_NONNULL_END
