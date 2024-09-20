//
//  AIDetectView.m
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/17.
//

#import "AIDetectView.h"

@implementation AIDetectView

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
        [self setupResultView];
        [self setupGuideView];
    }
    return self;
}

-(void)setupGuideView {
    
}

- (void)setupResultView {
    
}



@end
