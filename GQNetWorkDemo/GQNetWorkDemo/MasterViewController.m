//
//  MasterViewController.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DemoHttpRequest.h"

@interface MasterViewController ()<GQDataRequestDelegate>

@property NSMutableArray *objects;

@property (nonatomic, strong) GQBaseDataRequest *request;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigation];
    
    [self addNetworkChangeNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewDidAppear:animated];
    
    [self testNetwork];
}

#pragma mark -- navigation configure
- (void)configureNavigation {
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark -- Notification  添加通知
- (void)addNetworkChangeNotification {
    GQNetworkStatus status = [GQNetworkTrafficManager sharedManager].networkStatus;
    NSLog(@"%ld",status);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kGQNetWorkChangedNotification object:nil];
}

- (void)networkChange:(id)data {
    GQNetworkStatus status = [GQNetworkTrafficManager sharedManager].networkStatus;
    NSLog(@"%ld",status);
}

#pragma mark -- testNetwork
- (void)testNetwork {
#pragma mark -- 初级用法 使用delegate
    
    [DemoHttpRequest requestWithDelegate:self];
    
#pragma mark -- 初级用法 使用block
    
    [DemoHttpRequest requestWithOnRequestFinished:^(GQBaseDataRequest *request, GQRequestResult *result) {
        NSLog(@"%@",result.rawResponse);
    } onRequestFailed:^(GQBaseDataRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
    
//#pragma mark -- 高级用法  使用mapping
//    GQObjectMapping *map = [[GQObjectMapping alloc]initWithClass:[ProductModel class]];//进行map的初始化，必须穿我们要映射的class
//
//    [map addPropertyMappingsFromDictionary:[ProductModel attributeMapDictionary]];//往我们的map中加映射规则
//
//    GQRequestParameter *parameter = [[GQRequestParameter alloc] init];//配置请求参数
//
//    parameter.keyPath = @"result/rows";//如果取的数据在字典里面很多层的话需要指定map的层级keyPath
//
//    parameter.mapping = map;
//
//    parameter.subRequestUrl = @"product/list";
//
//#pragma mark -- 链式调用 + 方法调用
//    [[[DemoHttpRequest1 prepareRequset]
//      .requestUrlChain(@"product/list")
//      .mappingChain(map)
//      .keyPathChain(@"result/rows")
//      onFinishedBlockChain:^(GQBaseDataRequest *request, GQRequestResult *result) {
//          NSLog(@"%@",result.rawResponse);
//      }] startRequest];
    
#pragma mark -- 全链式调用
    
//    __weak typeof(self) weakSelf = self;
//    [DemoHttpRequest1 prepareRequset]
//    .requestUrlChain(@"product/list")/*请求地址*/
//    .mappingChain(map)/*映射关系*/
//    .indicatorViewChain(self.view)/*显示的view*/
//    .keyPathChain(@"result/rows")/*映射层级*/
//    .onFinishedBlockChain(^(GQBaseDataRequest * request, GQRequestResult * result){
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf saveModel:result.array];
//    })
//    .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
//
//    })
//    .parametersChain(@{})/*请求参数*/
//    .startRequestChain();/**开始请求*/
//
//    NSArray *array = [self getModel];
//    NSLog(@"%@",array);
    
#pragma mark -- 常规block
//    [DemoHttpRequest1 requestWithRequestParameter:parameter
//                                   onRequestStart:nil
//                                onRechiveResponse:^NSURLSessionResponseDisposition(GQBaseDataRequest *request,
//                                                                                   NSURLResponse *response) {
//                                    NSLog(@"%@",response);
//                                    return NSURLSessionResponseAllow;
//                                }
//                                onWillRedirection:^NSURLRequest *(GQBaseDataRequest *request,
//                                                                  NSURLRequest *urlRequest,
//                                                                  NSURLResponse *response) {
//                                    return urlRequest;
//                                }onNeedNewBodyStream:^NSInputStream *(GQBaseDataRequest *request,
//                                                                      NSInputStream *originalStream) {
//                                    return originalStream;
//                                } onWillCacheResponse:^NSCachedURLResponse *(GQBaseDataRequest *request, NSCachedURLResponse *proposedResponse) {
//                                    return proposedResponse;
//                                }onRequestFinished:^(GQBaseDataRequest *request,
//                                                     GQRequestResult *result){
//                                    NSLog(@"%@",result.rawResponse);
//                                }
//                                onRequestCanceled:nil
//                                  onRequestFailed:nil
//                                onProgressChanged:nil];
}

#pragma mark -- DataRequestDelegate

- (void)requestDidStartLoad:(GQBaseDataRequest*)request;
{
    
}

- (void)requestDidFinishLoad:(GQBaseDataRequest*)request mappingResult:(GQRequestResult *)result{
    if ([request isKindOfClass:[DemoHttpRequest class]]) {//如果同一页面有多个不同的请求的话可以使用isKindOfClass判断是哪个请求
        NSLog(@"%@",result.rawResponse);
    }
}

- (void)requestDidCancelLoad:(GQBaseDataRequest*)request{
    
}

- (void)request:(GQBaseDataRequest*)request progressChanged:(CGFloat)progress{
    
}

- (void)request:(GQBaseDataRequest*)request didFailLoadWithError:(NSError*)error{
    
}

#pragma mark -- Test Archiver Model Version Control

-(NSString *)HomePathArchiver
{
    NSString *homedictionatry = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    return [homedictionatry stringByAppendingPathComponent:@"productMode.archiver"];
}

- (void)saveModel:(id)model{
    NSFileManager *manager =[NSFileManager defaultManager];
    BOOL exist=[manager fileExistsAtPath:[self HomePathArchiver]];
    NSError *error =nil;
    if (exist) {
        [manager removeItemAtPath:[self HomePathArchiver] error:&error];
    }
    [NSKeyedArchiver archiveRootObject:model toFile:[self HomePathArchiver]];
}

- (id)getModel{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self HomePathArchiver]];
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDate *object = self.objects[indexPath.row];
    DetailViewController *controller = [[DetailViewController alloc] init];
    [controller setDetailItem:object];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
