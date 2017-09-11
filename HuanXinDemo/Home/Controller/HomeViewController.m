//
//  HomeViewController.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/19.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "ChatViewController.h"

static NSString *CELL_ID = @"cellId";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>
{
    NSMutableArray *_conversationsArray;
    UITableView *_tableView;
}
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
    [self showTotalUnreadCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"首页";
    _conversationsArray = [[NSMutableArray alloc] init];
    
    //获取所有会话(内存中有则从内存中取，没有则从db中取)
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    [_conversationsArray addObjectsFromArray:conversations];
    
//    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:@"zz002" type:EMConversationTypeChat createIfNotExist:YES];
//    [_conversationsArray addObject:conversation];
    
    
    //EMChatManagerDelegate
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [self configTableView];
    
}

- (void)configTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.conversation = _conversationsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取会话对象
    EMConversation *con = _conversationsArray[indexPath.row];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:con.conversationId conversationType:con.type];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //删除某个会话
    EMConversation *con = _conversationsArray[indexPath.row];
    [[EMClient sharedClient].chatManager deleteConversation:con.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        if (!aError) {
            NSLog(@"删除会话成功");
            [_conversationsArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else {
            NSLog(@"%@",aError);
        }
        
    }];
}

#pragma mark - EMChatManagerDelegate
//接收到新消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    [_tableView reloadData];
    [self showTotalUnreadCount];
}

//监听会话列表数据更新
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [_conversationsArray removeAllObjects];
    [_conversationsArray addObjectsFromArray:aConversationList];
    [_tableView reloadData];
    [self showTotalUnreadCount];
}

- (void)showTotalUnreadCount {
    int count = 0;
    for(EMConversation *con in _conversationsArray){
        count += [con unreadMessagesCount];
    }
    if (count > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",count];
    }else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
