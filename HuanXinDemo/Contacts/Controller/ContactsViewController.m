//
//  ContactsViewController.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/19.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddFriendViewController.h"
#import "ChatViewController.h"
#import "FriendRequestListViewController.h"
#import "ZZDBUit.h"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, EMContactManagerDelegate>
{
    NSMutableArray *_friendsArray;
    UITableView *_tableView;
    UIView *_headerView;
    UILabel *_newLabel;
    UILabel *_countLabel;
}
@end

@implementation ContactsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger count = [[ZZDBUit shareDatabase] totalFriendRequestCount];
    if (count > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",count];
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"%zd",count];
    }else {
        self.navigationController.tabBarItem.badgeValue = nil;
        _countLabel.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通讯录";
    
    _friendsArray = [[NSMutableArray alloc] init];
    
    [self createUI];
    [self getContactsData];
    
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

#pragma mark - UI
- (void)createUI {
    
    //右上角 +
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFriend)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    _headerView.backgroundColor = [UIColor lightGrayColor];
    _headerView.userInteractionEnabled = YES;
    
    _newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-80, 60)];
    _newLabel.textAlignment = NSTextAlignmentLeft;
    _newLabel.text = @"好友申请列表";
    [_headerView addSubview:_newLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-40, 20, 20, 20)];
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.layer.cornerRadius = 10.0;
    _countLabel.clipsToBounds = YES;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.hidden = YES;
    [_headerView addSubview:_countLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(torequestlist)];
    [_headerView addGestureRecognizer:tap];
    
    _tableView.tableHeaderView = _headerView;
    
}

- (void)addNewFriend {

    AddFriendViewController *addVC = [[AddFriendViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)torequestlist {
    FriendRequestListViewController *frVC = [[FriendRequestListViewController alloc] init];
    frVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:frVC animated:YES];
}

#pragma mark - 获取通讯录数据
- (void)getContactsData {
    
//    //环信会默认把还有保存到本地数据库中
//    //从数据库中获取好友数据
//    NSArray *contacts = [[EMClient sharedClient].contactManager getContacts];
//    if (contacts.count == 0) {
//        //如果数据库中没有好友数据，则从服务器获取
//        [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
//            if (!aError) {
//                [_friendsArray addObjectsFromArray:aList];
//                [_tableView reloadData];
//            }
//            
//        }];
//    }else {
//        //数据库中有好友数据
//        [_friendsArray addObjectsFromArray:contacts];
//        
//    }
    
    
    //只从服务器获取好友列表
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            [_friendsArray addObjectsFromArray:aList];
            [_tableView reloadData];
        }
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"我的好友";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = _friendsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *friendUsername = _friendsArray[indexPath.row];
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:friendUsername conversationType:EMConversationTypeChat];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除好友
    weak(weakself);
    NSString *username = _friendsArray[indexPath.row];
    [[EMClient sharedClient].contactManager deleteContact:username isDeleteConversation:YES completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"删除好友【%@】成功",aUsername);
            [weakself showToast:[NSString stringWithFormat:@"删除好友【%@】成功",aUsername]];
            
            [_friendsArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark - EMContactManagerDelegate
/*!
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *  @param aUsername   用户好友关系的另一方
 */
- (void)friendshipDidAddByUser:(NSString *)aUsername{
    NSLog(@"%s",__func__);
    [_friendsArray addObject:aUsername];
    [_tableView reloadData];
}

/*!
 *  用户B删除与用户A的好友关系后，用户A，B会收到这个回调
 *  @param aUsername   用户B
 */
- (void)friendshipDidRemoveByUser:(NSString *)aUsername {
    [_friendsArray removeObject:aUsername];
    [_tableView reloadData];
}


- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage {
    
    NSInteger count = [[ZZDBUit shareDatabase] totalFriendRequestCount];
    if (count > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",count];
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"%zd",count];
    }else {
        self.navigationController.tabBarItem.badgeValue = nil;
        _countLabel.hidden = YES;
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
