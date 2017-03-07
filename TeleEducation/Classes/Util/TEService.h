//
//  TEService.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TEService <NSObject>

@optional
- (void)onCleanData;
- (void)onReceiveMemoryWarining;
- (void)onEnterBackground;
- (void)onEnterForeground;
- (void)onAppWillTerminate;

@end

@interface TEService : NSObject<TEService>
+ (instancetype)sharedService;
- (void)start;
@end

@interface TEServiceManager : NSObject
+ (instancetype)sharedManger;
- (void)start;
- (void)destroy;
@end
