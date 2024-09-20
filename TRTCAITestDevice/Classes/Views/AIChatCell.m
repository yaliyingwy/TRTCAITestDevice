//
//  AIChatCell.m
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import "AIChatCell.h"
#import <Masonry/Masonry.h>
#import "AssetsUtil.h"

@interface AIChatCell()

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIImageView *bubbleView;

@end

@implementation AIChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupBubble];
        [self setupMessageLabel];
    }
    return self;
}

- (void)setupBubble {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _bubbleView = [[UIImageView alloc] init];
    UIImage *bubbleImage = [AssetsUtil imageNamed:@"Bubble"];
    UIEdgeInsets insets = UIEdgeInsetsMake(32, 37, 32, 37); // 上左下右保持原样的区域
    bubbleImage = [bubbleImage resizableImageWithCapInsets:insets];
    _bubbleView.image = bubbleImage;
    [self.contentView addSubview:_bubbleView];
    [self.contentView sendSubviewToBack:_bubbleView];
    
    [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30.5);
        make.right.equalTo(self.contentView.mas_right).offset(-30.5);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
    }];
}


- (void)setupMessageLabel {
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.numberOfLines = 0; // 允许多行
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.textColor = [UIColor colorWithRed:92 green:95 blue:123 alpha:1];
    _messageLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_messageLabel];

    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bubbleView.mas_left).offset(15);
        make.right.equalTo(_bubbleView.mas_right).offset(-15);
        make.top.equalTo(_bubbleView.mas_top).offset(10);
        make.bottom.equalTo(_bubbleView.mas_bottom).offset(-10);
    }];
    
}

- (void)setMessage:(NSString *)message {
    _message = [message copy];
    // 设置行高
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 16;
    paragraphStyle.maximumLineHeight = 16;
    
    // 设置字体颜色和大小
    UIColor *fontColor = [UIColor colorWithRed:92/255.0 green:95/255.0 blue:123/255.0 alpha:1];
    UIFont *font = [UIFont systemFontOfSize:12];
    
    // 创建属性字典
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSForegroundColorAttributeName: fontColor,
        NSFontAttributeName: font
    };
    _messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:attributes];
    
}


@end
