//
//  TEPasswordCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/22.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPasswordCell.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"
#import "UIImage+TEColor.h"

@interface TEPasswordCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *textField;
//@property (nonatomic,strong) UIButton *showTextBtn;
@end
@implementation TEPasswordCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textField setBorderStyle:UITextBorderStyleNone];
        [_textField setKeyboardType:UIKeyboardTypeDefault];
//        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_textField setSecureTextEntry:YES];
        _textField.delegate = self;
        
        [self addSubview:_textField];
        UIButton *showTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [showTextBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
        [showTextBtn addTarget:self action:@selector(showTextBtnActionHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_textField setRightView:showTextBtn];
        [_textField setRightViewMode:UITextFieldViewModeNever];
    }
    return self;
}
- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    
    NSDictionary *dic = rowData.extraInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [_textField setPlaceholder:dic[@"placeHolder"]];
        if ([dic[@"showRightView"] boolValue]) {
            [_textField setRightViewMode:UITextFieldViewModeAlways];
        }
        if (![dic[@"isSecurty"]boolValue]) {
            [_textField setSecureTextEntry:NO];
        }
    }
}
#define Margine 20
- (void)layoutSubviews{
    [super layoutSubviews];
    _textField.top = 0;
    _textField.left = Margine;
    _textField.width = self.width-2*Margine;
    _textField.height = self.height;
}
- (void)showTextBtnActionHandler:(id)sender{
    [_textField setSecureTextEntry:!_textField.secureTextEntry];
}
@end
