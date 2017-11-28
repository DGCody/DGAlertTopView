//
//  DGAlertTopView.h
//  DGAlertTopView
//
//  Created by Cody on 2017/11/27.
//  Copyright © 2017年 Cody. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DGAlertTopView;

@protocol DGAlertTopViewDelegate <NSObject>

@optional
- (void)deSelectedCancelWithAlertTopView:(DGAlertTopView *)topView;
- (void)deSelectedDoneWithAlertTopView:(DGAlertTopView *)topView;

@end

extern NSString * const DGSelfHeightConstraintIdentifier;

typedef NS_ENUM(NSUInteger, DGAlertTopViewType) {
    DGAlertTopViewTypeNone,     //默认
    DGAlertTopViewTypeSuccess,  //成功
    DGAlertTopViewTypeFail,     //失败
    DGAlertTopViewTypeWait      //警告
};

@interface DGAlertTopView : UIView

@property (copy , nonatomic ,readonly)NSString * title;
@property (copy , nonatomic ,readonly)NSString * content;

@property (assign , nonatomic)NSTimeInterval hidenCountdownDuration;
@property (assign , nonatomic)BOOL showCountdownIcon;
@property (assign , nonatomic)DGAlertTopViewType viewType;
@property (weak , nonatomic)id <DGAlertTopViewDelegate>delegate;
@property (assign , nonatomic)BOOL hidenTimeIcon;


- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content doneTitle:(NSString *)doneTitle cancelTitle:(NSString *)cancelTitle;


- (void)showAnimation:(BOOL)animation;
- (void)showAnimation:(BOOL)animation duration:(NSTimeInterval)duration;
- (void)dismissAnimation:(BOOL)animation;


+ (DGAlertTopView *)showTitleOnly:(NSString *)title content:(NSString *)content duration:(NSTimeInterval)duration;


@end
