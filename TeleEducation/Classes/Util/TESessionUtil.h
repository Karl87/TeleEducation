//
//  TESessionUtil.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TESessionUtil : NSObject

+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
                                  minSize:(CGSize)imageMinSize
                                  maxSize:(CGSize)imageMaxSize;

+ (NSString *)showNick:(NSString *)uid inSession:(NIMSession *)session;

+ (NSString *)showTime:(NSTimeInterval)msgLastTime showDetail:(BOOL)showDetail;
+ (void)sessionWithInputURL:(NSURL *)inputURL
                  outputURL:(NSURL *)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler;

+ (NSString *)formatedMessage:(NIMMessage *)message;
+ (NSDictionary *)dictByJsonData:(NSData *)data;
+ (NSDictionary *)dictByJsonString:(NSString *)jsonString;
@end
