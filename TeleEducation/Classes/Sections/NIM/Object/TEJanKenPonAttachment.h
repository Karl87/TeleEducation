//
//  TEJanKenPonAttachment.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECustomAttachmentDefines.h"

typedef NS_ENUM(NSInteger,CustomJanKenPonValue) {
    CustomJanKenPonValueKen =1,
    CustomJanKenPonValueJan  =2,
    CustomJanKenPonValuePon = 3
};

@interface TEJanKenPonAttachment : NSObject<NIMCustomAttachment,TECustomAttachmentInfo>

@property (nonatomic,assign) CustomJanKenPonValue value;
@property (nonatomic,strong) UIImage *showCoverImage;

@end
