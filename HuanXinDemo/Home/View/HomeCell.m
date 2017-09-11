//
//  HomeCell.m
//  HuanXinDemo
//
//  Created by zhouzheng on 2017/6/19.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.unreadCount.layer.cornerRadius = 14.0/2;
    self.unreadCount.clipsToBounds = YES;
    self.unreadCount.hidden = YES;
}

- (void)setConversation:(EMConversation *)conversation {
    _conversation = conversation;
    
    //未读消息数
    NSInteger unreadCount = [conversation unreadMessagesCount];
    if (unreadCount > 0) {
        self.unreadCount.hidden = NO;
        self.unreadCount.text = [NSString stringWithFormat:@"%zd",unreadCount];
    
    }else {
        self.unreadCount.hidden = YES;
    }
    
    //好友名称
    self.username.text = conversation.conversationId;
    
    //最新消息
    EMMessage *message = conversation.latestMessage;
    if (message.body.type == EMMessageBodyTypeText) {
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        self.message.text = textBody.text;
        
    }else if (message.body.type == EMMessageBodyTypeImage) {
        self.message.text = @"[图片]";
        
    }else if (message.body.type == EMMessageBodyTypeVoice) {
        self.message.text = @"[语音]";
        
    }else if (message.body.type == EMMessageBodyTypeVideo) {
        self.message.text = @"[视频]";
        
    }else if (message.body.type == EMMessageBodyTypeLocation) {
        self.message.text = @"[位置]";
        
    }else if (message.body.type == EMMessageBodyTypeFile) {
        self.message.text = @"[文件]";
        
    }else if (message.body.type == EMMessageBodyTypeCmd) {
        self.message.text = @"[命令]";
        
    }else {
        self.message.text = @"[未知消息类型]";
    }
    
    //时间
    NSString *timeStr =  [NSDate formattedTimeFromTimeInterval:message.timestamp];
    self.time.text = timeStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
