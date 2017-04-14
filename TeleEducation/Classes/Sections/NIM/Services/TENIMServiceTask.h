//
//  TEServiceTask.h
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TENIMServiceTask <NSObject>
- (NSURLRequest *)taskRequest;
- (void)onGetResponse:(id)jsonObject error:(NSError*)error;
@end
