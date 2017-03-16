//
//  TELocationPoint.m
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELocationPoint.h"

@implementation TELocationPoint

- (instancetype) initWithLocationObject:(NIMLocationObject *)locationObject{
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = locationObject.longitude;
        coordinate.latitude = locationObject.latitude;
        _coordinate = coordinate;
        _title = locationObject.title;
    }
    return self;
}


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
    }
    return self;
}
@end
