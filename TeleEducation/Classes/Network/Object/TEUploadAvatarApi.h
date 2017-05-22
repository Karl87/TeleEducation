//
//  TEUploadAvatarApi.h
//  TeleEducation
//
//  Created by Karl on 2017/5/17.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "TELoginManager.h"

@interface TEUploadAvatarApi : YTKRequest
- (id)initWithToken:(NSString *)token userType:(TEUserType)userType image:(UIImage *)image;
//- (NSString *)responseImageId;
@end
