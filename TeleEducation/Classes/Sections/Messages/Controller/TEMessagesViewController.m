//
//  TEMessagesViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMessagesViewController.h"

@interface TEMessagesViewController ()
@property (nonatomic,strong) UILabel *emptyDataLab;
@end

@implementation TEMessagesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.emptyDataLab = [[UILabel alloc] initWithFrame:self.view.bounds];
    [self.emptyDataLab setFont:[UIFont systemFontOfSize:17.0]];
    [self.emptyDataLab setText:@"目前没有消息"];
    [self.view addSubview:self.emptyDataLab];
    [self.emptyDataLab setTextAlignment:NSTextAlignmentCenter];
    [self.emptyDataLab setNumberOfLines:0];
    [self.emptyDataLab setTextColor:SystemBlueColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNav{
    [super configNav];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _emptyDataLab.left = 0;
    _emptyDataLab.top = 0;
    _emptyDataLab.width = self.view.width;
    _emptyDataLab.height = self.view.height;
}


@end
