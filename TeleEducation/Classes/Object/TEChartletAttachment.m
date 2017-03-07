//
//  TEChartletAttachment.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChartletAttachment.h"
#import "TESessionUtil.h"
#import "UIImage+TE.h"

@implementation TEChartletAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeChartlet),
                           CMData : @{ CMCatalog : self.chartletCatalog? self.chartletCatalog : @"",
                                       CMChartlet : self.chartletID?self.chartletID : @""
                                       }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (NSString *)cellContent:(NIMMessage *)message{
    return @"TESessionChartletContentView";
}

- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width{
    if (!self.showCoverImage) {
        UIImage *image = [UIImage fetchChartlet:self.chartletID chartletId:self.chartletCatalog];
        self.showCoverImage = image;
    }
    return self.showCoverImage.size;
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    CGFloat bubblePaddingForImage    = 3.f;
    CGFloat bubbleArrowWidthForImage = 5.f;
    if (message.isOutgoingMsg) {
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage);
    }else{
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage, bubblePaddingForImage,bubblePaddingForImage);
    }
}

@end
