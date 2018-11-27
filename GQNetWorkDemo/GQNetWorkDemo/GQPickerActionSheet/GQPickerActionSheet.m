//
//  PickerActionSheet.m
//  PickerActionSheet
//
//  Created by tusm on 15/12/30.
//  Copyright © 2015年 tusm. All rights reserved.
//

#import "GQPickerActionSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define __GQSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface GQPickerActionSheet()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSInteger imageflag;//1:拍照 2:相册
    UIViewController *controllers;
}

@property (nonatomic, weak) id<__GQPickerActionSheetDelegate> mdelegate;

@end

@implementation GQPickerActionSheet

- (void)showActionSheet:(UIViewController *)controller withDelegate:(id<__GQPickerActionSheetDelegate>)delegate{
    controllers = controller;
    _mdelegate = delegate;
    if (__GQSystemVersion >= 8) {
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alterController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }]];
        [alterController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self snapImage];//拍照
        }]];
        [alterController addAction:[UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self pickImage];//相册
        }]];
        [controllers presentViewController:alterController animated:YES completion:nil];
    }else{
        [controllers.view addSubview:self];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册上传", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self];
    }
}

#pragma mark -UIActionDelegate
-(void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    //8以下系统可以自定义字体颜色，或者不管deprecated，将上面的UIAlertController注视掉也可以在8以上的系统上使用
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector]) {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]]) {
            alertController.view.tintColor = [UIColor orangeColor];
        }
    }else{
        for (UIView *subViwe in actionSheet.subviews) {
            if ([subViwe isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton*)subViwe;
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self snapImage];//拍照
    }else if (buttonIndex == 1){
        [self pickImage];//相册
    }else{
        
    }
}

#pragma mark -拍照
-(void)snapImage{
    BOOL isCameraAuthoriza = YES;
    if (__GQSystemVersion > 7.0) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        }];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusAuthorized){
            isCameraAuthoriza = NO;
        }else{
            isCameraAuthoriza = YES;
        }
    }
    if (isCameraAuthoriza) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]&&[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear||UIImagePickerControllerCameraDeviceFront]){
            
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            
            imageflag = 1;
            ipc.modalPresentationStyle = UIModalPresentationFullScreen;
            [ipc setDelegate:self];
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            [ipc setAllowsEditing:YES];
            
            if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(pickerViewShowStatu:)]) {
                [self.mdelegate pickerViewShowStatu:PSuccess];
            }
            
            [controllers presentViewController:ipc animated:YES completion:^{
                
            }];
        }else {
            if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(pickerViewShowStatu:)]) {
                [self.mdelegate pickerViewShowStatu:PUnable];
            }
        }
    }else{
        if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(pickerViewShowStatu:)]) {
            [self.mdelegate pickerViewShowStatu:PAuthoriza];
        }
    }
}

#pragma mark -从相册找
-(void)pickImage{
    //如果打开黑屏的话说明是没有获得权限
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//从相册找
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    imageflag = 2;
    if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(pickerViewShowStatu:)]) {
        [self.mdelegate pickerViewShowStatu:PSuccess];
    }
    [controllers presentViewController:ipc animated:YES completion:^{
        
    }];
    return;
}

#pragma mark - UIImagePickerControllerDelegate Delegate Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        if (imageflag == 1) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSInteger time = a;
            NSString *timeString = [NSString stringWithFormat:@"%ld.JPG", time];
            [info setValue:timeString forKey:__GQImageNameKey];
        }else if (imageflag == 2){
//            [info setValue:[imageRep filename]?:@"" forKey:__GQImageNameKey];
        }
        [controllers dismissViewControllerAnimated:YES completion:^{
            if (self.mdelegate&&[self.mdelegate respondsToSelector:@selector(finishChoose:)]) {
                [self.mdelegate finishChoose:info];
            }
        }];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:__GQImageDataKey];
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
