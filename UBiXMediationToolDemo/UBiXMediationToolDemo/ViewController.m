//
//  ViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/7/3.
//

#import "ViewController.h"
#import <UBiddingAdSDK/UMTAdSDKManager.h>
#import "UMTDSlotIdDefines.h"
#import "UMTDAdBaseViewController.h"
#import "UMTDAuthViewController.h"
#import "AppDelegate.h"
//#import <UBiMAXDebuggerUI/UMTDebuggerUIManager.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UMTDAuthViewController *authViewController;
@property (nonatomic, assign) BOOL isAuthed;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataSources = @[
        @{
            @"icon": @"index_splash",
            @"title": @"开屏",
            @"VC": @"UMTDSplashViewController",
            @"slotId": SplashSlotID
        },
        @{
            @"icon": @"index_feed",
            @"title": @"信息流",
            @"VC": @"UMTDNativeViewController",
            @"slotId": FeedNativeSlotID
        },
        @{
            @"icon": @"index_rewardedvideo",
            @"title": @"激励视频",
            @"VC": @"UMTDRewardedVideoViewController",
            @"slotId": RewardSlotID
        },
        @{
            @"icon": @"index_splash",
            @"title": @"插屏",
            @"VC": @"UMTDInterstitialViewController",
            @"slotId": InterstitialSlotID
        },
        @{
            @"icon": @"index_banner",
            @"title": @"横幅",
            @"VC": @"UMTDBannerViewController",
            @"slotId": BannerSlotID
        },
        @{
            @"icon": @"index_ad_setting",
            @"title": @"广告设置",
            @"VC": @"UMTDBaseViewController",
            @"slotId": @""
        },
        @{
            @"icon": @"index_setting",
            @"title": @"系统设置",
            @"VC": @"UMTDBaseViewController",
            @"slotId": @""
        },
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isAuthed = [[defaults objectForKey:UMTDemoAuthorized] boolValue];
    
    if (self.isAuthed) {
        [self setupAdEntry];
    } else {
        
        UMTDAuthViewController *authVC = [[UMTDAuthViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        [authVC setAgreeBlock:^{
            __weak typeof(weakSelf) strongSelf = weakSelf;
            
            [authVC removeFromParentViewController];
            [authVC.view removeFromSuperview];
            
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            if ([appDelegate respondsToSelector:@selector(setupUMTAdSDK)] ) {
                [appDelegate performSelector:@selector(setupUMTAdSDK)];
            }
            
            [self setupAdEntry];
        }];
        
        [self addChildViewController:authVC];
        [self.view addSubview:authVC.view];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 测试工具展示入口
//    [[UMTDebuggerUIManager sharedManager] showDebugEntranceUI];
    // 自定义跳转测试工具页
    //[[UMTDebuggerUIManager sharedManager] customDebugEntrance];
}

- (void)setupAdEntry {
    self.title = [NSString stringWithFormat:@"UBiddingAdSDK v%@", [UMTAdSDKManager SDKVersion]];
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UMTDemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSDictionary *dic = [self.dataSources objectAtIndex:indexPath.row];
        cell.textLabel.text = dic[@"title"];
        cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [self.dataSources objectAtIndex:indexPath.row];
    NSString *className = dic[@"VC"];
    Class cls = NSClassFromString(className);
    if (cls) {
        UIViewController *vc = [[cls alloc] init];
        vc.title = dic[@"title"];
        if ([vc isKindOfClass:[UMTDAdBaseViewController class]]) {
            UMTDAdBaseViewController *baseVC = (UMTDAdBaseViewController *)vc;
            baseVC.slotId = dic[@"slotId"];
            
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}


@end
