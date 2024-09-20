//
//  AIChatList.h
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AIChatList : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *messageList;

- (void)updateMessageList:(NSArray<NSString *> *)newMessages;


@end

NS_ASSUME_NONNULL_END
