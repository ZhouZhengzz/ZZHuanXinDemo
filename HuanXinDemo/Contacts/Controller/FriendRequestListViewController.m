//
//  FriendRequestListViewController.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/21.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "FriendRequestListViewController.h"
#import "AddFriendViewController.h"
#import "ZZDBUit.h"
#import "FriendRequestModel.h"

static NSString *CELL_ID = @"cellId";

@interface FriendRequestListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_friendRequestArray;
    UITableView *_tableView;
}
@end

@implementation FriendRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新的朋友";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFriend)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    _friendRequestArray = [[NSMutableArray alloc] init];
    [_friendRequestArray addObjectsFromArray:[[ZZDBUit shareDatabase] friendRequestList]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)addNewFriend {
    
    AddFriendViewController *addVC = [[AddFriendViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendRequestArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
        
        //cell的右边添加同意按钮
        UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
        [acceptBtn setBackgroundColor:[UIColor grayColor]];
        [acceptBtn sizeToFit];
        [acceptBtn addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = acceptBtn;
    }
    cell.accessoryView.tag = indexPath.row;
    FriendRequestModel  *model = _friendRequestArray[indexPath.row];
    cell.textLabel.text = model.username;
    cell.detailTextLabel.text = model.message;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendRequestModel *model = _friendRequestArray[indexPath.row];
    //发送请求给服务器
    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:model.username completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"拒绝请求发送成功");
            //1.当前记录从数据库删除
            [[ZZDBUit shareDatabase] deleteFriendRequestWithUsername:model.username];
            //2.当前记录从表格数据源删除
            [_friendRequestArray removeObject:model];
            //3.刷新表格
            [_tableView reloadData];
            
        }else {
            NSLog(@"拒绝请求发送失败");
        }
    }];
}

- (void)acceptAction:(UIButton *)btn {
    
    FriendRequestModel *model = _friendRequestArray[btn.tag];
    //发送请求给服务器
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:model.username completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"同意请求发送成功");
            //1.当前记录从数据库删除
            [[ZZDBUit shareDatabase] deleteFriendRequestWithUsername:model.username];
            //2.当前记录从表格数据源删除
            [_friendRequestArray removeObject:model];
            //3.刷新表格
            [_tableView reloadData];
            
        }else {
            NSLog(@"同意请求发送失败");
        }
    } ];
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
