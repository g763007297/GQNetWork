//
//  GQDataEnvironment.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQDataEnvironment : NSObject{
    NSString *_urlRequestHost;
}

@property (nonatomic,strong) NSString *urlRequestHost;

+ (GQDataEnvironment *)sharedDataEnvironment;

- (void)clearNetworkData;
- (void)clearCacheData;

@end
