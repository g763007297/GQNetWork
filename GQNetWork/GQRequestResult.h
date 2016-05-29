//
//  GQRequestResult.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseModelObject.h"

@interface GQRequestResult : NSObject

@property (nonatomic,strong) NSNumber *code;
@property (nonatomic,strong) NSString *message;

- (id)initWithCode:(NSString*)code withMessage:(NSString*)message;
- (BOOL)isSuccess;
- (void)showErrorMessage;

@end
