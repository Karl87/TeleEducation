//
//  UIScrollView+TEPullToRefresh.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TEPullToRefreshView;

@interface UIScrollView (TEPullToRefresh)
typedef NS_ENUM(NSUInteger, TEPullToRefreshPosition) {
    TEPullToRefreshPositionTop = 0,
    TEPullToRefreshPositionBottom,
};

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(TEPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) TEPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end



typedef NS_ENUM(NSUInteger,TEPullToRefreshState) {
    TEPullToRefreshStateStopped = 0,
    TEPullToRefreshStateTriggered,
    TEPullToRefreshStateLoading,
    TEPullToRefreshStateAll = 10
};

@interface TEPullToRefreshView : UIView
@property (nonatomic,strong) UIColor *arrowColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) TEPullToRefreshState state;
@property (nonatomic, readonly) TEPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(TEPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(TEPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(TEPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

@end

