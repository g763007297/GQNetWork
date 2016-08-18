//
//  ProductModel.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/6/1.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (NSDictionary *)attributeMapDictionary{
    return @{@"course":@"course",
             @"createTime":@"createTime",
             @"pDescriptionnn":@"description",
             @"enumId":@"enumId",
             @"pIdddddd":@"id",
             @"likes":@"likes",
             @"name":@"name",
             @"picUrl":@"picUrl",
             @"price":@"price",
             @"is":@"is"};
}
/**后台返回给我们的数据

 {
    message = "执行成功";
    result =     {
    rows =         (
                     {
                     course = 0;
                     createTime = 1451355631000;
                     description = "三文鱼";
                     enumId = 4;
                     id = 39;
                     likes = 19;
                     name = "法香三文鱼";
                     picUrl = "/nisefile/files/image/2015-12-29/5681edef0cf2a9072bd6be4a.jpg";
                     price = 99;
                     }
                );
        total = 1;
    };
    success = 1;
 }
 
 **/

- (NSArray *)versionChangeProperties
{
//    return nil;
    return @[@"pId->pIdd->pIddd->pIdddd->pIddddd->pIdddddd",@"pDescription->pDescriptionn->pDescriptionnn"];
}

@end
