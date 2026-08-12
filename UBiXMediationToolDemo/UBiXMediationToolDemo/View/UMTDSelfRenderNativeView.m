//
//  UMTDSelfRenderNativeView.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/9/2.
//

#import "UMTDSelfRenderNativeView.h"
#import "UMTDNativeCellModel.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import <UBiddingAdSDK/UBiddingAdSDK-umbrella.h>

@interface UMTDMeidaContainerView ()

@end

@implementation UMTDMeidaContainerView


@end



@interface UMTDSelfRenderNativeView ()
{
    UILabel *_titleLb;
    UILabel *_descLb;
    UIImageView *_adImageV;
}

@property (nonatomic, strong) UMTDMeidaContainerView *mediaContainerView;

@property (nonatomic, strong) UILabel *adnLb;

@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation UMTDSelfRenderNativeView

- (id)initWithNativeOffer:(UMTNativeOffer *)offer {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _offer = offer;
        [self setupViewWithOffer:offer];
    }
    return self;
}

- (void)setupViewWithOffer:(UMTNativeOffer *)offer {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat x = 0.f;
    UMTDMeidaContainerView *container = [[UMTDMeidaContainerView alloc] initWithFrame:CGRectMake(x, 20, 160, 100)];
    self.mediaContainerView = container;
    [self addSubview:self.mediaContainerView];
    
    x += self.mediaContainerView.frame.size.width;
    x += 10;
    
    CGFloat y = 10;
    UILabel *titleLb = [self titleLbWithOffer:offer];
    if (titleLb) {
        [titleLb setText:offer.canvasView.native.adData.adTitle ?: @"标题"];
        CGFloat h = 30;
        titleLb.frame = CGRectMake(x, 0, width-x-30, h);
        [self addSubview:titleLb];
        y += h;
    }
    y += 10;
    UILabel *descLb = [self descLbWithOffer:offer];
    if (descLb) {
        [descLb setText:offer.canvasView.native.adData.adDescription ?: @"广告描述"];
        CGFloat h = 30;
        descLb.frame = CGRectMake(x, y, width-x-30, h);
        [self addSubview:descLb];
        y += h;
    }
    
    UMTAdnInfo *adnInfo = offer.nativeAd.winnerAdnInfo;
    
    if (adnInfo) {
        NSString *adnTxt = [self textOfAdnInfo:adnInfo];
        
        y += 20;
        UILabel *adnInfoLb = self.adnLb;
        if (adnInfoLb) {
            [adnInfoLb setText:adnTxt];
            CGFloat h = 20;
            adnInfoLb.frame = CGRectMake(x, y, width-x-30, h);
            [self addSubview:adnInfoLb];
            y += h;
        }
    }
    
    
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 30, 0, 30, 30)];
    UIImage *img = [UIImage imageNamed:@"ubix_close"];
    [_closeBtn setBackgroundImage:img forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:img forState:UIControlStateHighlighted];
    [self addSubview:_closeBtn];
    
    CGFloat h = self.mediaContainerView.frame.size.height;
    CGFloat mediaW = self.mediaContainerView.frame.size.width;
    BOOL isVideo = offer.canvasView.native.isVideoAd;
    if (isVideo) {
        UIView *mediaV = offer.canvasView.mediaView;
        if (mediaV) {
            mediaV.frame = CGRectMake(0, 0, mediaW, h);
        }
        [self.mediaContainerView addSubview:mediaV];
    } else {
        UIImageView *adImgV = [self adImageViewWithOffer:offer];
        
        if (adImgV) {
            
            UMTImage *img = offer.canvasView.native.adData.imageList.firstObject;
    //        h = img.height ?: h;
            adImgV.frame = CGRectMake(0, 0, mediaW, h);
            if (img.imageURL) {
                [adImgV sd_setImageWithURL:img.imageURL];
            } else if (img.imageURLStr) {
                [adImgV sd_setImageWithURL:[NSURL URLWithString:img.imageURLStr]];
            } else if (img.image) {
                [adImgV setImage:img.image];
            }
            
            [self.mediaContainerView addSubview:adImgV];
        }
        
    }
    
    UIButton *btn = offer.canvasView.callToActionBtn ?: [UIButton buttonWithType:UIButtonTypeSystem];
    if (btn) {
        self.actionBtn = btn;
        btn.frame = CGRectMake(width - 100, h, 100, 30);
        NSString *txt = offer.canvasView.native.adData.buttonText;
        [btn setTitle:txt forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    y += h;
    self.frame = CGRectMake(0, 0, width, y);
}

- (void)registerAdView {
    NSMutableArray *arr = [NSMutableArray array];
    if (_adImageV) {
        [arr addObject:_adImageV];
    }
    
    [arr addObject:_titleLb];
    
    [arr addObject:_descLb];
    
    if (self.actionBtn) {
        [arr addObject:self.actionBtn];
    }
    
    NSMutableArray *closeArr = [NSMutableArray array];
    if (_closeBtn) {
        [closeArr addObject:_closeBtn];
    }
    
    [self.offer registerContainer:self.offer.canvasView withClickableViews:arr closableViews:closeArr];
}

#pragma mark - UMTMediationNativeSelfRenderViewCreator

- (UIView *)mediaView {
    return self.mediaContainerView;
}

#pragma mark - Private
- (NSString *)textOfAdnInfo:(UMTAdnInfo *)adnInfo {
    
    NSString *text = [NSString stringWithFormat:@"%@-%@", adnInfo.adnName ?: @"?", adnInfo.adnSlotId ?: @"?"];
    NSDictionary *extraDic = adnInfo.extraParams;
    NSString *platName = extraDic[UMTAdnExtraParam_PlatformName];
    if (platName) {
        text = [text stringByAppendingFormat:@"-%@", platName];
    }
    NSString *platSlotId = extraDic[UMTAdnExtraParam_PlatformSlotId];
    if (platSlotId) {
        text = [text stringByAppendingFormat:@"-%@", platSlotId];
    }
    return text;
}

#pragma mark - Getter

- (UILabel *)titleLbWithOffer:(UMTNativeOffer *)offer {
    if (!_titleLb) {
        UILabel *lb = offer.canvasView.titleLabel;
        if (!lb) {
            lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        }
        _titleLb = lb;
        
    }
    return _titleLb;
}

- (UILabel *)descLbWithOffer:(UMTNativeOffer *)offer {
    if (!_descLb) {
        UILabel *lb = offer.canvasView.descLabel;
        if (!lb) {
            lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        }
        _descLb = lb;
        
    }
    return _descLb;
}

- (UIImageView *)adImageViewWithOffer:(UMTNativeOffer *)offer {
    if (!_adImageV) {
        UIImageView *imgV = offer.canvasView.imageView;
        if (imgV) {
            _adImageV = imgV;
        }
    }
    return _adImageV;
}

- (UILabel *)adnLb {
    if (!_adnLb) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [lb setFont:[UIFont systemFontOfSize:10]];
        _adnLb = lb;
        
    }
    return _adnLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize mediaView;

@end
