//
//  DetailViewController.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DetailViewController.h"

#import "DemoHttpRequest.h"

#import "GQPickerActionSheet.h"

@interface DetailViewController ()<__GQPickerActionSheetDelegate>
{
    NSInteger index;
    GQPickerActionSheet *sheet;
}
@property (nonatomic, strong) TestRequestHandlerHttpRequest *request;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

+ (UIImage *)GG_scaleImage:(UIImage *)image toKb:(NSInteger)kb {
    
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 0;
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)finishChoose:(NSDictionary *)dictionary {
    UIImage *image = dictionary[__GQImageDataKey];
    UIImage *tempImage = [DetailViewController GG_scaleImage:image toKb:100];
    NSData *data = UIImageJPEGRepresentation(tempImage, 0.1);
    dispatch_queue_t queue = dispatch_queue_create("com.test", DISPATCH_QUEUE_SERIAL);
    
    NSArray *uploadArray = @[[TestRequestHandlerHttpRequest buildUploadData:data withFileName:@"file1.jpeg" andContentType:@"image/png" forKey:@"file"],
                             [TestRequestHandlerHttpRequest buildUploadData:data withFileName:@"file2.jpeg" andContentType:@"image/png" forKey:@"file"]];
    
    TestRequestHandlerHttpRequest *request = (TestRequestHandlerHttpRequest *)[TestRequestHandlerHttpRequest prepareRequset]
    .requestUrlChain(@"http://193.112.232.35:18765/filecenter/file/upfile")
    .headerParametersChain(@{@"token":@"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJ0b2tlbiIsInN1YiI6IntcImlwXCI6XCIxMC4xMjUuMjAuNDJcIixcInRva2VuXCI6XCIwY2QwM2FhMi1mOWE4LTQwYTgtOGQwNS02YzJhMjZhNWM0NWRcIn0iLCJpYXQiOjE1NDIzMzA5MDJ9.jzAelDVr_mqZR9uzOEzg-SAzqopq1EU5dEcaHW1l6SE"})
    .parametersChain(@{@"bizCode":@"maintenace"
                       })
    .uploadDatasChain(uploadArray)
    .completeCallBackQueueChain(queue)
    .onFinishedBlockChain(^(GQBaseDataRequest * request, GQRequestResult * result){
        //            NSLog(@"%@",result.dictionary);
        NSString *string = [[NSString alloc] initWithData:result.rawResultData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
    })
    .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
        NSLog(@"%@",error);
    });
    request.startRequestChain();
}

- (void)pickerViewShowStatu:(Picker_Error)error {
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)ges {
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//    sheet = [[GQPickerActionSheet alloc] init];
//    [sheet showActionSheet:self withDelegate:self];
//
//    TestRequestHandlerHttpRequest *request = (TestRequestHandlerHttpRequest *)[TestRequestHandlerHttpRequest prepareRequset]
//    .requestUrlChain(@"http://www.baidu.com")
//    .completeCallBackQueueChain(queue)
//    .onFinishedBlockChain(^(GQBaseDataRequest * request, GQRequestResult * result){
//        //            NSLog(@"%@",result.dictionary);
//        NSString *string = [[NSString alloc] initWithData:result.rawResultData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",string);
//    })
//    .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
//        NSLog(@"%@",error);
//    });
//    request.startRequestChain();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
