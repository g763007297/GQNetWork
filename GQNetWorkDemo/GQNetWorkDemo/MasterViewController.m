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
#import "ProductModel.h"
#import "GQDebug.h"
#import "GQObjectMapping.h"

@interface MasterViewController ()<DataRequestDelegate>

@property NSMutableArray *objects;

@property (nonatomic, strong) GQBaseDataRequest *request;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewDidAppear:animated];
    
#pragma mark -- 初级用法 使用delegate
    
    [DemoHttpRequest requestWithDelegate:self];
    
#pragma mark -- 初级用法 使用block
    
    [DemoHttpRequest requestWithOnRequestFinished:^(GQBaseDataRequest *request, GQMappingResult *result) {
        GQDPRINT(@"%@",result.dictionary);
    } onRequestFailed:^(GQBaseDataRequest *request, NSError *error) {
        GQDPRINT(@"%@",error);
    }];
    
#pragma mark -- 高级用法  使用mapping
    GQObjectMapping *map = [[GQObjectMapping alloc]initWithClass:[ProductModel class]];//进行map的初始化，必须穿我们要映射的class
    
    [map addPropertyMappingsFromDictionary:[ProductModel attributeMapDictionary]];//往我们的map中加映射规则
    
    GQRequestParameter *parameter = [[GQRequestParameter alloc] init];//配置请求参数
    
    parameter.keyPath = @"result/rows";//如果取的数据在字典里面很多层的话需要指定map的层级keyPath
    
    parameter.mapping = map;
    
    parameter.subRequestUrl = @"product/list";
    
#pragma mark -- 链式调用 + 方法调用
//    [[[DemoHttpRequest1 prepareRequset]
//      .requestUrlChain(@"product/list")
//      .mappingChain(map)
//      .keyPathChain(@"result/rows")
//      onRequestFinished:^(GQBaseDataRequest *request, GQMappingResult *result) {
//        GQDPRINT(@"%@",result.rawDictionary);
//        GQDPRINT(@"%@",result.array);
//    }] startRequest];
//    
#pragma mark -- 全链式调用
    
    __weak typeof(self) weakSelf = self;
    [DemoHttpRequest1 prepareRequset]
    .requestUrlChain(@"product/list")
    .mappingChain(map)
    .indicatorViewChain(self.view)
    .keyPathChain(@"result/rows")
    .onFinishedBlockChain(^(GQBaseDataRequest * request, GQMappingResult * result){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf saveModel:result.array];
    })
    .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
        
    })
    .parametersChain(@{})
    .startRequestChain();
    
    NSArray *array = [self getModel];
    NSLog(@"%@",array);
    
#pragma mark -- 常规block
//    [DemoHttpRequest1 requestWithRequestParameter:parameter
//                                  onRequestStart:nil
//                               onRequestFinished:^(GQBaseDataRequest *request, GQMappingResult *result){
//                                   GQDPRINT(@"%@",result.rawDictionary);
//                                   GQDPRINT(@"%@",result.array);
//                               }
//                               onRequestCanceled:nil
//                                 onRequestFailed:nil
//                               onProgressChanged:nil];
}

#pragma mark -- DataRequestDelegate

- (void)requestDidStartLoad:(GQBaseDataRequest*)request;
{
    
}

- (void)requestDidFinishLoad:(GQBaseDataRequest*)request mappingResult:(GQMappingResult *)result{
    if ([request isKindOfClass:[DemoHttpRequest class]]) {//如果同一页面有多个不同的请求的话可以使用isKindOfClass判断是哪个请求
        GQDPRINT(@"%@",result.rawDictionary);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
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

@end
