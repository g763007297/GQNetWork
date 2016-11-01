//
//  GQRequestDataHandler.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQRequestDataHandler : NSObject

- (id)parseDataString:(NSString *)resultString error:(NSError **)error;

@end
