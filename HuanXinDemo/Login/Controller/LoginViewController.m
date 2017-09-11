//
//  LoginViewController.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/19.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "LoginViewController.h"
#import "ZZTabBarViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 注册
- (IBAction)registerBtnClick:(UIButton *)sender {
    
    NSString *username = self.usernameTF.text;
    NSString *password = self.passwordTF.text;
    
    weak(weakself);
    [[EMClient sharedClient] registerWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            NSLog(@"注册失败");
        }else {
            NSLog(@"注册成功");
            [weakself showToast:@"注册成功，请登录"];
        }
    }];
}

#pragma mark - 登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    
    NSString *username = self.usernameTF.text;
    NSString *password = self.passwordTF.text;

    weak(weakself);
    [[EMClient sharedClient] loginWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            NSLog(@"登录失败");
        }else {
            NSLog(@"登录成功");
            //自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            //进入主界面
            weakself.view.window.rootViewController = [[ZZTabBarViewController alloc] init];
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
