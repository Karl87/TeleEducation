//
//  TEMeetingRTSManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEService.h"
#import <Foundation/Foundation.h>

@protocol TEMeetingRTSManagerDelegate <NSObject>

- (void)onReserve:(NSString *)name result:(NSError *)result;

- (void)onJoin:(NSString *)name result:(NSError *)result;

- (void)onLeft:(NSString *)name error:(NSError *)error;

- (void)onUserJoined:(NSString *)uid conference:(NSString *)name;

- (void)onUserLeft:(NSString *)uid conference:(NSString *)name;
@end

@protocol TEMeetingRTSDataHandler <NSObject>

- (void)handleReceivedData:(NSData *)data sender:(NSString *)sender;

@end

@interface TEMeetingRTSManager : TEService

@property (nonatomic,weak) id<TEMeetingRTSDataHandler> dataHandler;
@property (nonatomic,weak) id<TEMeetingRTSManagerDelegate> delegate;

- (NSError *)reserveConference:(NSString *)name;

- (NSError *)joinConference:(NSString *)name;

- (void)leaveCurrentConference;

- (BOOL)sendRTSData:(NSData *)data toUser:(NSString *)uid;

- (BOOL)isJoined;

@end
