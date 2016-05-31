//
//  GQMaskActivityView.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMaskActivityView.h"

@interface GQMaskActivityView()

@property (strong, nonatomic) IBOutlet UIView *bgMaskView;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *maskViewIndicator;
@property (strong, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation GQMaskActivityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _bgMaskView.layer.masksToBounds = YES;
    _bgMaskView.layer.cornerRadius = 5;
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
                         [self removeFromSuperview];
                     }];
}

- (IBAction)onCancelBtnTouched:(id)sender
{
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
}


@end
