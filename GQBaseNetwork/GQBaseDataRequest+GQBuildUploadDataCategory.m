//
//  GQBaseDataRequest+GQBuildUploadDataCategory.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/9.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest+GQBuildUploadDataCategory.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation GQBaseDataRequest (GQBuildUploadDataCategory)

static inline NSString * GQMimeTypeForFileAtPath(NSString *path)
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[[NSURL URLWithString:path] pathExtension], NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
}


+ (NSDictionary *)buildUploadData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key
{
    NSAssert(data, @"UploadData don`t be nil");
    NSAssert(key, @"UploadKey don`t be nil");
    
    if (!contentType) {
        contentType = @"application/octet-stream";
    }
    
    return @{GQUploadData:data,
             GQUploadFileName:fileName? :@"file",
             GQUploadContentType:contentType,
             GQUploadKey:key};
}

+ (NSDictionary *)buildUploadFile:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key
{
    NSAssert(filePath, @"UploadData don`t be nil");
    NSAssert(key, @"UploadKey don`t be nil");
    
    if (!contentType) {
        contentType = GQMimeTypeForFileAtPath(filePath);
    }
    
    return @{GQUploadData:[self getDataFromFile:filePath],
             GQUploadFileName:fileName? :[filePath lastPathComponent],
             GQUploadContentType:contentType,
             GQUploadKey:key};
}

+ (NSData *)getDataFromFile:(NSString *)file
{
    NSInputStream *stream = [[NSInputStream alloc] initWithFileAtPath:file];
    [stream open];
    NSUInteger bytesRead;
    NSMutableData *data = [[NSMutableData alloc] init];
    while ([stream hasBytesAvailable]) {
        
        unsigned char buffer[1024*256];
        bytesRead = [stream read:buffer maxLength:sizeof(buffer)];
        if (bytesRead == 0) {
            break;
        }
        [data appendData:[NSData dataWithBytes:buffer length:bytesRead]];
    }
    [stream close];
    return data;
}

@end
