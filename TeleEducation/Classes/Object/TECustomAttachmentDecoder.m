//
//  TECustomAttachmentDecoder.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECustomAttachmentDecoder.h"
#import "TESessionUtil.h"
#import "NSDictionary+TEJson.h"
#import "TECustomAttachmentDecoder.h"
#import "TEJanKenPonAttachment.h"
#import "TEMeetingControlAttachment.h"
#import "TEChartletAttachment.h"
#import "TECustomAttachmentDefines.h"

@implementation TECustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    id<NIMCustomAttachment> attachment = nil;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if(data){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSInteger type = [dic jsonInteger:CMType];
            NSDictionary *data = [dic jsonDict:CMData];
            switch (type) {
                case CustomJanKenPonValueJan:
                {
                    attachment = [[TEJanKenPonAttachment alloc] init];
                    ((TEJanKenPonAttachment *)attachment).value  =[data jsonInteger:CMValue];
                }
                    break;
                case CustomMessageTypeChartlet:{
                    attachment = [[TEChartletAttachment alloc] init];
                    ((TEChartletAttachment *)attachment).chartletCatalog = [data jsonString:CMCatalog];
                    ((TEChartletAttachment *)attachment).chartletID      = [data jsonString:CMChartlet];
                }
                case CustomMessageTypeMeetingControl:{
                    attachment = [[TEMeetingControlAttachment alloc] init];
                    ((TEMeetingControlAttachment *)attachment).roomID = [data jsonString:CMRoomID];
                    ((TEMeetingControlAttachment *)attachment).command = [data jsonInteger:CMCommand];
                    ((TEMeetingControlAttachment *)attachment).uids = [data jsonArray:CMUIDs];
                }
                default:
                    break;
            }
            attachment = [self checkAttachment:attachment]?attachment:nil;
        }
    }
    return attachment;
}

- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment{
    BOOL check = NO;
    if ([attachment isKindOfClass:[TEJanKenPonAttachment class]]) {
        NSInteger value = [((TEJanKenPonAttachment *)attachment) value];
        check = (value >= CustomJanKenPonValueKen && value <=CustomJanKenPonValuePon)?YES:NO;
    }else if ([attachment isKindOfClass:[TEChartletAttachment class]]){
        NSString *chartletCatalog = ((TEChartletAttachment *)attachment).chartletCatalog;
        NSString *chartletID = ((TEChartletAttachment*)attachment).chartletID;
        check = chartletCatalog.length&&chartletID.length?YES:NO;
    }else if ([attachment isKindOfClass:[TEMeetingControlAttachment class]]){
        return YES;
    }
    return check;
}
@end
