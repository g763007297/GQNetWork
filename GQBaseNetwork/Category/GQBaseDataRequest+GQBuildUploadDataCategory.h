//
//  GQBaseDataRequest+GQBuildUploadDataCategory.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/9.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest.h"

@interface GQBaseDataRequest (GQBuildUploadDataCategory)

/**
 *  创建上传文件字典
 *
 *  param data             上传文件
 *  param fileName         文件名     可为nil，默认为file
 *  param contentType      mimeType    可为nil，默认为application/octet-stream
 *  param key              key
 *
 *  @return NSDictionary *
 */
+ (NSDictionary *)buildUploadData:(id)data
                     withFileName:(NSString *)fileName
                   andContentType:(NSString *)contentType
                           forKey:(NSString *)key;

/**
 *  创建上传文件字典
 *
 *  param filePath         文件地址    不可为空
 *  param fileName         文件名   可为nil，默认为文件地址的lastPathComponent
 *  param contentType      mimeType  可为nil，默认为文件的默认minetype
 *  param key              key     不可为空
 *
 *  @return NSDictionary *
 */
+ (NSDictionary *)buildUploadFile:(NSString *)filePath
                     withFileName:(NSString *)fileName
                   andContentType:(NSString *)contentType
                           forKey:(NSString *)key;

@end
