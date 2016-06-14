//
//  GQObjectSingleton.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

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

#define GQVariableAssert(_Chain_)\
NSString  *string = [NSString stringWithFormat:@"The %s has initialization",#_Chain_];\
NSAssert(!_Chain_, string);\

#define GQChainRequestDefine(_key_name_,_Chain_, _type_ , _block_type_)\
- (_block_type_)_key_name_{\
    GQVariableAssert(_##_Chain_);\
    NSAssert(!_loading, @"The request has already begun");\
    __weak typeof(self) weakSelf = self;\
    if (!_##_key_name_) {\
        _##_key_name_ = ^(_type_ value){\
            __strong typeof(weakSelf) strongSelf = weakSelf;\
            _##_Chain_ = value;\
            return strongSelf;\
        };\
    }\
    return _##_key_name_;\
}\

#define GQMethodRequestDefine( _method_ , _type_)\
- (instancetype)_method_:(_type_)value{\
    GQVariableAssert(_##_method_);\
    _##_method_ = [value copy];\
    return self;\
}\


#endif /* GQObjectSingleton_h */
