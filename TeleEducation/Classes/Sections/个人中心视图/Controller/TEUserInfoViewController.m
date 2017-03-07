//
//  TEUserInfoViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/22.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEUserInfoViewController.h"
#import "NIMCommonTableData.h"
#import "NIMCommonTableDelegate.h"
#import "UIView+TE.h"
#import "UIActionSheet+TEBlock.h"
#import "UIImage+TE.h"
#import "TEFileLocationHelper.h"

@interface TEUserInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NIMCommonTableDelegate *delegator;
@end

@implementation TEUserInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configStatusBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改资料";
    
    [self buildData];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNav{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)configStatusBar{
    [self setNeedsStatusBarAppearanceUpdate];
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:YES];
}
#pragma mark - Private

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -

- (void)buildData{
    NSArray *data = @[
                      @{
                          RowContent :@[
                                  @{
                                      Title      :@"头像",
                                      CellClass     : @"TEUserInfoAvatarCell",
                                      CellAction :@"onTouchChangeUserAvatar:",
                                      ShowAccessory : @(YES),
                                      RowHeight     : @(60)
                                      },
                                  @{
                                      Title      :@"姓名",
                                      DetailTitle:@"JENNY",
                                      CellAction :@"onTouchChangeUserName:",
                                      ShowAccessory : @(YES),
                                      RowHeight     : @(60)
                                      },
                                  @{
                                      Title      :@"绑定手机",
                                      DetailTitle:@"13567890214",
                                      CellAction :@"onTouchChangeUserMobile:",
                                      ShowAccessory : @(YES),
                                      RowHeight     : @(60)
                                      },
                                  @{
                                      Title      :@"QQ",
                                      DetailTitle:@"1234567890",
                                      CellAction :@"onTouchChangeUserQQ:",
                                      ShowAccessory : @(YES),
                                      RowHeight     : @(60)
                                      },
                                  @{
                                      Title      :@"Skype",
                                      DetailTitle:@"0987654321",
                                      CellAction :@"onTouchChangeUserSkype:",
                                      ShowAccessory : @(YES),
                                      RowHeight     : @(60)
                                      }
                                  ],
                          FooterTitle:@"* 修改绑定手机后请使用新号码登录"
                          }
    ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)refreshData{
    [self buildData];
    [self.tableView reloadData];
}
#pragma mark - Action

- (void)onTouchChangeUserAvatar:(id)sender{
    NSLog(@"avatar");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册", nil];
        [sheet showInView:self.view completionHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:
                    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                default:
                    break;
            }
        }];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册", nil];
        [sheet showInView:self.view completionHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                default:
                    break;
            }
        }];
    }

}
- (void)onTouchChangeUserName:(id)sender{
    NSLog(@"username");
}
- (void)onTouchChangeUserMobile:(id)sender{
    NSLog(@"usermobile");
}
- (void)onTouchChangeUserQQ:(id)sender{
    NSLog(@"userqq");
}
- (void)onTouchChangeUserSkype:(id)sender{
    NSLog(@"userskype");
}
#pragma avatarmethod
- (void)showImagePicker:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate      = self;
    picker.sourceType    = type;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma uiimagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Private
- (void)uploadImage:(UIImage *)image{
    UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
    NSString *fileName = [TEFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[TEFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    __weak typeof(self) wself = self;
    if (success) {
        [wself refreshData];
    }
}
#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.tableView.left = 0;
    self.tableView.top = 0;
    self.tableView.width = self.view.width;
    self.tableView.height = self.view.height;
    [self.tableView reloadData];
}

@end
