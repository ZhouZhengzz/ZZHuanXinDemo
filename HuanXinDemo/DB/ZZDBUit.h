//
//  ZZDBUit.h
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/22.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface ZZDBUit : NSObject

+ (ZZDBUit *)shareDatabase;

//保存添加好友申请到本地数据库
- (void)saveFriendRequestWithUsername:(NSString *)username Message:(NSString *)message;
//删除好友申请
- (void)deleteFriendRequestWithUsername:(NSString *)username;
//好友申请数据列表
- (NSArray *)friendRequestList;
//好友申请的总条数
- (NSInteger)totalFriendRequestCount;

@end
