//
//  TESessionCustomContentConfig.m
//  TeleEducation
//
//  Created by Karl on 2017/4/11.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESessionCustomContentConfig.h"
#import "TECustomAttachmentDefines.h"

@implementation TESessionCustomContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<TECustomAttachmentInfo> info = (id<TECustomAttachmentInfo>)object.attachment;
    return [info contentSize:message cellWidth:cellWidth];
}

- (NSString *)cellContent:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<TECustomAttachmentInfo> info = (id<TECustomAttachmentInfo>)object.attachment;
    return [info cellContent:message];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<TECustomAttachmentInfo> info = (id<TECustomAttachmentInfo>)object.attachment;
    return [info contentViewInsets:message];
}


@end
