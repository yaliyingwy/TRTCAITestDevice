//
//  AnimationView.h
//  TRTCAITestDevice
//
//  Created by ywen on 2024/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationView : UIView

-(void) configureWithJson:(NSString *) json audio:(NSString *) audio;

-(void) play;

@end

NS_ASSUME_NONNULL_END
