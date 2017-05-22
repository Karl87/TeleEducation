//
//  TEService.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEService.h"
#import "TESessionUtil.h"

#pragma mark - NIMSeriveceManagerImpl

@interface TEServiceManagerImpl : NSObject
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSMutableDictionary *singletons;
@end

@implementation TEServiceManagerImpl

+ (TEServiceManagerImpl *)coreImpl:(NSString *)key{
    TEServiceManagerImpl *impl = [[TEServiceManagerImpl alloc] init];
    impl.key = key;
    return impl;
}

- (id) init{
    if (self = [super init]) {
        _singletons = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)singletonByClass:(Class)singletonClass{
    NSString *singletonClassName = NSStringFromClass(singletonClass);
    id singleton = [_singletons objectForKey:singletonClassName];
    if (!singleton) {
        singleton  = [[singletonClass alloc] init];
        [_singletons setObject:singleton forKey:singletonClassName];
    }
    return singleton;
}

- (void)callSingletonSelector:(SEL)selector{
    NSArray *array = [_singletons allValues];
    NSLog(@"array count %ld",array.count);
    for (id obj in array) {
        if ([obj respondsToSelector:selector]) {
            SuppressPerformSelectorLeakWarning([obj performSelector:selector]);
        }
    }
}

@end

#pragma mark - TEServiceManager
@interface TEServiceManager()
@property (nonatomic,strong) NSRecursiveLock *lock;
@property (nonatomic,strong) TEServiceManagerImpl *core;
+(instancetype)sharedManger;
- (id)singletonByClass:(Class)singletonClass;
@end
@implementation TEServiceManager

+(instancetype) sharedManger{
    static TEServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TEServiceManager alloc] init];
    });
    return manager;
}

- (id)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callAppWillTerminate)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start{
    [_lock lock];
    NSString *key = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    _core = [TEServiceManagerImpl coreImpl:key];
    [_lock unlock];
}

- (void)destroy{
    [_lock lock];
    [self callSingletonClean];
    _core = nil;
    [_lock unlock];
}
- (id)singletonByClass:(Class)singletonClass{
    id instance = nil;
    [_lock lock];
    instance = [_core singletonByClass:singletonClass];
    [_lock unlock];
    return instance;
}

#pragma mark - Call Functions
- (void)callSingletonClean
{
    [self callSelector:@selector(onCleanData)];
}


- (void)callReceiveMemoryWarning
{
    [self callSelector:@selector(onReceiveMemoryWarining)];
}


- (void)callEnterBackground
{
    [self callSelector:@selector(onEnterBackground)];
}

- (void)callEnterForeground
{
    [self callSelector:@selector(onEnterForeground)];
}

- (void)callAppWillTerminate
{
    [self callSelector:@selector(onAppWillTerminate)];
}

- (void)callSelector: (SEL)selector
{
    [_core callSingletonSelector:selector];
}


@end
#pragma mark - TEService
@implementation TEService
+ (instancetype)sharedService{
    return [[TEServiceManager sharedManger] singletonByClass:[self class]];
}
- (void)start{
    NSLog(@"NIMService %@ Started", self);
}
@end
