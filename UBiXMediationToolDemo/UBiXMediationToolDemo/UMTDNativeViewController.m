//
//  UMTDNativeViewController.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/1.
//

#import "UMTDNativeViewController.h"
#import <UBiMAXNative/UBiMAXNative-umbrella.h>
#import <UBiMAXAdSDK/UMTAdSDK.h>
#import "UMTDLogger.h"
#import "UbixMDBulletScreenManager.h"
#import "Masonry/Masonry.h"
#import "UMTDSlotIdDefines.h"
#import "UMTDNativeAdViewCell.h"
#import "UMTDNativeCellModel.h"
#import "UbixMDBulletScreenManager.h"

#define UMTD_Screen_Width [UIScreen mainScreen].bounds.size.width
#define UMTD_Screen_Height [UIScreen mainScreen].bounds.size.height

@interface UMTDNativeViewController () <UMTNativeLoadDelegate, UMTNativeDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UMTNative *nativeAd;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *cellModelMap;

@property (nonatomic, strong) NSArray *slotIdS;
@property (nonatomic, strong) NSMutableArray *nativeAdModelList;
@property (nonatomic, strong) UISegmentedControl *seg;

@end

@implementation UMTDNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nativeAdModelList = [NSMutableArray array];
    
    _slotIdS = @[FeedNativeSlotID, FeedExpressSlotID];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, self.y+2, UMTD_Screen_Width, 40)];
    self.seg = seg;
    [seg insertSegmentWithTitle:@"模板" atIndex:0 animated:NO];
    [seg insertSegmentWithTitle:@"自渲染" atIndex:0 animated:NO];
    seg.selectedSegmentIndex = 0;
    seg.selectedSegmentTintColor = [UIColor whiteColor];
    [self.view addSubview:seg];
    [seg addTarget:self action:@selector(nativeRenderChanged:) forControlEvents:UIControlEventValueChanged];
    self.y += 42;
    
    self.isReadyBtn.hidden = YES;
    self.showBtn.hidden = YES;
    self.loadBtn.frame = self.showBtn.frame;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.y, UMTD_Screen_Width, self.loadBtn.frame.origin.y - self.y) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)nativeRenderChanged:(UISegmentedControl *)seg {
    NSInteger idx = seg.selectedSegmentIndex;
    NSString *slotId = _slotIdS[idx];
    self.slotIdText.text = slotId;
//    self.slotIdText.enabled = NO;
    
    [self.dataSource removeObjectsInArray:self.nativeAdModelList];
    [self.tableView reloadData];
    
    [self.nativeAdModelList removeAllObjects];
}


- (void)loadAdAction {
    UMTNative *nativeAd = [[UMTNative alloc] initWithSlotId:self.slotIdText.text];
    nativeAd.size = [UMTDNativeCellModel nativeAdSize];
    self.nativeAd = nativeAd;
    [[UMTAdManager sharedManager] loadNativeAd:nativeAd extra:@{kUMTRootViewController: self} delegate:self];
    
}

- (BOOL)isReadyAction {
    return NO;
}

- (void)showAdAction {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;
    if ([_slotIdS containsObject:text]) {
        self.seg.selectedSegmentIndex = [_slotIdS indexOfObject:text];
    } else {
        self.seg.enabled = NO;
    }
}

#pragma mark - UMTAdDelegate


- (void)umtNativeAd:(UMTNative *)native didLoadWithAds:(NSArray <UMTNativeOffer*> *)ads {
    UMTDLog(@"信息流加载成功，%s", __func__);
    uint64_t price = [native getEcpm];
    UMTAdnInfo *adnInfo = native.winnerAdnInfo;
    UMTDLog(@"加载成功，%s, price=%ld, adnName=%@, adnSlotId=%@", __func__, price, adnInfo.adnName, adnInfo.adnSlotId);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    for (UMTNativeOffer *offer in ads) {
        offer.rootViewController = self;
        offer.delegate = self;
        
        UMTDNativeCellModel *model = [[UMTDNativeCellModel alloc] initWithNativeOffer:offer];
        [self.cellModelMap setValue:model forKey:[NSString stringWithFormat:@"%lu", (unsigned long)offer.hash]];

        [self.dataSource insertObject:model atIndex:2];
        [_nativeAdModelList addObject:model];
    }
    
    [self.tableView reloadData];
}

- (void)umtNativeAd:(UMTNative *)native didLoadFailed:(UMTError *)error {
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s, error:%ld", __func__, error.code]];
    UMTDLog(@"信息流加载失败，%s， error=%@", __func__, error.localizedDescription);
}

- (void)umtNativeAd:(UMTNative *)native didAdViewRenderSucc:(UMTNativeOffer *)offer {
    UMTDLog(@"信息流渲染成功%s", __func__);
    [self.tableView reloadData];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtNativeAd:(UMTNative *)native didAdView:(UMTNativeOffer *)offer renderFailed:(UMTError *)error {
    UMTDLog(@"信息流渲染失败，%s， error=%@", __func__, error.localizedDescription);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s, error:%ld", __func__, error.code]];
}

- (void)umtNativeAd:(UMTNative *)native didShowSucc:(UMTNativeOffer *)offer {
    UMTDLog(@"信息流展示成功，%s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtNativeAd:(UMTNative *)native didShow:(UMTNativeOffer *)offer failed:(UMTError *)error {
    UMTDLog(@"信息流展示失败，%s， error=%@", __func__, error.localizedDescription);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s, error:%ld", __func__, error.code]];
}

- (void)umtNativeAd:(UMTNative *)native didClick:(UMTNativeOffer *)offer {
    UMTDLog(@"信息流click，%s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtNativeAd:(UMTNative *)native didClose:(UMTNativeOffer *)offer {
    UMTDLog(@"信息流关闭，%s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
    if (offer) {
        NSString *key = [NSString stringWithFormat:@"%lu", offer.hash];
        UMTDNativeCellModel *model = [self.cellModelMap objectForKey:key];
        if (model) {
            [self.dataSource removeObject:model];
            [self.cellModelMap removeObjectForKey:key];
            
            [self.tableView reloadData];
            [model destroy];
        }
        
        if (self.nativeAd) {
            self.nativeAd = nil;
        }
        
    }
   
}

- (void)umtNativeAd:(UMTNative *)native didDetailClose:(UMTNativeOffer *)offer {
    UMTDLog(@"信息流落地页关闭，%s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}

- (void)umtNativeAd:(UMTNative *)native offer:(UMTNativeOffer *)offer didChangedPlayStatus:(UMTVideoPlayerStatus)status {
    UMTDLog(@"信息流-播放状态变更，%s", __func__);
    [[UbixMDBulletScreenManager sharedInstance] showWithText:[NSString stringWithFormat:@"%s", __func__]];
}
- (void)umtNativeAd:(UMTNative *)native offer:(UMTNativeOffer *)offer didPlayFinishExtra:(NSDictionary *)extra failed:(UMTError *)error {
    UMTDLog(@"信息流-播放完成，%s， err= %@", __func__, error.localizedDescription);
    NSString *msg = [NSString stringWithFormat:@"%s%@", __func__, error ? [NSString stringWithFormat:@", err= %ld", error.code] : @""];
    [[UbixMDBulletScreenManager sharedInstance] showWithText:msg];
}

/// 信息流，视频播放进度, 仅支持 Gdt，UBiMAXAdx
///  @param time 播放进度，单位： ms
///  @param duration 视频时长，单位：ms
- (void)umtNativeAd:(UMTNative *)native offer:(UMTNativeOffer *)offer didChangedPlayTime:(CGFloat)time duration:(CGFloat)duration extra:(NSDictionary *)extra {
    UMTDLog(@"信息流-播放进度，%s， %f ms / %f ms", __func__, duration, time);
}
#pragma mark - Getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSInteger count = 20;
        for (int i=0; i<count; i++) {
            NSDictionary *dic = @{@"title": [NSString stringWithFormat: @"Feed-%d", i]};
            [_dataSource addObject:dic];
        }
    }
    
    return _dataSource;
}

- (NSMutableDictionary *)cellModelMap {
    if (!_cellModelMap) {
        _cellModelMap = [NSMutableDictionary dictionary];
    }
    return _cellModelMap;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    if (index >= self.dataSource.count) {
        return [UITableViewCell new];
    }
    UITableViewCell *resultCell = nil;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[UMTDNativeCellModel class]]) {
        UMTDNativeCellModel *cellModel = (UMTDNativeCellModel *)model;
        
        UMTDNativeAdViewCell *cell = [[UMTDNativeAdViewCell alloc] init];
        [cell refreshCellModel:cellModel];
        resultCell = cell;
    } else if ([model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)model;
        resultCell = [[UITableViewCell alloc] init];
        resultCell.textLabel.text = dic[@"title"];
    }
    if (resultCell == nil) {
        resultCell = [[UITableViewCell alloc] init];
        resultCell.textLabel.text = @"--";
    }
    return resultCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[UMTDNativeCellModel class]]) {
        UMTDNativeCellModel *cellModel = (UMTDNativeCellModel *)model;
        [cellModel registerAdView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[UMTDNativeCellModel class]]) {
        UMTDNativeCellModel *cellModel = (UMTDNativeCellModel *)model;
        
        CGFloat height = cellModel.adView.frame.size.height;
        return height ?: 200;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
