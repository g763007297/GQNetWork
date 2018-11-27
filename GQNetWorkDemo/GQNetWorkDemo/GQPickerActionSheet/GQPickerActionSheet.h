//
//  PickerActionSheet.h
//  PickerActionSheet
//
//  Created by tusm on 15/12/30.
//  Copyright © 2015年 tusm. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const __GQImageNameKey = @"imageName";
static NSString *const __GQImageDataKey = @"UIImagePickerControllerOriginalImage";

typedef enum {
    PSuccess = 0,   //打开成功
    PUnable,        //设备不可用
    PAuthoriza,     //权限问题
    POhter          //其他原因
}Picker_Error;

@protocol __GQPickerActionSheetDelegate <NSObject>

@required
/**
 *  选择完成后的代理
 *
 *  @param dictionary imageNameKey:图片名称  imageDataKey:图片UIImage对象
 */
- (void)finishChoose:(NSDictionary *)dictionary;

@optional
//打开状态返回
- (void)pickerViewShowStatu:(Picker_Error)error;

@end

@interface GQPickerActionSheet : UIView

- (void)showActionSheet:(UIViewController *)controller withDelegate:(id<__GQPickerActionSheetDelegate>)delegate;

@end
