//
//  MineViewController.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/19.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    
    NSString *currentName = [EMClient sharedClient].currentUsername;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2, 100, 200, 100)];
    label.backgroundColor = [UIColor orangeColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    NSString *text = [NSString stringWithFormat:@"\" 我是（哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈）%@ \"",currentName];
    [self.view addSubview:label];
    
    
    //用来测试非首行缩进
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.headIndent = 10;
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.lineSpacing = 5;
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName:paraStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize:14] };
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes: attrDict];
    
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(20, 300, ScreenWidth-40, 40);
    logoutBtn.backgroundColor = [UIColor redColor];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoutBtn];
}

- (void)logout {
    
    weak(weakself);
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if (aError) {
            NSLog(@"退出失败");
        }else {
            NSLog(@"退出成功");
            [weakself showToast:@"退出成功"];
            
            [weakself performSelector:@selector(logoutSucc) withObject:nil afterDelay:1.0];
            
        }
    }];
}

- (void)logoutSucc {
    self.view.window.rootViewController = [[LoginViewController alloc] init];
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
