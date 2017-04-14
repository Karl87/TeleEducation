//
//  TEWhiteboardPoint.h
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,TEWhiteboardPointType) {
    TEWhiteboardPointTypeStart = 1,
    TEWhiteboardPointTypeMove = 2,
    TEWhiteboardPointTypeEnd = 3
};


@interface TEWhiteboardPoint : NSObject

@property (nonatomic,assign) TEWhiteboardPointType type;
@property (nonatomic,assign) float xScale;
@property (nonatomic,assign) float yScale;
@property (nonatomic,assign) int colorRGB;
@property (nonatomic,assign) NSInteger page;
@end
