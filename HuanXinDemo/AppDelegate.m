//
//  AppDelegate.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/15.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZDBUit.h"

@interface AppDelegate () <EMClientDelegate, EMContactManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化SDK
    EMOptions *options = [EMOptions optionsWithAppkey:@"zz112910#huanxindemo"];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //添加EMClient的代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //添加contactManager的代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ZZTabBarViewController *tabVC = [[ZZTabBarViewController alloc] init];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {
        self.window.rootViewController = tabVC;
    }else {
        self.window.rootViewController = loginVC;
    }
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - EMClient的代理
//自动登录完成时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)aError {
    if (aError) {
        NSLog(@"自动登录失败：%@",aError);
    }else {
        NSLog(@"自动登录成功");
    }
}

//当前登录账号在其它设备登录时会接收到该回调
- (void)userAccountDidLoginFromOtherDevice {
    self.window.rootViewController = [[LoginViewController alloc] init];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"当前帐号在其它设备登录，如非本人操作，请及时修改密码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - EMContactManagerDelegate
//用户A发送加用户B为好友的申请，用户B会收到这个回调 
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage {
    NSLog(@"%@,%@",aUsername,aMessage);
    
    //把好友申请存储到数据库中
    [[ZZDBUit shareDatabase] saveFriendRequestWithUsername:aUsername Message:aMessage];
    
//    //显示tabbarbutton的badge
//    UITabBarController *tbContr = (UITabBarController *)self.window.rootViewController;
//    UINavigationController *contactNav = tbContr.childViewControllers[1];
//    //获取friendRequest的记录条数
//    NSInteger count = [[ZZDBUit shareDatabase] totalFriendRequestCount];
//    if (count > 0) {
//        contactNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",count];
//    }else {
//        contactNav.tabBarItem.badgeValue = nil;
//    }
    
}

//用户B同意用户A的加好友请求后，用户A会收到这个回调
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    NSString *msg = [NSString stringWithFormat:@"%@ 同意了好友请求",aUsername];
    [self showAlertMessage:msg title:@"好友请求结果"];
}

//用户B拒绝用户A的加好友请求后，用户A会收到这个回调
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    //    NSLog(@"%@ 拒绝了好友请求",aUsername);
    NSString *msg = [NSString stringWithFormat:@"%@ 拒绝了好友请求",aUsername];
    [self showAlertMessage:msg title:@"好友请求结果"];
}


-(void)showAlertMessage:(NSString *)msg title:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
