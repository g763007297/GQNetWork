//
//  GQNetworkConsts.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQNetworkConsts_h
#define GQNetworkConsts_h

/**
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, GQNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    GQNotReachable = 0,
    GQReachableViaWiFi=2,
    GQReachableViaWWAN=1
};

typedef enum {
    GQURLParameterEncoding,             //常规post请求  可有图片
    GQJSONParameterEncoding             //parameter json化 无图片
} GQParameterEncoding;

typedef enum : NSUInteger{
    GQRequestMethodGet = 1,
    GQRequestMethodPost,           // content type = @"application/x-www-form-urlencoded"
    GQRequestMethodMultipartPost,   // content type = @"multipart/form-data"
    GQRequestMethodPut,
    GQRequestMethodDelete
} GQRequestMethod;

typedef enum:NSInteger {
    GQRequestErrorDefualt = 10000,  //默认错误
    GQRequestErrorNoNetWork,        //无网络
    GQRequestErrorNoData,           //无数据
    GQRequestErrorParse,            //解析错误
}GQRequestError;

////////////////////////////////////////////////////////////////////////////////
#ifndef SHOULDOVERRIDE
    #define SHOULDOVERRIDE(basename, subclassname){ NSAssert([basename isEqualToString:subclassname], @"subclass should override the method!");}
#endif

#define GQDispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else { \
    dispatch_async(dispatch_get_main_queue(),block);\
}

#ifndef GQ_USER_DEFAULT
    #define GQ_USER_DEFAULT [NSUserDefaults standardUserDefaults]
#endif
//强弱引用
#ifndef GQWeakify
    #define GQWeakify(object) __weak __typeof__(object) weak##_##object = object
#endif

#ifndef GQStrongify
    #define GQStrongify(object) __strong __typeof__(object) object = weak##_##object
#endif

#ifndef GQVariableAssert
    #define GQVariableAssert(_Chain_)\
    NSAssert(!_Chain_, @"%@",[NSString stringWithFormat:@"The %s has initialization",#_Chain_]);
#endif

#ifndef GQChainRequestDefine
    #define GQChainRequestDefine(_key_name_,_Chain_, _type_ , _block_type_)\
    - (_block_type_)_key_name_{\
        GQVariableAssert(_##_Chain_);\
        NSAssert(!_loading, @"The request has already begun");\
        GQWeakify(self);\
        if (!_##_key_name_) {\
            _##_key_name_ = ^(_type_ value){\
                GQStrongify(self);\
                self->_##_Chain_ = value;\
                return self;\
            };\
        }\
        return _##_key_name_;\
    }
#endif

#ifndef GQMethodRequestDefine
    #define GQMethodRequestDefine( _method_ , _type_)\
    - (instancetype)_method_:(_type_)value{\
        GQVariableAssert(_##_method_);\
        _##_method_ = [value copy];\
        return self;\
    }
#endif

static NSString * GQUploadKey= @"GQUploadKey";
static NSString * GQUploadData= @"GQUploadData";
static NSString * GQUploadFileName= @"GQUploadFileName";
static NSString * GQUploadContentType= @"GQUploadContentType";

#endif /* GQNetworkConsts_h */
