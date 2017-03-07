//
//  UIActionSheet+TEBlock.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionSheetBlock)(NSInteger);

@interface UIActionSheet (TEBlock)<UIActionSheetDelegate>

- (void)showInView: (UIView *)view completionHandler: (ActionSheetBlock)block;
- (void)clearActionBlock;
@end
