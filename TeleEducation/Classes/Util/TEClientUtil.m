//
//  TEClientUtil.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEClientUtil.h"

@implementation TEClientUtil
+ (NSString *)clientName:(NIMLoginClientType)clientType{
    switch (clientType) {
        case NIMLoginClientTypeAOS:
        case NIMLoginClientTypeiOS:
            return @"移动端";
        case NIMLoginClientTypePC:
            return @"PC";
        case NIMLoginClientTypeWeb:
            return @"Web";
        default:
            return @"";
    }
}
@end
