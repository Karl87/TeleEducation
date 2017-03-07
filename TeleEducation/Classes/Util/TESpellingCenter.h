//
//  TESpellingConverter.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpellingUnit : NSObject<NSCoding>
@property (nonatomic,strong)    NSString *fullSpelling;
@property (nonatomic,strong)    NSString *shortSpelling;
@end

@interface TESpellingCenter : NSObject{
    NSMutableDictionary *_spellingCache;    //全拼，简称cache
    NSString *_filepath;
}
+ (TESpellingCenter *)sharedCenter;
- (void)saveSpellingCache;          //写入缓存

- (SpellingUnit *)spellingForString: (NSString *)source;    //全拼，简拼 (全是小写)
- (NSString *)firstLetter: (NSString *)input;

@end
