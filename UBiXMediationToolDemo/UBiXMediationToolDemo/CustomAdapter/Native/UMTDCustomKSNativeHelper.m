//
//  UMTDCustomKSNativeHelper.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/12/17.
//

#import "UMTDCustomKSNativeHelper.h"

@interface UMTDCustomKSNativeHelper () {
    UILabel *_titleLb;
    UILabel *_descLb;
    UIImageView *_imageView;
    KSVideoAdView *_videoView;
    NSArray<UMTImage *> *_imageList;
}
@property (nonatomic,strong) KSNativeAd *ksNativeAd;

@end

@implementation UMTDCustomKSNativeHelper

- (BOOL)hasSupportActionBtn {
    return YES;
}

- (instancetype)initWithAdData:(KSNativeAd *)data {
    self = [super init];
    if (self) {
        _ksNativeAd = data;
        if (data.materialType == KSAdMaterialTypeVideo) {
            _relatedView = [KSNativeAdRelatedView new];
        }
    }
    return self;
}
#pragma mark - UMTMediationNativeAdViewCreator

/// 广告标题视图
- (UILabel *)titleLabel {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLb.text = _ksNativeAd.data.adDescription;
        [_titleLb sizeToFit];
    }
    return _titleLb;
}

/// 广告描述信息视图
- (UILabel *)descLabel {
    if (!_descLb) {
        _descLb = [[UILabel alloc] initWithFrame:CGRectZero];
//        _descLb.text = ;
    }
    return _descLb;
}

/// 广告图标视图
- (UIImageView *)iconImageView {
    return nil;
}

/// 广告图片视图
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    }
    return _imageView;
}

/// 广告事件按钮
- (UIButton *)callToActionBtn {
    return nil;
}

/// 广告商视图
- (UIView *)advertiserView {
    return nil;
}

/// 不喜欢广告按钮
- (UIButton *)dislikeBtn {
    return nil;
}

/// 视频视图
- (UIView *)mediaView {
    if (_ksNativeAd.data.materialType == KSAdMaterialTypeVideo) {
        if (!_videoView) {
           
            _videoView = _relatedView.videoAdView;
        }
        return _videoView;
    }
    return nil;
}

/// 广告图标视图
- (UIView *)adLogoView {
    return nil;
}

#pragma mark - UMTMediationNativeAdData,

/// 广告支持的跳转类型
- (UMTMediationNativeAdCallToType) callToType {
    KSAdInteractionType type = _ksNativeAd.data.interactionType;
    switch (type) {
        case KSAdInteractionType_Unknown:   //unknown type
            return UMTMediationNativeAdCallToTypeUnknown;
            break;
        case KSAdInteractionType_Web:       //open webpage in app
            return UMTMediationNativeAdCallToTypePage;
            break;
        case KSAdInteractionType_AppStore:  //open appstore
            return UMTMediationNativeAdCallToTypeDownload;
            break;
        case KSAdInteractionType_DeepLink:  //open deeplink
            return UMTMediationNativeAdCallToTypeDeepLink;
            break;
        default:
            break;
    }
    return 0;
}

/// 物料图片集，如果图片有宽高，请尽量配置width和height
- (NSArray<UMTImage *> *)imageList {
    if (!_imageList) {
        NSMutableArray *imageList = nil;
        for (KSAdImage *ksImg in _ksNativeAd.data.imageArray) {
            if (!imageList) {
                imageList = [NSMutableArray array];
            }
            
            UMTImage *img = [[UMTImage alloc] init];
            img.image = ksImg.image;
            img.imageURLStr = ksImg.imageURL;
            img.width = ksImg.width;
            img.height = ksImg.height;
            
            [imageList addObject:img];
            
        }
        _imageList = imageList;
    }
    return _imageList;
}

/// app类型广告的广告商app图标，如果图标有宽高，请尽量配置width和height
- (UMTImage *)icon {
    KSAdImage *ksImg = _ksNativeAd.data.appIconImage;
    if (ksImg) {
        UMTImage *img = [[UMTImage alloc] init];
        img.imageURLStr = ksImg.imageURL;
        img.image = ksImg.image;
        img.width = ksImg.width;
        img.height = ksImg.height;
        
        return img;
    }
    return nil;
}

/// 广告adn的logo，如果logo有宽高，请尽量配置width和height
- (UMTImage *)adLogo {
    return nil;
}

/// 广告标题
- (NSString *)adTitle {
    return _ksNativeAd.data.adDescription;
}
    

/// 广告详情描述
- (NSString *)adDescription {
    return nil;
}

/// 应用来源、市场，例如'App Store'
- (NSString *)source {
    return nil;
}

/// 按钮文案，例如'下载/安装'
- (NSString *)buttonText {
    return _ksNativeAd.data.actionDescription;
}

/// 图片/视频模式
- (UMTMediationNativeAdMode) imageMode {
    switch (_ksNativeAd.data.materialType) {
        case KSAdMaterialTypeVideo:
            return UMTMediationNativeAdModePortraitVideo;
            break;
        case KSAdMaterialTypeSingle:
            return UMTMediationNativeAdModeLargeImage;
            break;
        case KSAdMaterialTypeAtlas:
            return UMTMediationNativeAdModeSmallImage;
            break;
            
        default:
            return UMTMediationNativeAdModeUnknown;
            break;
    }
}

/// app评分，区间为1-5，如果没有值返回-1
- (NSInteger) score {
    if (_ksNativeAd.data.appScore) {
        NSInteger score = _ksNativeAd.data.appScore;
        return score;
    }
    return -1;
    
}

/// 评论数量，如果没有值返回-1
- (NSInteger)commentNum {
    return -1;
}

/// 广告安装包体大小，单位KB，如果没有值返回-1
- (NSInteger)appSize {
    return -1;
}

/// 视频时长，单位秒，如果没有值返回0
- (NSInteger)videoDuration {
    if (_ksNativeAd.data.materialType == KSAdMaterialTypeVideo) {
        NSInteger dur = _ksNativeAd.data.videoDuration/1000.f;
        return dur ?: 0;
    }
    return 0;
}

/// 视频纵横比(width/height)，如果没有值或者异常返回0
- (CGFloat)videoAspectRatio {
    
    return 0;
}

/// 媒体扩展数据
- (NSDictionary *)mediaExt {
    return nil;
}

/// app购买价格，例如'免费'，没有则为nil
- (NSString *)appPrice {
    return nil;
}

/// 广告商标识，广告商的名称或者链接
- (NSString *)advertiser {
    return _ksNativeAd.data.adSource;
}

/// 品牌名称，若广告返回中无品牌名称则为空
- (NSString *)brandName {
    return nil;
}

/// ADN提供的不喜欢广告的原因，可能为空
- (NSArray<UMTDislikeReason *> *)dislikeReasons {
    return nil;
}

/// ADN提供的视频类型广告的资源路径，部分ADN需要申请白名单，可能为空
- (NSString *)videoUrl {
    return _ksNativeAd.data.videoUrl;
}

/// be allowed to play video ad via custome player, contact BD to add to allow list.
- (BOOL)allowCustomVideoPlayer {
    return NO;
}

/// video resolution width
- (NSInteger) videoResolutionWidth {
    return 0;
}

/// video resolution height
- (NSInteger) videoResolutionHeight {
    return 0;
}

/// adx name, if it exists, it is recommended to display this text
- (NSString *)ADXName {
    return @"";
}

@end
