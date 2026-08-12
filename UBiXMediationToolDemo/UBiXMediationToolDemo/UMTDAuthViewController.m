#import "UMTDAuthViewController.h"
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
#import <CoreTelephony/CTCellularData.h>

#define ScreenWidth            ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight           ([UIScreen mainScreen].bounds.size.height)
#define kIsLandscape  UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
#define kBtnWidth            (ScreenWidth - 97) / 2.0
#define kPadding 80
#define kViewHeight            ScreenHeight - 80 * 2.0

NSString * const UMTDemoPrivacyUrl = @"https://ubixai.com/ubix_sdk_ubidding_privacy.html";

NSString * const UMTDemoAuthorized = @"UMTDemoAuthorized";


static short UMTDHexCharToShort(char a) {
    if (a >= '0' && a <= '9') {
        return a - '0';
    } else if( a>='a' && a<='f') {
        return a - 'a' + 10;
    } else if( a>= 'A' && a<='F') {
        return a - 'A' + 10;
    } else {
        return 0;
    }
}

@interface UMTDUITools ()

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
                   corners:(UIRectCorner)corners
              cornerRadius:(CGFloat)radius;

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
              cornerRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *_Nullable)borderColor;

@end

@implementation UMTDUITools

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString;
    if ([hexString hasPrefix:@"#"]) {
        colorString = [hexString substringFromIndex:1];
    } else {
        colorString = hexString;
    }
    
    CGFloat r,g,b,a;
    
    switch (colorString.length) {
        case 3:{
            r = UMTDHexCharToShort([colorString characterAtIndex:0]) / (float)0xF;
            g = UMTDHexCharToShort([colorString characterAtIndex:1]) / (float)0xF;
            b = UMTDHexCharToShort([colorString characterAtIndex:2]) / (float)0xF;
            a = 1.0;
        }
            break;
        case 4:{
            r = UMTDHexCharToShort([colorString characterAtIndex:0]) / (float)0xF;
            g = UMTDHexCharToShort([colorString characterAtIndex:1]) / (float)0xF;
            b = UMTDHexCharToShort([colorString characterAtIndex:2]) / (float)0xF;
            a = UMTDHexCharToShort([colorString characterAtIndex:3]) / (float)0xF;
        }
            break;
        case 6:{
            r = (UMTDHexCharToShort([colorString characterAtIndex:0])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:1])) / (float)0xFF;
            g = (UMTDHexCharToShort([colorString characterAtIndex:2])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:3])) / (float)0xFF;
            b = (UMTDHexCharToShort([colorString characterAtIndex:4])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:5])) / (float)0xFF;
            a = 1.0;
        }
            break;
        case 8:{
            r = (UMTDHexCharToShort([colorString characterAtIndex:0])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:1])) / (float)0xFF;
            g = (UMTDHexCharToShort([colorString characterAtIndex:2])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:3])) / (float)0xFF;
            b = (UMTDHexCharToShort([colorString characterAtIndex:4])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:5])) / (float)0xFF;
            a = (UMTDHexCharToShort([colorString characterAtIndex:6])*0x10 + UMTDHexCharToShort([colorString characterAtIndex:7])) / (float)0xFF;
        }
            break;
        default:
            return nil;
            break;
    }
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
                   corners:(UIRectCorner)corners
              cornerRadius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGRect rect = {.origin = CGPointZero, .size = size};
    
    UIBezierPath *path;
    if (radius > 0) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    } else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    
    if (color) {
        [color setFill];
        [path fill];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
              cornerRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *_Nullable)borderColor {
    return [self imageWithSize:size
                         color:color
                  cornerRadius:radius
                   borderWidth:borderWidth
                   borderColor:borderColor
              innerBorderWidth:0
              innerBorderColor:nil];
}

+ (UIImage *)imageWithSize:(CGSize)size
                     color:(UIColor *)color
              cornerRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
          innerBorderWidth:(CGFloat)innerBorderWidth
          innerBorderColor:(nullable UIColor *)innerBorderColor {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGRect rect = {.origin = CGPointZero, .size = size};
    rect = CGRectInset(rect, borderWidth/2.0, borderWidth/2.0);
    
    UIBezierPath *path;
    if (radius > 0) {
        CGFloat realRadius = radius-borderWidth/2.0;
        if (realRadius < 0) {
            realRadius = 0;
        }
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:realRadius];
    }
    else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    path.lineWidth = borderWidth;
    
    if (color) {
        [color setFill];
        [path fill];
    }
    
    if (borderColor) {
        [borderColor setStroke];
        [path stroke];
    }
    if (innerBorderWidth > 0) {
        rect = CGRectInset(rect, (borderWidth + innerBorderWidth)/2.0, (borderWidth + innerBorderWidth)/2.0);
        UIBezierPath *innerBorderPath;
        if (radius > 0) {
            CGFloat realInnerRadius = radius - borderWidth - innerBorderWidth/2.0;
            if (realInnerRadius < 0) {
                realInnerRadius = 0;
            }
            innerBorderPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:realInnerRadius];
        }
        else {
            innerBorderPath = [UIBezierPath bezierPathWithRect:rect];
        }
        innerBorderPath.lineWidth = innerBorderWidth;
        if (innerBorderColor) {
            [innerBorderColor setStroke];
            [innerBorderPath stroke];
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface UMTDAuthViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *disagreeBtn;
@property (nonatomic, strong) CTCellularData *cellularData;
@property (nonatomic, assign) BOOL hasTriedReloadAfterPermission;
@property (nonatomic, strong) UIView *errorView;        // 错误提示容器
@property (nonatomic, strong) UILabel *errorLabel;      // 错误信息标签
@property (nonatomic, strong) UIButton *retryButton;    // 重试按钮

@end

@implementation UMTDAuthViewController

- (void)dealloc{
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    self.cellularData = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.hasTriedReloadAfterPermission = NO;
    
//    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.view addSubview:self.tipView];
   
    [self.tipView addSubview:self.tipLabel];
    [self.tipView addSubview:self.closeBtn];
    
    [self.webView addSubview:self.progressView];
    [self.tipView addSubview:self.webView];
    
    [self.tipView addSubview:self.agreeBtn];
    [self.tipView addSubview:self.disagreeBtn];
    
    // 添加错误视图到webView上方
    [self.tipView addSubview:self.errorView];
    [self.errorView addSubview:self.errorLabel];
    [self.errorView addSubview:self.retryButton];
    
    
    [self layoutSubView];
    
    [self setupCellularDataMonitor];
    
    NSURL *url = [NSURL URLWithString:UMTDemoPrivacyUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    // 初始隐藏错误视图
    self.errorView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.webView loadHTMLString:@"" baseURL:nil]; // 退出时清除webiew内容
    
}

- (void)layoutSubView {
    self.tipView.center = self.view.center;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipView).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.tipView).offset(-8);
        make.width.equalTo(@20);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.tipView).offset(40);
        make.right.equalTo(self.tipView).offset(-40);
        make.height.equalTo(@24);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView);
        make.right.equalTo(self.tipView);
        make.bottom.equalTo(self.agreeBtn.mas_top).offset(-10);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
    }];
    
    // 2. 布局errorView（依赖webView）
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView); // 与webView完全重合
    }];
    
    // 3. 布局retryButton（依赖errorView）
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.errorView);
        make.centerY.equalTo(self.errorView).offset(20); // 垂直居中偏下20
        make.width.equalTo(@120);
        make.height.equalTo(@44);
    }];
    
    // 4. 布局errorLabel（依赖errorView和retryButton）
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.errorView);
        make.bottom.equalTo(self.retryButton.mas_top).offset(-20); // 重试按钮上方20
        make.left.equalTo(self.errorView).offset(20);
        make.right.equalTo(self.errorView).offset(-20); // 左右留边距，避免文字溢出
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.webView);
        make.height.equalTo(@2);
        make.top.equalTo(self.webView.mas_top);
    }];
    
    CGFloat btnWidth = kBtnWidth;
    [self.disagreeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView).offset(30);
        make.width.mas_equalTo(btnWidth);
        make.height.equalTo(@48);
        make.bottom.equalTo(self.tipView).offset(-30);
    }];

    [self.agreeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipView).offset(-30);
        make.width.mas_equalTo(btnWidth);
        make.height.equalTo(@48);
        make.bottom.equalTo(self.tipView).offset(-30);
    }];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Actions
- (void)agreeAction {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(YES) forKey:UMTDemoAuthorized];
    [defaults synchronize];
    
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}

- (void)disagreeAction {
    // 退出app
    exit(0);
}

// 重试加载网页
- (void)retryLoadWebPage {
    // 隐藏错误视图
    self.errorView.hidden = YES;
    // 重新加载页面
    NSURL *url = [NSURL URLWithString:UMTDemoPrivacyUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - KVO
//kvo 监听进度
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
    }
    return nil;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    
    // 显示错误视图和重试按钮
    self.errorView.hidden = NO;
    
    // 根据错误类型显示不同信息
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
                self.errorLabel.text = @"网络连接失败，请检查网络后重试";
                break;
            case NSURLErrorCannotConnectToHost:
                self.errorLabel.text = @"无法连接到服务器，请重试";
                break;
            case NSURLErrorTimedOut:
                self.errorLabel.text = @"连接超时，请重试";
                break;
            default:
                self.errorLabel.text = [NSString stringWithFormat:@"加载失败：%@", error.localizedDescription];
                break;
        }
    } else {
        self.errorLabel.text = [NSString stringWithFormat:@"加载失败：%@", error.localizedDescription];
    }
    
    // 网络错误且尚未在权限变更后尝试重新加载时，标记为需要重试
    if ((error.code == NSURLErrorNotConnectedToInternet ||
         error.code == NSURLErrorCannotConnectToHost) &&
        !self.hasTriedReloadAfterPermission) {
        
        CTCellularDataRestrictedState state = self.cellularData.restrictedState;
        if (state == kCTCellularDataRestrictedStateUnknown) {
            NSLog(@"等待用户确认网络权限...");
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}

// 页面加载成功时隐藏错误视图
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.errorView.hidden = YES;
}

#pragma mark - 蜂窝数据权限监测
- (void)setupCellularDataMonitor {
    self.cellularData = [[CTCellularData alloc] init];
    __weak typeof(self) weakSelf = self;
    
    self.cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleNetworkPermissionChange:state];
        });
    };
}

- (void)handleNetworkPermissionChange:(CTCellularDataRestrictedState)state {
    if (state != kCTCellularDataRestrictedStateUnknown && !self.hasTriedReloadAfterPermission) {
        self.hasTriedReloadAfterPermission = YES;
        [self retryLoadWebPage]; // 调用重试方法
    }
}

#pragma mark - Getter
- (UIView *)tipView {
    if (!_tipView) {
        CGFloat screenWidth  = kIsLandscape ? ScreenHeight : ScreenWidth;
        CGRect frame = CGRectMake(0,0, screenWidth - 20, kViewHeight);
        _tipView = [[UIView alloc] initWithFrame:frame];
        _tipView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tipView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(16.0, 16.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _tipView.bounds;
        maskLayer.path = maskPath.CGPath;
        _tipView.layer.mask = maskLayer;
    }
    return _tipView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"隐私协议提示";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UMTDUITools colorWithHexString:@"#000000FF"];
        _tipLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    }
    return _tipLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn addTarget:self action:@selector(disagreeAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"ubix_close"];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        _closeBtn.contentMode = UIViewContentModeCenter;
    }
    return _closeBtn;
}

- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [UIButton new];
        [_agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_agreeBtn setTitle:@"同意并继续" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UMTDUITools colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        CGFloat btnWidth = kBtnWidth;
        UIImage *normalImage = [UMTDUITools imageWithSize:CGSizeMake(btnWidth, 48) color:[UMTDUITools colorWithHexString:@"#64A6F9"] corners:UIRectCornerAllCorners cornerRadius:10.0];
        UIImage *highlightImage = [UMTDUITools  imageWithSize:CGSizeMake(btnWidth, 48) color:[UMTDUITools colorWithHexString:@"#64A6F97F"] corners:UIRectCornerAllCorners cornerRadius:10.0];
        [_agreeBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    return _agreeBtn;
}

- (UIButton *)disagreeBtn {
    if (!_disagreeBtn) {
        _disagreeBtn = [UIButton new];
        [_disagreeBtn addTarget:self action:@selector(disagreeAction) forControlEvents:UIControlEventTouchUpInside];
        [_disagreeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_disagreeBtn setTitle:@"不同意并退出" forState:UIControlStateNormal];
        [_disagreeBtn setTitleColor:[UMTDUITools colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [_disagreeBtn setTitleColor:[UMTDUITools colorWithHexString:@"#2222227F"] forState:UIControlStateHighlighted];
        CGFloat btnWidth = kBtnWidth;
        UIImage *normalImage = [UMTDUITools  imageWithSize:CGSizeMake(btnWidth, 48)
                                                     color:[UMTDUITools colorWithHexString:@"#FFFFFF"]
                                              cornerRadius:10.0
                                               borderWidth:1.0
                                               borderColor:[UMTDUITools colorWithHexString:@"#C6C6C6"]];
        UIImage *highlightImage = [UMTDUITools imageWithSize:CGSizeMake(btnWidth, 48)
                                                       color:[UMTDUITools colorWithHexString:@"#FFFFFF"]
                                                cornerRadius:10.0
                                                 borderWidth:1.0
                                                 borderColor:[UMTDUITools colorWithHexString:@"#C6C6C67F"]];
        [_disagreeBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_disagreeBtn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    return _disagreeBtn;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = self.view.backgroundColor;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        // 添加监测网页加载进度的观察者
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [UIProgressView new];
        _progressView.tintColor = [UMTDUITools colorWithHexString:@"#64A6F9"];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

// 错误提示容器视图
- (UIView *)errorView {
    if (!_errorView) {
        _errorView = [[UIView alloc] init];
        _errorView.backgroundColor = [UIColor whiteColor]; // 与webView背景一致
        _errorView.userInteractionEnabled = YES; // 允许交互
    }
    return _errorView;
}

// 错误信息标签
- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.textColor = [UIColor darkGrayColor];
        _errorLabel.font = [UIFont systemFontOfSize:14];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.numberOfLines = 0; // 支持多行
    }
    return _errorLabel;
}

// 重试按钮
- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton new];
        [_retryButton addTarget:self action:@selector(retryLoadWebPage) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_retryButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        
        // 设置按钮样式，与"同意"按钮保持一致
        UIImage *normalImage = [UMTDUITools imageWithSize:CGSizeMake(120, 44)
                                                   color:[UMTDUITools colorWithHexString:@"#64A6F9"]
                                                 corners:UIRectCornerAllCorners
                                            cornerRadius:8.0];
        UIImage *highlightImage = [UMTDUITools imageWithSize:CGSizeMake(120, 44)
                                                     color:[UMTDUITools colorWithHexString:@"#64A6F97F"]
                                                   corners:UIRectCornerAllCorners
                                              cornerRadius:8.0];
        
        [_retryButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [_retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _retryButton;
}

@end
