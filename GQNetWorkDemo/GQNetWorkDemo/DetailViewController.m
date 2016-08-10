//
//  DetailViewController.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DetailViewController.h"

#import "DemoHttpRequest.h"

#import "GQDebug.h"

@interface DetailViewController ()

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
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    [TestRequestHandlerHttpRequest prepareRequset]
    .requestUrlChain(@"http://www.hao123.com")
    .onRechiveResponseBlockChain(^NSURLSessionResponseDisposition(GQBaseDataRequest *request, NSURLResponse *response){
        GQDPRINT(@"%@",response);
        return NSURLSessionResponseAllow;
    })
    .onFinishedBlockChain(^(GQBaseDataRequest * request, GQMappingResult * result){
        NSString *string = [[NSString alloc] initWithData:result.originalData encoding:NSUTF8StringEncoding];
        GQDPRINT(@"%@",string);
    })
    .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
        GQDPRINT(@"%@",error);
    })
    .startRequestChain();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
