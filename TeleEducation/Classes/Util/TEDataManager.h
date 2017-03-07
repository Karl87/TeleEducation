//
//  TEDataManager.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEService.h"

@interface TEDataManager : NSObject<NIMKitDataProvider>

+(instancetype)sharedManager;

@property (nonatomic,strong) UIImage *defaultUserAvatar;
@property (nonatomic,strong) UIImage *defaultTeamAvatar;
@end
