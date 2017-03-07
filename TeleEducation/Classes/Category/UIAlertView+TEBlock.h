//
//  UIAlertView+TEBlock.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AlertBlock)(NSInteger);

@interface UIAlertView (TEBlock)
- (void)showAlertWithCompletionHandler: (AlertBlock)block;
- (void)clearActionBlock;
@end
