//
//  TESettingSwitchCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/22.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESettingSwitchCell.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"

@interface TESettingSwitchCell ()
@property (nonatomic,strong) UISwitch *switcher;
@end

@implementation TESettingSwitchCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _switcher = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switcher setOnTintColor:SystemBlueColor];
        [self addSubview:_switcher];
    }
    return self;
}

- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text = rowData.title;
//    self.textLabel.textColor = [UIColor lightGrayColor];
    self.detailTextLabel.text = rowData.detailTitle;
    NSString *actionName = rowData.cellActionName;
    [self.switcher setOn:[rowData.extraInfo boolValue] animated:NO];
    [self.switcher removeTarget:self.viewController action:NULL forControlEvents:UIControlEventValueChanged];
    if (actionName.length) {
        SEL sel = NSSelectorFromString(actionName);
        [self.switcher addTarget:tableView.viewController action:sel forControlEvents:UIControlEventValueChanged];
    }
}

#define SwitcherRight 15
- (void)layoutSubviews{
    [super layoutSubviews];
    self.switcher.right   = self.width - SwitcherRight;
    self.switcher.centerY = self.height * .5f;
}

@end
