//
//  TESessionMsgConverter.h
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIMSDK.h"

@class TELocationPoint;
@class TEJanKenPonAttachment;
@class TEChartletAttachment;
@class TEMeetingControlAttachment;
@class TEWhiteboardAttachment;

@interface TESessionMsgConverter : NSObject

+(NIMMessage *)msgWithText:(NSString *)text;
+(NIMMessage *)msgWithImage:(UIImage *)image;
+(NIMMessage *)msgWithAudio:(NSString *)filePath;
+(NIMMessage *)msgWithVideo:(NSString *)filePath;
+(NIMMessage *)msgWithLocation:(TELocationPoint *)locationPoint;
+(NIMMessage *)msgWithJenKenPon:(TEJanKenPonAttachment *)attachment;
+(NIMMessage *)msgWithChartletAttachment:(TEChartletAttachment *)attachment;
+(NIMMessage *)msgWithMeetingControlAttachment:(TEMeetingControlAttachment *)attachment;
+(NIMMessage *)msgWithFilePath:(NSString *)path;
+(NIMMessage *)msgWithFileData:(NSData *)data extension:(NSString *)extension;
+(NIMMessage *)msgWithTip:(NSString *)tip;

@end
