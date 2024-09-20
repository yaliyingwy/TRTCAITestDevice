//
//  CameraAndMicrophoneDetectView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import "CameraAndMicrophoneDetectView.h"


#import "Masonry/Masonry.h"

@interface CameraAndMicrophoneDetectView()


@end

@implementation CameraAndMicrophoneDetectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setupGuideView {
    _guideView = [CameraAndMicrophoneGuideView new];
    [self addSubview:_guideView];
    
    
    [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_centerY).offset(119);
    }];
}

- (void)setupResultView {
    _resultView = [CameraAndMicrophoneResultView new];
    [self addSubview:_resultView];
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_centerY).offset(105);
    }];
}

@end
