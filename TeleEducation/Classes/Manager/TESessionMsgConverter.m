//
//  TESessionMsgConverter.m
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESessionMsgConverter.h"
#import "TELocationPoint.h"
#import "NSString+TE.h"
#import "TEJanKenPonAttachment.h"
#import "TEChartletAttachment.h"
#import "TEMeetingControlAttachment.h"

@implementation TESessionMsgConverter

+ (NIMMessage *)msgWithText:(NSString *)text{
    NIMMessage *msg = [[NIMMessage alloc] init];
    msg.text = text;
    return msg;
}

+(NIMMessage *)msgWithImage:(UIImage *)image{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NIMImageObject *imgObject = [[NIMImageObject alloc] initWithImage:image];
    imgObject.displayName = [NSString stringWithFormat:@"图片发送与%@",dateString];
    
    NIMImageOption *option = [[NIMImageOption alloc] init];
    option.compressQuality = 0.8;
    
    NIMMessage *msg = [[NIMMessage alloc] init];
    msg.messageObject = imgObject;
    msg.apnsContent = @"发来了一张图片";
    return msg;
}

+(NIMMessage *)msgWithAudio:(NSString *)filePath{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *msg = [[NIMMessage alloc] init];
    msg.messageObject = audioObject;
    msg.apnsContent = @"发来了一段语音";
    return msg;
}

+(NIMMessage *)msgWithVideo:(NSString *)filePath{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:filePath];
    videoObject.displayName = [NSString stringWithFormat:@"视频发送于%@",dateString];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = videoObject;
    message.apnsContent = @"发来了一段视频";
    return message;
}

+ (NIMMessage*)msgWithLocation:(TELocationPoint*)locationPoint{
    NIMLocationObject *locationObject = [[NIMLocationObject alloc] initWithLatitude:locationPoint.coordinate.latitude
                                                                          longitude:locationPoint.coordinate.longitude
                                                                              title:locationPoint.title];
    NIMMessage *message               = [[NIMMessage alloc] init];
    message.messageObject             = locationObject;
    message.apnsContent = @"发来了一条位置信息";
    return message;
}

+ (NIMMessage*)msgWithJenKenPon:(TEJanKenPonAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了猜拳信息";
    return message;
}

+ (NIMMessage*)msgWithMeetingControlAttachment:(TEMeetingControlAttachment *)attachment
{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.historyEnabled  = NO;
    setting.roamingEnabled  = NO;
    setting.syncEnabled     = NO;
    setting.shouldBeCounted = NO;
    setting.apnsEnabled     = NO;
    message.setting = setting;
    
    return message;
}

+ (NIMMessage*)msgWithFilePath:(NSString*)path{
    NIMFileObject *fileObject = [[NIMFileObject alloc] initWithSourcePath:path];
    NSString *displayName     = path.lastPathComponent;
    fileObject.displayName    = displayName;
    NIMMessage *message       = [[NIMMessage alloc] init];
    message.messageObject     = fileObject;
    message.apnsContent = @"发来了一个文件";
    return message;
}

+ (NIMMessage*)msgWithFileData:(NSData*)data extension:(NSString*)extension{
    NIMFileObject *fileObject = [[NIMFileObject alloc] initWithData:data extension:extension];
    NSString *displayName;
    if (extension.length) {
        displayName     = [NSString stringWithFormat:@"%@.%@",[NSUUID UUID].UUIDString.MD5String,extension];
    }else{
        displayName     = [NSString stringWithFormat:@"%@",[NSUUID UUID].UUIDString.MD5String];
    }
    fileObject.displayName    = displayName;
    NIMMessage *message       = [[NIMMessage alloc] init];
    message.messageObject     = fileObject;
    message.apnsContent = @"发来了一个文件";
    return message;
}


+ (NIMMessage*)msgWithChartletAttachment:(TEChartletAttachment *)attachment{
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"[贴图]";
    return message;
}



+ (NIMMessage *)msgWithTip:(NSString *)tip
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMTipObject *tipObject    = [[NIMTipObject alloc] init];
    message.messageObject      = tipObject;
    message.text               = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    message.setting            = setting;
    return message;
}
@end
