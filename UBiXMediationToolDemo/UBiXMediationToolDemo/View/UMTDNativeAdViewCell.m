//
//  UMTDNativeAdViewCell.m
//  UBiXMediationToolDemo
//
//  Created by guoqiang on 2024/8/28.
//

#import "UMTDNativeAdViewCell.h"

@interface UMTDNativeAdViewCell ()

@property (nonatomic, strong) UMTDNativeCellModel *model;

@end

@implementation UMTDNativeAdViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellModel:(UMTDNativeCellModel *)model {
    _model = model;
    UIView *v = [self.contentView viewWithTag:1000];
    if (v) {
        [v removeFromSuperview];
        v = nil;
    }
    if ([model isKindOfClass:[UMTDNativeCellModel class]]) {
        if (model.adView) {
            model.adView.tag = 1000;
            [self.contentView addSubview:model.adView];
        }
    }
    
    if (model.isNativeVideo) {
        CGFloat x = 0.f;
        CGFloat w = 60.f;
        UILabel *actLb = [self labelWithFrame:CGRectMake(x, 130, w, 40) text:@"播放" selector:@selector(videoActionGes:)];
        actLb.tag = 200;
       
        x += (w+10);
        
        UILabel *pauseActLb = [self labelWithFrame:CGRectMake(x, 130, w, 40) text:@"暂停" selector:@selector(videoActionGes:)];
        pauseActLb.tag = 300;
        
        x += (w+10);
        
        UILabel *resumeActLb = [self labelWithFrame:CGRectMake(x, 130, w, 40) text:@"恢复" selector:@selector(videoActionGes:)];
        resumeActLb.tag = 400;
       
        x += (w+10);
        
        UILabel *stopActLb = [self labelWithFrame:CGRectMake(x, 130, w, 40) text:@"停止" selector:@selector(videoActionGes:)];
        stopActLb.tag = 500;
        
        x += (w+10);
        UILabel *muteActLb = [self labelWithFrame:CGRectMake(x, 130, w, 40) text:@"静音" selector:@selector(videoMuteActionGes:)];
        muteActLb.tag = 100;
    }
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)txt selector:(SEL)sel {
    UILabel *actLb = [[UILabel alloc] initWithFrame:frame];
    actLb.textColor = [UIColor greenColor];
    actLb.layer.borderWidth = 1;
    actLb.layer.borderColor = [UIColor systemGreenColor].CGColor;
    actLb.userInteractionEnabled = YES;
    [actLb setText:txt];
    [actLb setTextAlignment:NSTextAlignmentCenter];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    [actLb addGestureRecognizer:tapGes];
    [self.contentView addSubview:actLb];
    
    return actLb;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *v = [self.contentView viewWithTag:1000];
    if (v) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x
                                , frame.origin.y
                                , v.frame.size.width, v.frame.size.height);
    }
}

- (void)videoActionGes:(UIGestureRecognizer *)ges {
    if (ges.view.tag == 200) {
        [self.model updateVideoAction:UMTDVideoAction_PlayStart];
    } else if (ges.view.tag == 300) {
        [self.model updateVideoAction:UMTDVideoAction_PlayPause];
    } else if (ges.view.tag == 400) {
        [self.model updateVideoAction:UMTDVideoAction_PlayResume];
    } else if (ges.view.tag == 500) {
        [self.model updateVideoAction:UMTDVideoAction_PlayStop];
    }
}

- (void)videoMuteActionGes:(UIGestureRecognizer *)ges {
    if (ges.view.tag == 100) {
        [self.model setVideoMute];
    }
}

@end
