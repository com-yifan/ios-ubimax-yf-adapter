//
//  UMTDAdBaseViewController.h
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMTDAdBaseViewController : UIViewController

@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, assign) BOOL isLoadSucc;

@property (nonatomic, assign) float y;
@property (nonatomic, assign) float padding_x;
@property (nonatomic, assign) float padding_y;
@property (nonatomic, assign) float bottom;

@property (nonatomic, strong) UITextField *slotIdText;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIButton *isReadyBtn;
@property (nonatomic, strong) UIButton *showBtn;

- (void)loadAdAction;
- (BOOL)isReadyAction;
- (void)showAdAction;

- (void)showAlert:(NSString *)txt;

@end

NS_ASSUME_NONNULL_END
