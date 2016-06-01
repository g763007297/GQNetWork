//
//  GQMappingUtilities.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GQPropertyMapping;

BOOL CheckTypeMatching(id *valueObject, Class objClass, GQPropertyMapping *propertyMapping);
