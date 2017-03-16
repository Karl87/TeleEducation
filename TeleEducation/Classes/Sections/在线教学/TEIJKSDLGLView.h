//
//  TEIJKSDLGLView.h
//  TeleEducation
//
//  Created by Karl on 2017/3/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "ijksdl_vout.h"

@interface TEIJKSDLGLView : UIView
- (id)initWithFrame:(CGRect)frame;
- (void)display:(SDL_VoutOverlay *)overlay clear:(BOOL)clear;
- (UIImage *)snapshot;
#if defined TEIJKSDLHudView
- (void)setHudValue:(NSString *)value forKey:(NSString *)key;
#endif
@property (nonatomic,strong) NSLock *appActivityLock;
@property (nonatomic) CGFloat fps;
@property (nonatomic) CGFloat scaleFactor;
#if defined TEIJKSDLHudView
@property (nonatomic) BOOL shouldShowHudView;
#endif
@end
