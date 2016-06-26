//
//  GQMaskActivityView.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQXibView.h"

@interface GQMaskActivityView : GQXibView
{
    void (^_onRequestCanceled)(GQMaskActivityView *);
}

- (void)showInView:(UIView*)view;
- (void)showInView:(UIView *)view withHintMessage:(NSString *)message;
- (void)showInView:(UIView *)view withHintMessage:(NSString *)message
   onCancleRequest:(void(^)(GQMaskActivityView *view))onCanceledBlock;

- (void)hide;

@end
