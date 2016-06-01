//
//  GQObjectSingleton.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef GQ_OBJECT_SINGLETON_INCLUDE_FLAG
#define GQ_OBJECT_SINGLETON_INCLUDE_FLAG 1

#define GQOBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
    @synchronized(self) {                            \
        if (z##_shared_obj_name_ == nil) {             \
            static dispatch_once_t done;\
            dispatch_once(&done, ^{ z##_shared_obj_name_ = [[self alloc] init]; });\
            /* Note that 'self' may not be the same as _object_name_ *
            first assignment done in allocWithZone but we must reassign in case init fails
            z##_shared_obj_name_ = [[self alloc] init];
            GQAssert((z##_shared_obj_name_ != nil), @"didn't catch singleton allocation");
            }*/\
        }\
    }                                                \
    return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
    @synchronized(self) {                            \
        if (z##_shared_obj_name_ == nil) {             \
            z##_shared_obj_name_ = [super allocWithZone:NULL]; \
            return z##_shared_obj_name_;                 \
        }                                              \
    }                                                \
\
/* We can't return the shared instance, because it's been init'd */     \
    /*GQAssert(NO, @"use the singleton API, not alloc+init"); */       \
return nil;                                    \
}                                                  \

#endif /* GQObjectSingleton_h */
