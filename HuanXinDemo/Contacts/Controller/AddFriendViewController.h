//
//  AddFriendViewController.h
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/21.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//添加好友

#import "BaseViewController.h"

@interface AddFriendViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(UIButton *)sender;

@end
