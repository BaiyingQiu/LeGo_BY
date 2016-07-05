//
//  TRBaseViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRBaseViewController.h"
#import "DPRequest.h"
#import "DPAPI.h"
//#import "DPConstants.h"
#import "TRMetaDataTool.h"
#import "TRDeal.h"
#import "MJRefresh.h"
#import "DealCell.h"
#import "TRDetailViewController.h"
#import "MBProgressHUD.h"



@interface TRBaseViewController () <UITableViewDataSource, UITableViewDelegate,DPRequestDelegate>

/** 储存服务器返回数据的数组 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 记录当前页数 */
@property (nonatomic, assign) int page;
/** 记录用户最后一次的请求 */
@property (nonatomic, strong) DPRequest *request;


@end

@implementation TRBaseViewController

- (NSArray *)deals {
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建tableView
    [self setupTableView];
    
    //注册单元格
//    [self.tableView registerClass:[DealCell class] forCellReuseIdentifier:@"DealCell"];
    //通过IXB注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"DealCell" bundle:nil] forCellReuseIdentifier:@"dealCell"];
    
    //创建刷新控件（然后发送请求
    [self addRefreshControl];
    //发送请求
//    [self sendRequestToServer];
    
    
}
//
-(void)settingRequestParams:(NSMutableDictionary *)params {
#warning TODO:city and catrgory is hard code
        //
        params[@"city"] = @"厦门";
    
        //可选参数
        params[@"region"]    = @"思明区";
        params[@"category"]  = @"美食";
        params[@"sort"]      = @2;
    
    
}
#pragma mark -- 和界面相关的方法
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}
/** 添加刷新控件 */
- (void)addRefreshControl {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    //添加完之后，同时执行selector
    [self.tableView.mj_header beginRefreshing];
    //刷新
//    [self sendRequestToServer];
    //停止下拉刷新控件
//    [self.tableView.mj_header endRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    
}
#pragma mark -- 和网络相关方法
//下拉触发方法
- (void)loadNewDeals {
    self.page = 1;
    [self sendRequestToServer];
}
//上拉触发方法
- (void)loadMoreDeals {
    
//    [self.tableView.mj_footer beginRefreshing];
    self.page ++;
    [self sendRequestToServer];
}

- (void)sendRequestToServer {
    
    //1.创建DPAPI对象
    DPAPI *api = [[DPAPI alloc] init];
    //2.设置请求参数
    /*  首页控制器 参数 city + caregory
        商家控制器 参数 city + caregory + region + sort
        搜索控制器 参数 city + keyword
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self settingRequestParams:params];
    
    params[@"page"] = @(self.page);
    NSLog(@"请求参数：%@",params);
    
    //3.发送请求 并记录当前请求
    self.request = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    //
}

-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    
    //如果请求不同，直接不处理
    if (self.request != request) {
        return;
    }
    
    //???
    NSArray *array = [TRMetaDataTool parseDealsResult:result];
//    [_deals addObjectsFromArray:array];???
    if (self.page == 1) {
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:array];
    
//    NSLog(@"requset%@",result);
    NSLog(@"数据请求成功");
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
-(void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"返回失败");
    //创建HUD控件
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"网络繁忙，请稍后再试";
//    hud.margin = 10;
//    //隐藏
//    
//    [hud hide:YES afterDelay:2];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"请求无效";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    
    //停止下拉刷新控件
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark -- UITableView相关方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deals.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
//    if(cell == nil){
//        //如果没有取出空闲的cell，则创建一个新的cell，并给新的cell标记叫index
//        cell = [[DealCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealCell"];
//    }
 
    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dealCell" forIndexPath:indexPath];
    
    //XIB的重用
//    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"DealView" owner:self options:nil].lastObject init];
//        NSLog(@"@++++++++cell创建");
//    } else {
//        NSLog(@"@------cell复用");
//    }
    
    TRDeal *deal = self.deals[indexPath.row];
    
    //对cell 进行初始化
    [cell setCell:deal];
    
    
//    cell.titleLable.text = deal.title;
//    cell.listPricelabel.text = [NSString stringWithFormat:@"￥%@",deal.list_price];
//    cell.cureentPrice.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
//    cell.discountLabel.text = [NSString stringWithFormat:@"%.2f", ([deal.list_price floatValue]+ [deal.current_price floatValue]) * 0.5];
//    [cell.imageViewHI sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url]];
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.获取订单对象
    TRDeal *deal = self.deals[indexPath.row];
    //2.创建navController 对象，创建详情控制器对象,h5_url
    TRDetailViewController *detaiVC = [[TRDetailViewController alloc] initWithDealUrl:deal.deal_h5_url];
    [self.navigationController pushViewController:detaiVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
