//
//  DGAlertTopView.m
//  DGAlertTopView
//
//  Created by Cody on 2017/11/27.
//  Copyright © 2017年 Cody. All rights reserved.
//

#define DGALERT_ICON_WIDTH_OR_HEIGHT  20.0f
#define DGRGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1];

#import "DGAlertTopView.h"

NSString * const DGSelfHeightConstraintIdentifier = @"DGSelfHeightConstraintIdentifier";

@interface DGAlertTopView()

@property (strong , nonatomic)UILabel *titleLabel;
@property (strong , nonatomic)UILabel *contentLabel;
@property (strong , nonatomic)UILabel *timeIcon;
@property (strong , nonatomic)UIButton *doneButton;
@property (strong , nonatomic)UIButton *cancelButton;

@property (strong , nonatomic)NSLayoutConstraint *oneselfTopConstraint;

@property (strong , nonatomic)NSTimer * timer;

@end

@implementation DGAlertTopView

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content doneTitle:(NSString *)doneTitle cancelTitle:(NSString *)cancelTitle{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.viewType = DGAlertTopViewTypeNone;
        _title = title;
        _content = content;
        self.titleLabel.text = title;
        self.contentLabel.text = content;
        [self.doneButton setTitle:doneTitle forState:UIControlStateNormal];
        [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        
        if ((!doneTitle && cancelTitle) || (doneTitle && !cancelTitle)) {//2个中存在一个
            self.cancelButton.hidden = YES;
        }else if (!doneTitle && !cancelTitle){
            self.cancelButton.hidden = YES;
            self.doneButton.hidden = YES;
        }
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];

    }
    
    return self;
}

#pragma mark - updateFrame
- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateOneSelfHeightConstranints];
}

- (void)updateFrame{
    [self addSelfConstraints];
    [self addTimeIconConstraint];
    [self addTitleLabelConstraint];
    [self addContentlabelConstraint];
    [self addBtnConstraint];
}

#pragma mark - get

- (CGFloat)oneselfHeight{
    CGFloat height;
    NSString * doneTitle = self.doneButton.titleLabel.text;
    NSString * cancelTitle = self.cancelButton.titleLabel.text;
    
    if (doneTitle.length>0 || cancelTitle.length>0) {
        height = self.doneButton.frame.origin.y + self.doneButton.frame.size.height + 11;
    }else{
        height = self.doneButton.frame.origin.y + 1;
    }
    return height;
}

- (UIWindow *)keyWindow{
    return [UIApplication sharedApplication].keyWindow;
}

- (UILabel *)timeIcon{
    if (!_timeIcon) {
        _timeIcon = [UILabel new];
        _timeIcon.layer.masksToBounds = YES;
        _timeIcon.hidden = YES;
        _timeIcon.layer.cornerRadius = DGALERT_ICON_WIDTH_OR_HEIGHT/2.0f;
        _timeIcon.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _timeIcon.textAlignment = NSTextAlignmentCenter;
        _timeIcon.textColor = [UIColor grayColor];
        _timeIcon.font = [UIFont systemFontOfSize:13];
        _timeIcon.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_timeIcon];
    }
    return _timeIcon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLabel.numberOfLines = 2;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(dismissCountdown:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.layer.cornerRadius = 4.0f;
        _doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _doneButton.layer.borderWidth = 1.0f;
        _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
        _doneButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneButton];
        
    }
    return _doneButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.cornerRadius = 4.0f;
        _cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _cancelButton.layer.borderWidth = 1.0f;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}


#pragma mark - set
- (void)setViewType:(DGAlertTopViewType)viewType{
    _viewType = viewType;
    switch (viewType) {
        case DGAlertTopViewTypeNone:
        {
            self.backgroundColor = DGRGB(0, 197, 205);
        }
            break;
        case DGAlertTopViewTypeSuccess:
        {
            self.backgroundColor = DGRGB(67, 205, 128);

        }
            break;
        case DGAlertTopViewTypeFail:
        {
            self.backgroundColor = DGRGB(238, 99, 99);
        }
            break;
        case DGAlertTopViewTypeWait:
        {
            self.backgroundColor = DGRGB(255, 130, 71);
        }
            break;

        default:
            break;
    }
    
    [self.doneButton setTitleColor:self.backgroundColor  forState:UIControlStateNormal];
}

- (void)setHidenCountdownDuration:(NSTimeInterval)hidenCountdownDuration{
    _hidenCountdownDuration = hidenCountdownDuration;
    self.timeIcon.text = [NSString stringWithFormat:@"%ld",(long)hidenCountdownDuration];
    [self.timer fire];
}


#pragma mark - action
- (void)panAction:(UIPanGestureRecognizer *)pan{
    static CGPoint beganPoint;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        beganPoint = self.frame.origin;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint changePoint = [pan translationInView:self.superview];
        CGPoint point = CGPointMake(beganPoint.x, beganPoint.y + changePoint.y);
        if (point.y>0)point.y = 0;

        self.oneselfTopConstraint.constant = point.y;
        
    }else if (pan.state == UIGestureRecognizerStateEnded||
              pan.state == UIGestureRecognizerStateCancelled||
              pan.state == UIGestureRecognizerStateFailed){
        
        CGFloat endY = [pan velocityInView:self].y;
        if (endY <0) {
            [self dismissAnimation:YES];
        }else{
            [self reviewAnimation:@(YES)];
        }
    }
}

- (void)dismissCountdown:(NSTimer *)timer{
    if (self.hidenCountdownDuration <0) {
        [self dismissAnimation:YES];
        return;
    }
    self.timeIcon.hidden = self.hidenTimeIcon;
    self.timeIcon.text = [NSString stringWithFormat:@"%ld",(long)self.hidenCountdownDuration];
    
    _hidenCountdownDuration --;
}

- (void)cancelAction:(UIButton *)sender{
    [self dismissAnimation:YES];
    if ([self.delegate respondsToSelector:@selector(deSelectedCancelWithAlertTopView:)]) {
        [self.delegate deSelectedCancelWithAlertTopView:self];
    }
}

- (void)doneAction:(UIButton *)sender{
    [self dismissAnimation:YES];
    if ([self.delegate respondsToSelector:@selector(deSelectedDoneWithAlertTopView:)]) {
        [self.delegate deSelectedDoneWithAlertTopView:self];
    }
}

#pragma mark - public
- (void)showAnimation:(BOOL)animation{
    [self.keyWindow addSubview:self];
    self.keyWindow.windowLevel = UIWindowLevelAlert;

    [self updateFrame];
    
    [self performSelector:@selector(reviewAnimation:) withObject:@(animation) afterDelay:0.01];
}

- (void)showAnimation:(BOOL)animation duration:(NSTimeInterval)duration{
    [self showAnimation:animation];
    
    _hidenCountdownDuration = duration;
    [self.timer fire];
}


//显示恢复动画
- (void)reviewAnimation:(NSNumber *)animation{
    
    if (animation.boolValue) {
        [UIView animateWithDuration:0.3 animations:^{
            self.oneselfTopConstraint.constant = 0;
            [self.superview layoutIfNeeded];
        }];
    }else{
        self.oneselfTopConstraint.constant = 0;
    }
}

- (void)dismissAnimation:(BOOL)animation{
    [self.timer invalidate];
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.oneselfTopConstraint.constant = -self.bounds.size.height;
            [self.superview layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            BOOL isContain = NO;
            for (UIView * subView in self.keyWindow.subviews) {
                if ([subView isKindOfClass:[self class]]) {
                    isContain = YES;
                    break;
                }
            }
            if (!isContain)self.keyWindow.windowLevel = UIWindowLevelNormal;
        }];
        
    }else{
        
        [self removeFromSuperview];
        BOOL isContain = NO;
        for (UIView * subView in self.keyWindow.subviews) {
            if ([subView isKindOfClass:[self class]]) {
                isContain = YES;
                break;
            }
        }
       if (!isContain)self.keyWindow.windowLevel = UIWindowLevelNormal;

    }
}


+ (DGAlertTopView *)showTitleOnly:(NSString *)title content:(NSString *)content duration:(NSTimeInterval)duration{
    DGAlertTopView * topView = [[DGAlertTopView alloc] initWithTitle:title content:content doneTitle:nil cancelTitle:nil];
    [topView showAnimation:YES];
    topView.hidenCountdownDuration = duration;
    return topView;
}

#pragma mark - autoLayout
//更新高度
- (void)updateOneSelfHeightConstranints{
    for (NSLayoutConstraint * constraint in self.constraints) {
        if ([constraint.identifier isEqualToString:DGSelfHeightConstraintIdentifier]) {
            [self removeConstraint:constraint];
            break;
        }
    }
    
    NSLayoutConstraint * heightConstraint  = [NSLayoutConstraint constraintWithItem:self
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:kNilOptions
                                                                         multiplier:1.0f
                                                                           constant:self.oneselfHeight];
    heightConstraint.identifier = DGSelfHeightConstraintIdentifier;
    [self addConstraint:heightConstraint];

}


- (void)addSelfConstraints{
    NSLayoutConstraint * leftConstraint  = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.keyWindow
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f
                                                                         constant:0];
    [self.keyWindow addConstraint:leftConstraint];

    NSLayoutConstraint * rightConstraint  = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.keyWindow
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0f
                                                                          constant:0];
    [self.keyWindow addConstraint:rightConstraint];
    
    NSLayoutConstraint * topConstraint  = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.keyWindow
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0f
                                                                          constant:-130];
    self.oneselfTopConstraint = topConstraint;
    [self.keyWindow addConstraint:topConstraint];

    NSLayoutConstraint * heightConstraint  = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:kNilOptions
                                                                        multiplier:1.0f
                                                                          constant:130];
    heightConstraint.identifier = DGSelfHeightConstraintIdentifier;
    
    [self addConstraint:heightConstraint];
}

- (void)addTimeIconConstraint{
    NSLayoutConstraint * topConstraint  = [NSLayoutConstraint constraintWithItem:self.timeIcon
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0f
                                                                        constant:5];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint * rightConstraint  = [NSLayoutConstraint constraintWithItem:self.timeIcon
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0f
                                                                        constant:-10];
    [self addConstraint:rightConstraint];

    
    NSLayoutConstraint * widthConstraint  = [NSLayoutConstraint constraintWithItem:self.timeIcon
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:kNilOptions
                                                                        multiplier:1.0f
                                                                          constant:DGALERT_ICON_WIDTH_OR_HEIGHT];
    [self.timeIcon addConstraint:widthConstraint];
    
    NSLayoutConstraint * heightConstraint  = [NSLayoutConstraint constraintWithItem:self.timeIcon
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:kNilOptions
                                                                        multiplier:1.0f
                                                                          constant:DGALERT_ICON_WIDTH_OR_HEIGHT];
    [self.timeIcon addConstraint:heightConstraint];
}

- (void)addTitleLabelConstraint{
    NSLayoutConstraint * topConstraint  = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0f
                                                                        constant:11];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint * leftConstraint  = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0f
                                                                          constant:10];
    [self addConstraint:leftConstraint];
    
    
    NSLayoutConstraint * maxWidthConstraint  = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                                                           toItem:nil
                                                                        attribute:kNilOptions
                                                                       multiplier:1.0f
                                                                         constant:[UIScreen mainScreen].bounds.size.width - 80];
    [self.titleLabel addConstraint:maxWidthConstraint];

}

- (void)addContentlabelConstraint{
    NSLayoutConstraint * topConstraint  = [NSLayoutConstraint constraintWithItem:self.contentLabel
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.titleLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:self.title? 6:0];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint * leftConstraint  = [NSLayoutConstraint constraintWithItem:self.contentLabel
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f
                                                                         constant:10];
    [self addConstraint:leftConstraint];
    
    
    NSLayoutConstraint * maxWidthConstraint  = [NSLayoutConstraint constraintWithItem:self.contentLabel
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:nil
                                                                            attribute:kNilOptions
                                                                           multiplier:1.0f
                                                                             constant:[UIScreen mainScreen].bounds.size.width - 20];
    [self.contentLabel addConstraint:maxWidthConstraint];
    
}

- (void)addBtnConstraint{
    
    //取消按钮
    NSLayoutConstraint * topConstraint  = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.contentLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:11];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint * leftConstraint  = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f
                                                                         constant:10];
    [self addConstraint:leftConstraint];
    
    
    NSLayoutConstraint * widthConstraint  = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:kNilOptions
                                                                        multiplier:1.0f
                                                                          constant:([UIScreen mainScreen].bounds.size.width-60)/2.0f];
    [self.cancelButton addConstraint:widthConstraint];
    
    
    NSLayoutConstraint * heightConstraint  = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:kNilOptions
                                                                         multiplier:1.0f
                                                                           constant:30];
    [self.cancelButton addConstraint:heightConstraint];
    
    //确认按钮
    NSLayoutConstraint * topConstraint1  = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:11];
    [self addConstraint:topConstraint1];
    
    NSLayoutConstraint * rightConstraint1  = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0f
                                                                           constant:-10];
    [self addConstraint:rightConstraint1];
    
    
    NSLayoutConstraint * widthConstraint1  = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:kNilOptions
                                                                         multiplier:1.0f
                                                                           constant:([UIScreen mainScreen].bounds.size.width-60)/2.0f];
    [self.doneButton addConstraint:widthConstraint1];
    
    
    NSLayoutConstraint * heightConstraint1  = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:kNilOptions
                                                                          multiplier:1.0f
                                                                            constant:30];
    [self.doneButton addConstraint:heightConstraint1];
}

#pragma mark -dealloc
- (void)dealloc{
    
}

@end
