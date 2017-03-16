//
//  TEWhiteboardDrawView.m
//  TeleEducation
//
//  Created by Karl on 2017/3/16.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardDrawView.h"
#import <QuartzCore/QuartzCore.h>
#import "TECADisplayLinkHolder.h"
#import "TEWhiteboardPoint.h"

@interface TEWhiteboardDrawView ()<TECADisplayLinkHolderDelegate>

@property (nonatomic,strong) TECADisplayLinkHolder *displayLinkHolder;

@end

@implementation TEWhiteboardDrawView

#pragma mark - public methods

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.masksToBounds = YES;
        
        _displayLinkHolder = [[TECADisplayLinkHolder alloc] init];
        [_displayLinkHolder setFrameInterval:3];
        [_displayLinkHolder startCADisplayLinkWithDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [_displayLinkHolder stop];
}

+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (void)onDisplayLinkFire:(TECADisplayLinkHolder *)holder duration:(NSTimeInterval)duration displayLink:(CADisplayLink *)displayLink{
    if (self.dataSource && [self.dataSource hasUpdate]) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    NSDictionary *allLines = [self.dataSource allLinesToDraw];
    for (NSString *uid in allLines.allKeys) {
        NSArray *lines = [allLines objectForKey:uid];
        NSUInteger linesCount = lines.count;
    }
}

@end
