//
//  ZZTabBarViewController.m
//  ZZPersonalDemo
//
//  Created by zhouzheng on 16/7/17.
//  Copyright © 2016年 zhouzheng. All rights reserved.
//

#import "ZZTabBarViewController.h"

#import "BaseNavViewController.h"
#import "HomeViewController.h"
#import "ContactsViewController.h"
#import "MineViewController.h"

@interface ZZTabBarViewController ()
{
    HomeViewController *_homeVC;
    ContactsViewController *_contactsVC;
    MineViewController *_mineVC;
}
@end

@implementation ZZTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavsToTabBar];
}

- (void)addNavsToTabBar {

    [self toTabBar_Font_color];
    
    _homeVC = [[HomeViewController alloc] init];
    [self setNavRootViewControll:_homeVC titleStr:@"首页" imagePath:@"tab_home" selectedImagePath:@"tab_home_s"];
    
    _contactsVC = [[ContactsViewController alloc] init];
    [self setNavRootViewControll:_contactsVC titleStr:@"通讯录" imagePath:@"tab_contacts" selectedImagePath:@"tab_contacts_s"];
    
    _mineVC = [[MineViewController alloc] init];
    [self setNavRootViewControll:_mineVC titleStr:@"我的" imagePath:@"tab_mine" selectedImagePath:@"tab_mine_s"];
}

/**
 * @brief 设置viewController并添加到UITabBarViewControll
 *
 * @param viewController    VC控制器
 * @param title             tab标题、nav标题
 * @param imagePath         默认图片
 * @param selectedImagePath 选中、点击 是的图片
 */
- (void )setNavRootViewControll:(BaseViewController *)viewController titleStr:(NSString *)title imagePath:(NSString *)imagePath selectedImagePath:(NSString *)selectedImagePath {
    
    //tabBar图片渲染有个默认的值，改成UIImageRenderingModeAlwaysOriginal，就是图片本身图，否则会渲染【tint.color  灰--蓝(色)】
    UIImage * image = [[UIImage imageNamed:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage * selectImage = [[UIImage imageNamed:selectedImagePath]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //viewControll导航栏标题
    viewController.navigationItem.title = title;
    
    //标签栏的标题
    viewController.tabBarItem.title = title;
    //    //标签栏默认图片
    viewController.tabBarItem.image = image;
    //标签栏选中时的图片
    viewController.tabBarItem.selectedImage = selectImage;
    
    // 控制器放到 导航栏控制器中
    BaseNavViewController * nav = [[BaseNavViewController alloc] initWithRootViewController:viewController];
    
    //导航栏放到 标签栏
    [self addChildViewController:nav];
    
}

- (void)toTabBar_Font_color {
    
    //改变字的颜色
    
    //默认颜色
    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //选中颜色
    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:27.0/255 green:178.0/255 blue:9.0/255 alpha:1],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
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
