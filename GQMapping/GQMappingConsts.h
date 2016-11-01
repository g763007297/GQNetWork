//
//  GQMappingConsts.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQMappingConsts_h
#define GQMappingConsts_h

typedef enum {
    GQORMPropertyTypeNone,
    GQORMPropertyTypeInt,                  //Ti,N,V_propertyName
    GQORMPropertyTypeNSInteger,            //Tq,N,V_propertyName
    GQORMPropertyTypeFloat,                //Tf,N,V_propertyName
    GQORMPropertyTypeCGFloat,              //Td,N,V_propertyName
    GQORMPropertyTypeDouble,               //Td,N,V_propertyName
    GQORMPropertyTypeNSNumber,             //T@"NSNumber"
    GQORMPropertyTypeNSValue,              //T@"NSValue"
    GQORMPropertyTypeNSString,             //T@"NSArray"
    GQORMPropertyTypeNSArray,              //T@“NSString"
    GQORMPropertyTypeNSDictionary,         //T@"NSDictionary"
    GQORMPropertyTypeCustomClass,          //T@"ClassName"
} GQORMPropertyType;

typedef enum {
    GQMappingErrorTypeMismatch = 111,
}GQMappingError;

#endif
