//
//  TENIMRegisterTask.h
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENIMServiceTask.h"

typedef void(^TENIMRegisterHandler) (NSError *error,NSString *errorMsg);

@interface TENIMRegisterData : NSObject
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *nickname;
@end


@interface TENIMRegisterTask : NSObject<TENIMServiceTask>

@property (nonatomic,strong) TENIMRegisterData *data;
@property (nonatomic,copy) TENIMRegisterHandler handler;

@end
