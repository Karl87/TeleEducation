//
//  TELocationPoint.h
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TELocationPoint : NSObject<MKAnnotation>
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,readonly,copy) NSString *title;

- (instancetype) initWithLocationObject:(NIMLocationObject *)locationObject;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title;
@end
