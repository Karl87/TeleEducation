//
//  TEChatroomTextContentConfig.m
//  TeleEducation
//
//  Created by Karl on 2017/4/11.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChatroomTextContentConfig.h"
#import "M80AttributedLabel+NIMKit.h"
#import "NIMGlobalMacro.h"

@interface TEChatroomTextContentConfig ()
@property (nonatomic,strong) NIMAttributedLabel *label;
@end

@implementation TEChatroomTextContentConfig

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message
{
    NSString *text = message.text;
    [self.label nim_setText:text];
    CGFloat msgBubbleMaxWidth    = (cellWidth - 130);
    CGFloat bubbleLeftToContent  = 15;
    CGFloat contentRightToBubble = 0;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    return [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
}

- (NSString *)cellContent:(NIMMessage *)message
{
    return @"NTESChatroomTextContentView";
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    return UIEdgeInsetsMake(20,15,10,0);
}

- (NIMAttributedLabel *)label
{
    if (!_label) {
        _label = [[NIMAttributedLabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:Chatroom_Message_Font_Size];
    }
    return _label;
}

@end
