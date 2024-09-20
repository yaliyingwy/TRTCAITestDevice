//
//  NetworkDetectView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//
#import "NetworkDetectView.h"

#import "Masonry/Masonry.h"

@interface NetworkDetectView()


@end

@implementation NetworkDetectView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.status = Detecting;
    }
    return self;
}


-(void)setupGuideView {
    _networkGuideView = [NetworkGuideView new];
    [self addSubview:_networkGuideView];
    
    __weak typeof(self) weakSelf = self;
    _networkGuideView.nextHandler = ^{
        if (weakSelf.detectDelegate != nil) {
            [weakSelf.detectDelegate onDetectDone:DectectNetworkPage];
        }
    };
    
    _networkGuideView.retryHandler = ^{
        if (weakSelf.detectDelegate != nil) {
            [weakSelf.detectDelegate onDetectRetry:DectectNetworkPage];
        }
    };
    
    [_networkGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_centerY).offset(119);
    }];
}

- (void)setupResultView {
    _networkResultView = [NetworkResultView new];
    [self addSubview:_networkResultView];
    [_networkResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(107);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
}

- (void)setStatus:(NetworkDetectStatus)status {
    _status = status;
    _networkGuideView.status = status;
    _networkResultView.status = status;
}

@end
