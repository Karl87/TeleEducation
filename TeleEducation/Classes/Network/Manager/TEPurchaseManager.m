//
//  TEPurchaseManager.m
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPurchaseManager.h"
#import "AppDelegate.h"
#import "TEPurchaseDetailViewController.h"

@interface TEPurchaseManager ()
@property (nonatomic,strong) UIWindow *window;
@end

@implementation TEPurchaseManager{
    NSPointerArray* _delegates; // the array of observing delegates
}

+(instancetype)sharedManager{
    static TEPurchaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TEPurchaseManager alloc] init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        _delegates = [NSPointerArray weakObjectsPointerArray];

    }
    return self;
}
- (UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelAlert;
    }
    return _window;
}
- (void)showPurchaseView{
    NSLog(@"window count before add : %ld",[UIApplication sharedApplication].windows.count);

    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[TEPurchaseDetailViewController alloc] init]];

}
- (void)hidePurchaseView{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window makeKeyWindow];
    [_window setHidden:YES];
    [_window removeFromSuperview];
    _window = nil;
    NSLog(@"window count when destroyed : %ld",[UIApplication sharedApplication].windows.count);
}
- (void)creatOrderWithGoods:(NSInteger)goods{
    [self hidePurchaseView];
    self.purchaseGoods = goods;
    for (id<TEPurchaseManagerDelegate> delegate in _delegates) {
        [delegate creatOrderWithGoods:goods];
    }
}
#pragma mark - add/remove delegate
-(void)dealloc
{
}

-(void)addDelegate:(id<TEPurchaseManagerDelegate>) delegate
{
    __weak typeof(id<TEPurchaseManagerDelegate>) weakDelegate = delegate;
    
    [_delegates addPointer:(__bridge void *)(weakDelegate)];
}

-(void)removeDelegate:(id<TEPurchaseManagerDelegate>) delegate
{
    int rIndex = -1;
    
    for (int index = 0; index < [_delegates count]; index++) {
        
        id<TEPurchaseManagerDelegate> pDelegate = [_delegates pointerAtIndex:index];
        
        if (pDelegate == nil) {
            
            rIndex = index;
            break;
            
        }
    }
    
    if (rIndex > -1) {
        [_delegates removePointerAtIndex:rIndex];
    }
    
}

@end
