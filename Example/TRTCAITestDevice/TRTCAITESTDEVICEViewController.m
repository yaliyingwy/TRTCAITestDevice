//
//  TRTCAITESTDEVICEViewController.m
//  TRTCAITestDevice
//
//  Created by moonwen on 09/09/2024.
//  Copyright (c) 2024 moonwen. All rights reserved.
//

#import "TRTCAITESTDEVICEViewController.h"
#import "Masonry.h"
#import <TRTCAITestDevice-umbrella.h>

@interface TRTCAITESTDEVICEViewController ()

@end

@implementation TRTCAITESTDEVICEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create and configure buttons
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [firstButton setTitle:@"网络检测" forState:UIControlStateNormal];
    [firstButton addTarget:self action:@selector(goToFirstViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [secondButton setTitle:@"Second" forState:UIControlStateNormal];
    [secondButton addTarget:self action:@selector(goToSecondViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [thirdButton setTitle:@"Third" forState:UIControlStateNormal];
    [thirdButton addTarget:self action:@selector(goToThirdViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fourthButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [fourthButton setTitle:@"Fourth" forState:UIControlStateNormal];
    [fourthButton addTarget:self action:@selector(goToFouthViewController) forControlEvents:UIControlEventTouchUpInside];
    
    // Add buttons to the view
    [self.view addSubview:firstButton];
    [self.view addSubview:secondButton];
    [self.view addSubview:thirdButton];
    [self.view addSubview:fourthButton];
    
    // Set up constraints using Masonry
    [self setupButtonConstraintsWithButtons:@[firstButton, secondButton, thirdButton, fourthButton]];
}

- (void)setupButtonConstraintsWithButtons:(NSArray<UIButton *> *)buttons {
    // Assuming you want equal spacing between buttons and equal widths
    CGFloat buttonSpacing = 20.0; // Adjust the spacing as needed
    
    UIView *previousButton = nil;
    for (UIButton *button in buttons) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            if (previousButton) {
                make.top.equalTo(previousButton.mas_bottom).offset(buttonSpacing);
            } else {
                make.centerY.equalTo(self.view).multipliedBy(0.5); // Start from the middle and distribute buttons
            }
        }];
        previousButton = button;
    }
}

- (void)goToFirstViewController {
    AIDeviceTestController *netVC = [[AIDeviceTestController alloc] init];
    netVC.trtcParams = @{
        @"sdkAppId": @0,
        @"userId": @"",
        @"userSig": @"",
        @"roomId": @""
    };
    netVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:netVC animated:YES completion:nil];
}

- (void)goToSecondViewController {
}

- (void)goToThirdViewController {
}

- (void)goToFouthViewController {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
