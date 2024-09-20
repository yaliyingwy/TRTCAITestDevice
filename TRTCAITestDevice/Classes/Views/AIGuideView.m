//
//  AIGuideView.m
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import "AIGuideView.h"
#import "Masonry/Masonry.h"
#import "UIColor+Util.h"

@interface AIGuideView()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation AIGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
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
    
    [self setupHeaderView];
    [self setupContentView];
}

- (void)setupContentView {
    [self setupLeftView];
    [self setupGudeView];
}

- (void) setupHeaderView {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#3A3C53"];
    _titleLabel.text = @"Friendly reminder";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:234/255.0 alpha:1];
    [self addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(42);
        make.height.equalTo(@1);
    }];
}

- (void) setupLeftView {
    _aiImageView = [UIImageView new];
    [self addSubview:_aiImageView];
    [_aiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25.5);
        make.centerY.equalTo(self.mas_centerY).offset(42);
    }];
}

- (void)setupGudeView {
}

- (void)configureWithImage:(nonnull UIImage *)image {
    _aiImageView.image = image;
    [self setNeedsUpdateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [_aiImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(_aiImageView.image.size.width / _aiImageView.image.scale));
        make.height.equalTo(@(_aiImageView.image.size.height / _aiImageView.image.scale));
    }];
    [super updateConstraints];
}

@end
