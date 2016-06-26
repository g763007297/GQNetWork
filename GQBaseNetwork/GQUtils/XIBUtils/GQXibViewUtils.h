//
//  GQXibViewUtils.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQXibViewUtils : NSObject

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;

//  the view must not have any connecting to the file owner
+ (id)loadViewFromXibNamed:(NSString*)xibName;

@end
