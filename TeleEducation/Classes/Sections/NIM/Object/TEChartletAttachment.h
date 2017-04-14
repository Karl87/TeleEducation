//
//  TEChartletAttachment.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECustomAttachmentDefines.h"

@interface TEChartletAttachment : NSObject<NIMCustomAttachment,TECustomAttachmentInfo>
@property (nonatomic,copy)NSString *chartletID;
@property (nonatomic,copy)NSString *chartletCatalog;
@property (nonatomic,strong) UIImage *showCoverImage;
@end
