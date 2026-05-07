//
//  UbixMDBulletScreenManager.m
//  MediationDemo
//
//  Created by zhgq on 2023/8/29.
//

#import "UbixMDBulletScreenManager.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UbixMDBulletScreenModel.h"
//#import "DemoLogOperation.h"

static const int kBulletNum = 15;

@interface UbixMDBulletScreenManager ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *overTextArray;
@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, assign) BOOL haveInstalled;

@end

@implementation UbixMDBulletScreenManager

+ (void)install {
    UbixMDBulletScreenManager *manager = [UbixMDBulletScreenManager sharedInstance];
    if (manager.haveInstalled) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:manager.contentView];
        manager.haveInstalled = YES;
        [manager.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@64);
            make.height.equalTo(manager.contentView.superview.mas_height).multipliedBy(0.3);
        }];
    });
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    label.text = text;
    label.layer.borderColor = [UIColor greenColor].CGColor;
    label.textColor = [UIColor blueColor];
    label.layer.borderWidth = 0.5;
    return label;
}

- (void)showWithText:(NSString *)text {
    if (text.length == 0) {
        return;
    }
//    [[DemoLogOperation shareLogOperation] writeLog:text];
#if DISABLE_TOAST
    return;
#endif
    [UbixMDBulletScreenManager install];
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [weakSelf _showWithText:text];
    }];
}

- (void)beginScene:(NSString *)scene {
//    [[DemoLogOperation shareLogOperation] beginToWriteLog:scene];
}

- (void)endScene:(NSString *)scene {
//    [[DemoLogOperation shareLogOperation] endToWriteLog:scene];
}

- (void)_showWithText:(NSString *)text {
    NSInteger currentIndex = [self currentIndex];
    if (currentIndex == -1) {
        // 当前屏幕的弹道全都使用了，存到overTextArray，等弹道释放了再展示
        [self storeText:text];
        return;
    }
    [self.contentView.superview bringSubviewToFront:self.contentView];
    UILabel *label = [self labelWithText:text];
    [label sizeToFit];
    CGFloat labelHeight = label.frame.size.height;
    [self.contentView addSubview:label];
    __block MASConstraint *leftConstraint = nil;
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(currentIndex * (labelHeight + 5)));
        make.height.equalTo(@(labelHeight));
        leftConstraint = make.left.equalTo(@(width));
    }];
    [self.contentView layoutIfNeeded];
    // 弹幕出现占用弹道
    [self occupyTrajectory:currentIndex];
    NSTimeInterval druation = width = 6 * (width + label.frame.size.width) / width;
    [UIView animateWithDuration:druation animations:^{
        // 设置动画约束
        leftConstraint.equalTo(@(-label.frame.size.width));
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        // 弹幕消失后释放弹道
        [self releaseTrajectory:currentIndex];
    }];
}

// 释放弹道 此时如果overIndexArr有多余的弹幕 展示弹幕
- (void)releaseTrajectory:(NSInteger)currentIndex {
    [self.lock lock];
    if (self.textArray.count > currentIndex) {
        self.textArray[currentIndex] = @(0);
    }
    int overbulletCount = (int)self.overTextArray.count;
    if (currentIndex != -1 && overbulletCount > 0) {
        // 这个循环一定要用overbulletCount 不可以在循环里用overTextArray.count 因为overTextArray在改变
        for (int i = 0; i < overbulletCount; i++) {
            NSString *text = [self.overTextArray firstObject];
            [self.overTextArray removeObjectAtIndex:0];
            [self showWithText:text];
        }
    }
    [self.lock unlock];
}

// 占用弹道
- (void)occupyTrajectory:(NSInteger)currentIndex {
    [self.lock lock];
    if (self.textArray.count > currentIndex) {
        self.textArray[currentIndex] = @(1);
    }
    [self.lock unlock];
}

- (void)storeText:(NSString *)text {
    [self.lock lock];
    [self.overTextArray addObject:text];
    [self.lock unlock];
}

- (NSInteger)currentIndex {
    __block NSInteger resultIndex = -1;
    [self.lock lock];
    // 找到第一个空闲（为0）的弹道
    [self.textArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj intValue] == 0) {
            resultIndex = idx;
            *stop = YES;
        }
    }];
    [self.lock unlock];
    return resultIndex;
}

#pragma mark - Singleton
- (instancetype)init {
    if (self = [super init]) {
        self.textArray = [[NSMutableArray alloc] initWithCapacity:kBulletNum];
        for (int i = 0; i < kBulletNum; i++) {
            self.textArray[i] = @(0);
        }
        self.overTextArray = [NSMutableArray new];
        self.contentView = [UIView new];
        self.contentView.userInteractionEnabled = NO;
        self.lock = [NSLock new];
    }
    return self;
}
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
