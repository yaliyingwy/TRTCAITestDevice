//
//  AIConversationView.m
//  Pods
//
//  Created by ywen on 2024/9/9.
//

#import "AIConversationView.h"
#import "Masonry.h"
#import "AssetsUtil.h"


@interface AIConversationView()

@property (nonatomic, strong) UILabel *aiNameLabel;
@property (nonatomic, strong) UIImageView *aiAvatarView;
@property (nonatomic, strong) UIView *lineView;



@end

@implementation AIConversationView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}


- (void) setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12;
    self.layer.shadowColor = [UIColor colorWithRed:126/255.0 green:147/255.0 blue:255/255.0 alpha:0.2500].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 20;
    
    
    _aiAvatarView = [UIImageView new];
    UIImage *image = [AssetsUtil imageNamed:@"Tigo"];
    _aiAvatarView.image = image;
    _aiAvatarView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_aiAvatarView];
    
    _aiNameLabel = [[UILabel alloc] init];
    _aiNameLabel.numberOfLines = 0;
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC" size: 18];
    if (!font) {
        font = [UIFont systemFontOfSize:18]; // Fallback to system font if custom font fails
    }

    UIColor *color = [UIColor colorWithRed:58/255.0 green:60/255.0 blue:83/255.0 alpha:1];

    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: color,
        NSStrokeWidthAttributeName: @-5,
        NSStrokeColorAttributeName: color
    };

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Tigo" attributes:attributes];
    _aiNameLabel.attributedText = string;
    _aiNameLabel.textAlignment = NSTextAlignmentLeft;
    _aiNameLabel.alpha = 1.0;
    [self addSubview:_aiNameLabel];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:234/255.0 alpha:1];
    [self addSubview:_lineView];
    
    _chatView = [AIChatList new];
    [self addSubview:_chatView];

}

- (void) setupConstraints  {
    [_aiAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.mas_top).offset(15);
         make.left.equalTo(self.mas_left).offset(15);
         make.width.mas_equalTo(65); // Example size, adjust as needed
         make.height.mas_equalTo(56);
     }];
    
    [_aiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_aiAvatarView.mas_right).offset(15);
        make.centerY.equalTo(_aiAvatarView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).offset(86);
            make.height.equalTo(@1);
    }];
    
    [_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(87);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end
