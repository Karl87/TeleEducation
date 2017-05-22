//
//  TEUploadAvatarApi.m
//  TeleEducation
//
//  Created by Karl on 2017/5/17.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEUploadAvatarApi.h"
#import "AFNetworking.h"

#define URL @"/App/Course/UploadUserAvatar.html"


@implementation TEUploadAvatarApi{
    NSString *_token;
    TEUserType _userType;
    UIImage *_image;
}

- (id)initWithToken:(NSString *)token userType:(TEUserType)userType image:(UIImage *)image {
    self = [super init];
    if (self) {
        _token = token;
        _userType = userType;
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return URL;
}
- (id)requestArgument{
    return @{
             @"token":_token,
             @"type":@(_userType)
             };
}
- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.6);
        NSString *name = @"avatar.jpg";
        NSString *formKey = @"photo";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

//- (id)jsonValidator {
//    return @{ @"imageId": [NSString class] };
//}
//
//- (NSString *)responseImageId {
//    NSDictionary *dict = self.responseJSONObject;
//    return dict[@"imageId"];
//}

@end
