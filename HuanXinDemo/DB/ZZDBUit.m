//
//  ZZDBUit.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/22.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "ZZDBUit.h"
#import "FriendRequestModel.h"

@interface ZZDBUit()
{
    NSLock *_lock;
}
@end

@implementation ZZDBUit

+ (ZZDBUit *)shareDatabase {
    
    ZZDBUit *zzDBUit;
    //创建一个对象并且返回
    //考虑多线程，不允许多条线程同时调用此函数的内容
    @synchronized(self){
        zzDBUit = [[self alloc] init];
    }
    return zzDBUit;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        FMDatabase *db = [self db];
        [db open];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (FMDatabase *)db{
    //1.获取本地的数据库文件路径
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *loginAcount = [EMClient sharedClient].currentUsername;
    NSString *dbPath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",loginAcount]];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}

- (void)saveFriendRequestWithUsername:(NSString *)username Message:(NSString *)message {
    
    [_lock lock];
    
    //1.获得数据库文件的路径
    //2.获得数据库
    FMDatabase *db = [self db];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open]) {
        //4.创建表
        BOOL isCreateTableSucc = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS friendrequest (username text NOT NULL, message text);"];
        NSLog(@"创建表的结果：%zd",isCreateTableSucc);
        
        //把以前同名的添加申请给删除
        NSString *deleteSQL = @"delete from friendrequest where username = ?";
        [db executeUpdate:deleteSQL withArgumentsInArray:@[username]];
        
        //5.插入数据
        NSString *insertSQL = @"insert into friendrequest (username,message) values(?,?)";
        BOOL isInterSucc = [db executeUpdate:insertSQL withArgumentsInArray:@[username,message]];
        NSLog(@"插入数据的结果：%zd",isInterSucc);
    }
    [db close];
    
    [_lock unlock];
}

- (void)deleteFriendRequestWithUsername:(NSString *)username {
    
    [_lock lock];
    
    FMDatabase *db = [self db];
    if(![db open]) {
        return;
    }
    [db executeUpdate:@"delete from friendrequest where username = ?" withArgumentsInArray:@[username]];
    [db close];
    
    [_lock unlock];
}

- (NSInteger)totalFriendRequestCount {
    
    [_lock lock];
    
    NSString *sql = @"select count(*) from friendrequest;";
    FMDatabase *db = [self db];
    if(![db open]) {
        return 0;
    }
    FMResultSet *result = [db executeQuery:sql];
    NSInteger count = 0;
    while(result.next){
        count = [result intForColumnIndex:0];
    }
    [db close];
    
    [_lock unlock];
    
    return count;
}

- (NSArray *)friendRequestList {
    
    [_lock lock];
    
    FMDatabase *db = [self db];
    if(![db open]) return nil;
    //1.执行查询的sql语句
    NSString *sql = @"select * from friendrequest";
    FMResultSet *result = [db executeQuery:sql];
    NSMutableArray *friendRequestArray = [NSMutableArray array];
    //2.遍历结果
    while(result.next){
        //3.封装成模型添加到数组
        FriendRequestModel *model = [[FriendRequestModel alloc] init];
        model.username = [result stringForColumn:@"username"];
        model.message = [result stringForColumn:@"message"];
        [friendRequestArray addObject:model];
    }
    
    [db close];
    
    [_lock unlock];
    
    return [friendRequestArray copy];
}

@end
