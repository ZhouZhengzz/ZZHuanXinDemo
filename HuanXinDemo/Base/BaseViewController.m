//
//  BaseViewController.m
//  ZZPersonalDemo
//
//  Created by zhouzheng on 16/7/17.
//  Copyright © 2016年 zhouzheng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)showToast:(NSString *)message {
    
    [self.view makeToast:message duration:1.0 position:CSToastPositionCenter];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
