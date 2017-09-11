//
//  HomeCell.h
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/19.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell

@property (nonatomic, strong) EMConversation *conversation;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;//头像
@property (weak, nonatomic) IBOutlet UILabel *unreadCount;//未读消息数
@property (weak, nonatomic) IBOutlet UILabel *username;//昵称
@property (weak, nonatomic) IBOutlet UILabel *message;//最新消息
@property (weak, nonatomic) IBOutlet UILabel *time;//时间


@end
