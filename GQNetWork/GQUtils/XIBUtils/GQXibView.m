//
//  GQXibView.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQXibView.h"
#import "GQXibViewUtils.h"
#import "GQDebug.h"

@implementation GQXibView

- (void)dealloc
{
    GQDINFO(@"%@ is dealloced!", [self class]);
}

+ (id)loadFromXib
{
    return [GQXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

@end
