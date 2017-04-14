//
//  TEMessagesViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMessagesViewController.h"

@interface TEMessagesViewController ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNav{
    [super configNav];
}



@end
