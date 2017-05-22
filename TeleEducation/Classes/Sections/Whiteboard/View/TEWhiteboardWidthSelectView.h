//
//  TEWhiteboardWidthSelectView.h
//  TeleEducation
//
//  Created by Karl on 2017/5/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  TEWhiteboardWidthSelectViewDelegate<NSObject>

- (void)onWidthSelected:(float)width;

@end

@interface TEWhiteboardWidthSelectView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                       widths:(NSArray *)widths
                     delegate:(id<TEWhiteboardWidthSelectViewDelegate>)delegate;
@end
