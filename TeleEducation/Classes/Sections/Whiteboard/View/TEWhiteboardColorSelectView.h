//
//  TEWhiteboardColorSelectView.h
//  TeleEducation
//
//  Created by Karl on 2017/5/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  TEWhiteboardColorSelectViewDelegate<NSObject>

- (void)onColorSelected:(int)rgbColor;

@end


@interface TEWhiteboardColorSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       colors:(NSArray *)colors
                     delegate:(id<TEWhiteboardColorSelectViewDelegate>)delegate;

@end
