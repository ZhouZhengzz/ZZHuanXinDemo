//
//  AddFriendViewController.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/21.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加好友";
}

- (IBAction)addBtnClick:(UIButton *)sender {
    
    weak(weakself);
    [[EMClient sharedClient].contactManager addContact:self.usernameTF.text message:@"我想加你为好友" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"发送请求成功");
            [weakself showToast:@"发送请求成功"];
        }else {
            NSLog(@"发送请求失败：%zd",aError.code);
            [weakself showToast:@"发送请求失败"];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
