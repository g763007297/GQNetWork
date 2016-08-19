//
//  GQMaskActivityView.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMaskActivityView.h"

@interface GQMaskActivityView()

@property (strong, nonatomic) UIView *bgMaskView;
@property (strong, nonatomic) UILabel *hintLabel;
@property (strong, nonatomic) UIActivityIndicatorView *maskViewIndicator;
@property (strong, nonatomic) UIButton *cancleBtn;

@end

@implementation GQMaskActivityView

+ (instancetype)loadView{
    return [[[self class] alloc] init];
}

- (instancetype)init{
    self =  [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 154, 110);
        [self addSubview:self.bgMaskView];
       
        [_bgMaskView addSubview:self.hintLabel];
        
        [_bgMaskView addSubview:self.maskViewIndicator];
        
        [_bgMaskView addSubview:self.cancleBtn];
    }
    return self;
}

- (UIView*)keyboardView
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])
    {
        for (UIView *view in [window subviews])
        {
            // UIPeripheralHostView is used from iOS 4.0, UIKeyboard was used in previous versions:
            if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard"))
            {
                return view;
            }
        }
    }
    return nil;
}

- (UIView*)viewForView:(UIView *)view
{
    UIView *keyboardView = [self keyboardView];
    if (keyboardView) {
        view = keyboardView.superview;
    }
    return view;
}

- (void)showInView:(UIView*)parentView
{
    [self showInView:parentView withHintMessage:nil onCancleRequest:nil];
}

- (void)showInView:(UIView *)view withHintMessage:(NSString *)message
{
    [self showInView:view withHintMessage:message onCancleRequest:nil];
}

- (void)showInView:(UIView *)view withHintMessage:(NSString *)message
   onCancleRequest:(void (^)(GQMaskActivityView *))onCanceledBlock
{
    if (onCanceledBlock) {
        _onRequestCanceled = [onCanceledBlock copy];
    }
    UIView *superView = [self viewForView:view];
    [superView addSubview:self];
    
    CGPoint origin = CGPointMake((CGRectGetWidth(superView.bounds) - CGRectGetWidth(self.bounds))/2, (CGRectGetHeight(superView.bounds) - CGRectGetHeight(self.bounds))/2);
    CGRect frame = self.bounds;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
    
    _hintLabel.hidden = NO;
    _hintLabel.text = message;
    self.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         //
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_maskViewIndicator stopAnimating];
                         [self removeFromSuperview];
                     }];
}

- (void)onCancelBtnTouched:(id)sender
{
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
}

- (UIView *)bgMaskView
{
    if (!_bgMaskView) {
        _bgMaskView = [[UIView alloc] initWithFrame:self.bounds];
        _bgMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6666];
        _bgMaskView.layer.masksToBounds = YES;
        _bgMaskView.layer.cornerRadius = 5;
    }
    return _bgMaskView;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 154, 35)];
        _hintLabel.font = [UIFont systemFontOfSize:17];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.backgroundColor = [UIColor clearColor];
        _hintLabel.hidden = YES;
    }
    return _hintLabel;
}

- (UIActivityIndicatorView *)maskViewIndicator
{
    if (!_maskViewIndicator) {
        _maskViewIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(67, 45, 20, 20)];
        _maskViewIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [_maskViewIndicator startAnimating];
    }
    return _maskViewIndicator;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _cancleBtn.frame = CGRectMake(0, 72, 154, 40);
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(onCancelBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

@end
