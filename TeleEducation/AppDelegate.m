//
//  AppDelegate.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "TEAppConfig.h"
#import "TECustomAttachmentDecoder.h"
#import "TEDataManager.h"

#import "TEViewManager.h"
#import "TELoginManager.h"

#import "UIImage+TEColor.h"

#import "YTKNetworkConfig.h"
#import "TENetworkConfig.h"

#import "TECellLayoutConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = [[TENetworkConfig sharedConfig] baseURL];
    config.cdnUrl = [[TENetworkConfig sharedConfig] cdnURL];
    
    
    NSString *NIMKey = [[TEAppConfig sharedConfig] NIMAppKey];
    NSString *cerName = [[TEAppConfig sharedConfig] NIMCerName];
    NSLog(@"%@,%@",NIMKey,cerName);
    [[NIMSDK sharedSDK] registerWithAppID:NIMKey cerName:cerName];
    
    [NIMCustomObject registerCustomDecoder:[[TECustomAttachmentDecoder alloc] init]];
    [[NIMKit sharedKit] registerLayoutConfig:[TECellLayoutConfig class]];
    [[NIMKit sharedKit] setProvider:[TEDataManager sharedManager]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [self setupMainViewController];
    
    return YES;
}

- (void)setupMainViewController{
    
    TELoginData *data = [[TELoginManager sharedManager] currentTEUser];
    if ([[data token]length]) {
        [[TELoginManager sharedManager] nimLogin];
        [[TEServiceManager sharedManger] start];

        [[TEViewManager sharedManager] setupMainTabbarController];
    }else{
        [[TEViewManager sharedManager] setupLoginViewController];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
