//
//  GQBaseModelObject.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GQBaseModelObject : NSObject

- (id)initWithDataDic:(NSDictionary*)data;

/*!
 *	Subclass must override this method, otherwise app will crash if call this methods
 *	Key-Value pair by dictionary key name and property name.
 *	key:    property name
 *	value:  dictionary key name
 *	\returns a dictionary key-value pair by property name and key of data dictionary
 */
- (NSDictionary*)attributeMapDictionary;

/*!
 *	You can implement this. Default implementation nil is returned
 */
- (NSString*)customDescription;

- (NSData*)getArchivedData;

- (NSDictionary*)propertiesAndValuesDictionary;

@end
