//
//  TEDataManager.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEDataManager.h"
#import "NIMKitInfoFetchOption.h"
#import "TEMeetingManager.h"

@interface TEDataRequestArray : NSObject
@property (nonatomic,assign) NSInteger maxMergeCount;//最大合并数
- (void)requestUserIDs:(NSArray *)userIDs;
@end

@interface TEDataManager ()
@property (nonatomic,strong) TEDataRequestArray *requestArray;
@end

@implementation TEDataManager
+(instancetype)sharedManager{
    static TEDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TEDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _defaultUserAvatar  = [UIImage imageNamed:@"avatar_user"];
        _defaultTeamAvatar  = [UIImage imageNamed:@"avatar_team"];
        _requestArray = [[TEDataRequestArray alloc] init];
        _requestArray.maxMergeCount = 20;
    }
    return self;
}

- (NSString *)nickName:(NIMUser *)user
            memberInfo:(NIMTeamMember *)memberInfo{
    NSString *name = nil;
    do{
        if ([user.alias length]) {
            name = user.alias;
            break;
        }
        if (memberInfo && [memberInfo.nickname length]) {
            name = memberInfo.nickname;
            break;
        }
        if ([user.userInfo.nickName length]) {
            name = user.userInfo.nickName;
            break;
        }
    }while (0);
    return name;
}

- (NIMKitInfo *)infoByTeam:(NSString *)teamId option:(NIMKitInfoFetchOption *)option{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager
                     teamById:teamId];
    NIMKitInfo *info = [[NIMKitInfo alloc] init];
    info.showName = team.teamName;
    info.infoId = teamId;
    info.avatarImage = self.defaultTeamAvatar;
    return info;
}

- (NIMKitInfo *)infoByUser:(NSString *)userId option:(NIMKitInfoFetchOption *)option{
    BOOL needFetchInfo = NO;
    NIMSessionType sessionType = option.session.sessionType;
    NIMKitInfo *info = [[NIMKitInfo alloc] init];
    info.infoId = userId;
    info.showName = userId;
    if (sessionType == NIMSessionTypeP2P || sessionType == NIMSessionTypeTeam) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
        NIMUserInfo *userInfo = user.userInfo;
        NIMTeamMember *member = nil;
        if (sessionType == NIMSessionTypeTeam) {
            member = [[NIMSDK sharedSDK].teamManager teamMember:userId inTeam:option.session.sessionId];
        }
        NSString *name = [self nickName:user
                             memberInfo:member];
        if (name) {
            info.showName = name;
        }
        info.avatarUrlString = userInfo.thumbAvatarUrl;
        info.avatarImage = self.defaultUserAvatar;
        
        if (userInfo == nil) {
            needFetchInfo = YES;
        }
        if (needFetchInfo) {
            [self.requestArray requestUserIDs:@[userId]];
        }
        return info;
    }else if (sessionType == NIMSessionTypeChatroom){
        if ([userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            NIMChatroomMember *member = [[TEMeetingManager sharedService] myInfo:option.session.sessionId];
            info.showName = member.roomNickname;
            info.avatarUrlString = member.roomAvatar;
            
        }else{
            NIMMessageChatroomExtension *ext = [option.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ? (NIMMessageChatroomExtension *)option.message.messageExt : nil;
            info.showName = ext.roomNickname;
            info.avatarUrlString = ext.roomAvatar;
        }
        info.avatarImage = self.defaultUserAvatar;
        return info;
    }else{
        return nil;//[self infoByUser:userId inSession:option.message.session];
    }
}

//- (NIMKitInfo *)infoByUser:(NSString *)userId
//                 inSession:(NIMSession *)session{
//    BOOL needFetchInfo = NO;
//    NIMSessionType sessionType = session.sessionType;
//    NIMKitInfo *info = [[NIMKitInfo alloc] init];
//    info.infoId = userId;
//    info.showName = userId;
//    switch (sessionType) {
//        case NIMSessionTypeP2P:
//        case NIMSessionTypeTeam:
//        {
//            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
//            NIMUserInfo *userInfo = user.userInfo;
//            NIMTeamMember *member = nil;
//            if (sessionType == NIMSessionTypeTeam) {
//                member = [[NIMSDK sharedSDK].teamManager teamMember:userId inTeam:session.sessionId];
//            }
//            NSString *name = [self nickName:user
//                                 memberInfo:member];
//            if (name) {
//                info.showName = name;
//            }
//            info.avatarUrlString = userInfo.thumbAvatarUrl;
//            info.avatarImage = self.defaultUserAvatar;
//            
//            if (userInfo == nil) {
//                needFetchInfo = YES;
//            }
//        }
//            break;
//            case NIMSessionTypeChatroom:
//            NSAssert(0, @"invalid type"); //聊天室的Info不会通过这个回调请求
//            break;
//        default:
//            NSAssert(0, @"invalid type");
//            break;
//    }
//    if (needFetchInfo) {
//        [self.requestArray requestUserIDs:@[userId]];
//    }
//    return info;
//}
@end

@implementation TEDataRequestArray{
    NSMutableArray *_requestUsrIdsArray;
    BOOL _isRequesting;
}

- (instancetype) init{
    self = [super init];
    if (self) {
        _requestUsrIdsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)requestUserIDs:(NSArray *)userIDs{
    for (NSString *userID in userIDs) {
        if (![_requestUsrIdsArray containsObject:userID]) {
            [_requestUsrIdsArray addObject:userID];
            NSLog(@"需要请求用户信息，%@",userID);
        }
        [self request];
    }
}
-(void)request{
    static NSUInteger MaxBatchRequestCount = 10;
    if (_isRequesting || [_requestUsrIdsArray count]==0) {
        return;
    }
    _isRequesting = YES;
    NSArray *userIDs = [_requestUsrIdsArray count]>MaxBatchRequestCount?[_requestUsrIdsArray subarrayWithRange:NSMakeRange(0,MaxBatchRequestCount)]:[_requestUsrIdsArray copy];
    
    NSLog(@"请求用户信息数组：%@",userIDs);
    __weak typeof(self) ws = self;
    
    [[NIMSDK sharedSDK].userManager fetchUserInfos:userIDs completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        [ws afterRequest:userIDs];
        if (!error) {
            [[NIMKit sharedKit] notifyTeamInfoChanged:userIDs];
        }
    }];
}
- (void)afterRequest:(NSArray *)userIDs{
    _isRequesting = NO;
    [_requestUsrIdsArray removeObjectsInArray:userIDs];
    [self request];
}
@end
