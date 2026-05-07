//
//  UbixMDBulletScreenManager.h
//  MediationDemo
//
//  Created by zhgq on 2023/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UbixMDBulletScreenManager : NSObject

- (void)showWithText:(NSString *)text;

- (void)beginScene:(NSString *)scene;
- (void)endScene:(NSString *)scene;

#pragma mark - Singleton
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
