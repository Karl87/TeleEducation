//
//  TEUserInfoAvatarCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/22.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEUserInfoAvatarCell.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"
#import "TEFileLocationHelper.h"
#import "UIImageView+WebCache.h"
#import "TELoginManager.h"
#import "TENetworkConfig.h"

@interface TEUserInfoAvatarCell ()
@property (nonatomic,strong) UIImageView *avatar;
@end

@implementation TEUserInfoAvatarCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatar = [UIImageView new];
        [_avatar setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_avatar];
    }
    return self;
}
- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;

    [_avatar sd_setImageWithURL:[NSURL URLWithString:[[TENetworkConfig sharedConfig].baseURL stringByAppendingString:[TELoginManager sharedManager].currentTEUser.avatar]]];
    
    //    NSString *fileName = [TEFileLocationHelper genFilenameWithExt:@"jpg"];
//    NSString *filePath = [[TEFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSLog(@"avatar image file exist");
//        UIImage *avatarImage = [UIImage imageWithContentsOfFile:filePath];
//        [_avatar setImage:avatarImage];
//    }else{
//        NSLog(@"avatar image file not exist");
//    }
}
#define AvatarRight 40
#define AvatarSize 44
- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatar.width = AvatarSize;
    self.avatar.height = AvatarSize;
    self.avatar.right   = self.width - AvatarRight;
    self.avatar.centerY = self.height * .5f;
    [self.avatar.layer setCornerRadius:AvatarSize/2];
    [self.avatar.layer setMasksToBounds:YES];
}
@end
