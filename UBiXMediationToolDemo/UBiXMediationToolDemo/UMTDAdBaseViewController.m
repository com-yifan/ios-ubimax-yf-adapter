//
//  UMTDAdBaseViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import "UMTDAdBaseViewController.h"
#import "UMTDLogger.h"

#define UMTD_SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface UMTDAdBaseViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *statusLb;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation UMTDAdBaseViewController

+ (CGFloat)statusBarHeight {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view .backgroundColor = [UIColor whiteColor];
   
    [self setupSubViews];
    
}

- (void)dealloc
{
    UMTDLog(@"----- %@ dealloc -----", self);
}


- (void)loadAdAction {}
- (BOOL)isReadyAction { return NO;}
- (void)showAdAction {}

#pragma mark - Action
- (void)loadAdAction:(UIButton *)btn {
    [self loadAdAction];
}

- (void)isReadyAction:(UIButton *)btn {
    if (_isLoadSucc && [self isReadyAction]) {
        [self showAlert:@"Ready"];
    } else {
        [self showAlert:@"Ad load not Succ"];
    }
    
}

- (void)showAdAction:(UIButton *)btn {
    if (_isLoadSucc) {
        [self showAdAction];
    } else {
        [self showAlert:@"Not Ready"];
    }
}

- (void)showAlert:(NSString *)txt {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:txt preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)cancelInput:(UIButton *)btn {
    [self.slotIdText resignFirstResponder];
    btn.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cancelBtn.hidden = NO;
}

#pragma mark - Private

- (void)setupSubViews {
    float y = self.navigationController.navigationBar.bounds.size.height + [UMTDAdBaseViewController statusBarHeight];
    y += 10;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 100, 50)];
    _statusLb = lb;
    lb.text = @"广告位：";
    [self.view addSubview:lb];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(UMTD_SCREEN_W - 50, y, 50, 50)];
    [cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancelBtn setTitle:@"X" forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelInput:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    cancelBtn.hidden = YES;
    self.cancelBtn = cancelBtn;
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(120, y, cancelBtn.frame.origin.x - lb.frame.size.width-lb.frame.origin.x, 50)];
    tf.delegate = self;
    _slotIdText = tf;
    tf.borderStyle = UITextBorderStyleLine;
    tf.text = self.slotId;
    [self.view addSubview:self.slotIdText];
    
    
    
    y+=50;
    
    self.y = y;
    
    float bottom = self.view.bounds.size.height;
    CGFloat kPadding_Y = 20;
    self.padding_y = kPadding_Y;
    bottom -= kPadding_Y;
    
    CGFloat kPadding_X = 30;
    self.padding_x = kPadding_X;
    
    CGFloat kButton_H = 40;
    self.showBtn = [self createButtonWithTitle:@"ShowAd" action:@selector(showAdAction:) frame:CGRectMake(kPadding_X, bottom - kButton_H, UMTD_SCREEN_W - 2*kPadding_X, kButton_H)];
    [self.view addSubview:self.showBtn];
    
    bottom -= (kButton_H + kPadding_Y);
    self.isReadyBtn = [self createButtonWithTitle:@"IsReady" action:@selector(isReadyAction:) frame:CGRectMake(kPadding_X, bottom - kButton_H, UMTD_SCREEN_W - 2*kPadding_X, kButton_H)];
    [self.view addSubview:self.isReadyBtn];
    
    bottom -= (kButton_H + kPadding_Y);
    self.loadBtn = [self createButtonWithTitle:@"LoadAd" action:@selector(loadAdAction:) frame:CGRectMake(kPadding_X, bottom - kButton_H, UMTD_SCREEN_W - 2*kPadding_X, kButton_H)];
    [self.view addSubview:self.loadBtn];
    
    bottom -= (kButton_H + kPadding_Y);
    self.bottom = bottom;
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)selector frame:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:[UIColor systemGreenColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    btn.frame = frame;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor systemGreenColor].CGColor;
    [self.view addSubview:btn];
    return btn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
