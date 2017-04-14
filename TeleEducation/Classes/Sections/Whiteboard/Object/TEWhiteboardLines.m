//
//  TEWhiteboardLines.m
//  TeleEducation
//
//  Created by Karl on 2017/3/16.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardLines.h"

@interface TEWhiteboardLines ()
@property (nonatomic,strong) NSMutableDictionary *allLines;
@end

@implementation TEWhiteboardLines
- (instancetype)init{
    self = [super init];
    if (self) {
        _allLines = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary *)allLines{
    return _allLines;
}

- (void)addPoint:(TEWhiteboardPoint *)point uid:(NSString *)uid
{
    if (!point || !uid) {
        return;
    }
    
    NSMutableArray *lines = [_allLines objectForKey:uid];
    
    if (!lines) {
        lines = [[NSMutableArray alloc] init];
        [_allLines setObject:lines forKey:uid];
    }
    
    if (point.type == TEWhiteboardPointTypeStart) {
        [lines addObject:[NSMutableArray arrayWithObject:point]];
    }
    else if (lines.count == 0){
        [lines addObject:[NSMutableArray arrayWithObject:point]];
    }
    else {
        NSMutableArray *lastLine = [lines lastObject];
        [lastLine addObject:point];
    }
    
    _hasUpdate = YES;
}

- (void)cancelLastLine:(NSString *)uid
{
    NSMutableArray *lines = [_allLines objectForKey:uid];
    [lines removeLastObject];
    _hasUpdate = YES;
}

- (void)clear
{
    [_allLines removeAllObjects];
    _hasUpdate = YES;
}

- (void)clearUser:(NSString *)uid
{
    NSMutableArray *lines = [_allLines objectForKey:uid];
    [lines removeAllObjects];
    _hasUpdate = YES;
}

#pragma  mark - NTESWhiteboardDrawViewDataSource
- (NSDictionary *)allLinesToDraw
{
    _hasUpdate = NO;
    return _allLines;
}


- (BOOL)hasUpdate
{
    return _hasUpdate;
}

- (BOOL)hasLines
{
    BOOL has = NO;
    
    for (NSMutableArray *lines in _allLines.allValues) {
        if (lines.count > 0) {
            has = YES;
        }
    }
    return has;
}


@end
