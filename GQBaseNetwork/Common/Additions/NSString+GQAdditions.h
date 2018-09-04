//
//  NSString+GQAdditions.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GQAdditions)

- (BOOL)isStartWithString:(NSString*)start;
- (BOOL)isEndWithString:(NSString*)end;

- (NSString*)encodeUrl;

@end
