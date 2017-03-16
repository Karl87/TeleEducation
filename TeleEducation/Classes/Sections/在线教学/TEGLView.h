//
//  TEGLView.h
//  TeleEducation
//
//  Created by Karl on 2017/3/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "IJKSDLGLView.h"

@interface TEGLView : TEIJKSDLGLView

- (void) render: (NSData *)yuvData
          width:(NSUInteger)width
         height:(NSUInteger)height;
@end
