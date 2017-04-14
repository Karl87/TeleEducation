//
//  TELoginInput.h
//  TeleEducation
//
//  Created by Karl on 2017/3/2.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TELoginInput : UITextField

- (instancetype)initWithPlaceHolder:(NSString *)placeholder image:(UIImage *)image isSecureTextEntry:(BOOL)isSecureTextEntry;

@end
