//
//  AIChatList.m
//  Pods
//
//  Created by ywen on 2024/9/11.
//

#import "AIChatList.h"
#import "AIChatCell.h"

@implementation AIChatList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView {
    // 初始化消息列表
    _messageList = [[NSMutableArray alloc] init];
    
    
    // 设置和配置 UITableView
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 74;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[AIChatCell class] forCellReuseIdentifier:@"AIChatCell"];
    [self addSubview:_tableView];
    
    // 设置自动调整大小
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AIChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AIChatCell" forIndexPath:indexPath];
    cell.message = self.messageList[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44; // 一个合理的预估值
//}

#pragma mark - Update Message List

- (void)updateMessageList:(NSArray<NSString *> *)newMessages {
    [self.messageList addObjectsFromArray:newMessages];
    [self.tableView reloadData];
    // 滚动到最后一行
    if (self.messageList.count > 0) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

@end
