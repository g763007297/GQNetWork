//
//  GQCommonMacros.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef iTotemFrame_GQCommonMacros_h
#define iTotemFrame_GQCommonMacros_h
////////////////////////////////////////////////////////////////////////////////
#pragma mark --  defualt configure

#define GQUSE_MaskView 0    //是否使用加载中视图

#define GQUSE_DUMPY_DATA	0   //是否使用假数据

#define REQUEST_HOST @"123.57.81.80" // 默认host

#define GQHttpReuqestURL @"http://123.57.81.80:3001/"

#define DEFAULT_LOADING_MESSAGE  @"正在加载..."   //正在加载maskview显示的默认文字

#define SHOULDOVERRIDE(basename, subclassname){ NSAssert([basename isEqualToString:subclassname], @"subclass should override the method!");}

////////////////////////////////////////////////////////////////////////////////

#pragma mark - shortcuts

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DATA_ENV [GQDataEnvironment sharedDataEnvironment]

////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

////////////////////////////////////////////////////////////////////////////////
#pragma mark - degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)

////////////////////////////////////////////////////////////////////////////////

#endif /* GQCommonMacros_h */
