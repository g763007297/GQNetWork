//
//  DetailViewController.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DetailViewController.h"

#import "DemoHttpRequest.h"

@interface DetailViewController ()
{
    NSInteger index;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 0;
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    dispatch_queue_t queue = dispatch_queue_create("com.test", DISPATCH_QUEUE_SERIAL);
    
    TestRequestHandlerHttpRequest *request = (TestRequestHandlerHttpRequest *)[TestRequestHandlerHttpRequest prepareRequset]
    .requestUrlChain(@"http://www.baidu.com")
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
