//
//  UIAlertView+TEBlock.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "UIAlertView+TEBlock.h"
#import <objc/runtime.h>
static char kUIAlertViewBlockAddress;

@implementation UIAlertView (TEBlock)
- (void)showAlertWithCompletionHandler: (void (^)(NSInteger))block
{
    self.delegate = self;
    objc_setAssociatedObject(self,&kUIAlertViewBlockAddress,block,OBJC_ASSOCIATION_COPY);
    [self show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AlertBlock block = objc_getAssociatedObject(self, &kUIAlertViewBlockAddress);
    if (block)
    {
        block(buttonIndex);
        objc_setAssociatedObject(self, &kUIAlertViewBlockAddress, nil, OBJC_ASSOCIATION_COPY);
    }
}

- (void)clearActionBlock
{
    self.delegate = nil;
    objc_setAssociatedObject(self, &kUIAlertViewBlockAddress, nil, OBJC_ASSOCIATION_COPY);
}

@end
