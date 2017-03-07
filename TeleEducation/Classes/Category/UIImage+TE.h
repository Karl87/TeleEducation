//
//  UIImage+TE.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TE)
+ (UIImage *)fetchImage:(NSString *)imageNameOrPath;

+ (UIImage *)fetchChartlet:(NSString *)imageName chartletId:(NSString *)chartletId;

- (UIImage *)imageForAvatarUpload;
@end
