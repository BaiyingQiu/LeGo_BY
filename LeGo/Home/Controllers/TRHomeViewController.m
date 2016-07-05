//
//  TRHomeViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRHomeViewController.h"
#import "TRMapViewController.h"
#import "TRMenuData.h"
#import "TRMetaDataTool.h"
#import "TRCollectionViewCell.h"
#import "TRLocationManager.h"
#import "CityGroupsTableViewController.h"
#import "TRBaseNavController.h"


#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
static const CGFloat itemWidth = 60;
static const CGFloat interItemSpace = 10;
static const CGFloat topBottomInset = 15;

@interface TRHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *menuDataArray;
@property (nonatomic, strong) UICollectionView *collectionView ;

@property (nonatomic, strong) UIPageControl *pagecontrol;
@property (nonatomic, strong) UIBarButtonItem *cityItem;
//记录用户点击的label的文本
@property (nonatomic, copy)NSString *categoryName;
@property (nonatomic, copy)NSString *cityName;

@end

@implementation TRHomeViewController
-(NSArray *)menuDataArray {
    if (!_menuDataArray) {
        _menuDataArray = [TRMetaDataTool getAllMenuData];
    }
    return _menuDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpItems];
    //创建并添加collectionView
    [self setUpCollectionView];
    [self getUserCityName];
   
}
#pragma mark -- 定位相关
- (void)getUserCityName {
   //创建单例
//   dispatch_async(dispatch_get_global_queue(0, 0), ^{
   
   
      [[TRLocationManager sharedLocationManager] upDateCityNameWithCompletionHandler:^(NSString *cityName, NSError *error) {
         if (!error) {
            
            
               self.cityName = cityName;
               [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"cityName"];
               [TRMetaDataTool setSelectedCityName:cityName];
               self.cityItem.title = cityName;
               [self loadNewDeals];            
            //设置城市名并储存
            self.cityName = cityName;
            NSLog(@"++++++++%@",cityName);
            
         } else {
            NSLog(@"无法获取定位位置%@", error);
         }
      }];
//   });
}
#pragma mark -- 和界面相关的方法
- (void) setUpCollectionView {
    //1.创建一个UIView（添加两个控件 pageControl）
    //2.collectionView
    //2.1 创建流水布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置layout水平滑动
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //使用代码创建，大小会改回50，必须手动把大小改回来，
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, itemWidth * 2 + 2 * topBottomInset + interItemSpace) collectionViewLayout:layout];
   self.collectionView.backgroundColor = nil;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //隐藏水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //设置翻页
    self.collectionView.pagingEnabled = YES;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.bounds.size.height + 30 )];
   view.backgroundColor = nil;
    //添加到view上
    [view addSubview:self.collectionView];
   
    //3.pageControl
   self.pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH /2 - 10, view.bounds.size.height - 25, 20, 20)];
   self.pagecontrol.numberOfPages = 2;
   self.pagecontrol.currentPage = 0;
   self.pagecontrol.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
   self.pagecontrol.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
   [view addSubview:self.pagecontrol];
   
   //把view设置成tableView的头部视图
   self.tableView.tableHeaderView = view;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //取出用户点击的trMenuData
    TRMenuData *manuData = self.menuDataArray[indexPath.row];
    //赋值给分类
    self.categoryName = manuData.title;
    [self loadNewDeals];
}

- (void)setUpItems {
   //左上角Item（触发事件 + 更新文本）
   self.cityItem = [[UIBarButtonItem alloc] initWithTitle:@"位置" style:UIBarButtonItemStyleDone target:self action:@selector(ciclkCityItem)];
   self.navigationItem.leftBarButtonItem = self.cityItem;
   
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStyleDone target:self action:@selector(clickMapItem)];
    self.navigationItem.rightBarButtonItem = mapItem;
}
- (void)clickMapItem {
    TRMapViewController *mapViewController = [[TRMapViewController alloc] init];
    [self.navigationController pushViewController:mapViewController animated:YES];
}
- (void)ciclkCityItem {
//   TRBaseNavController *nc = [[TRBaseNavController alloc] initWithRootViewController:[CityGroupsTableViewController new]];
   [self.navigationController pushViewController:[CityGroupsTableViewController new] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated {
   if ([TRMetaDataTool getSelectedCityName]) {
      [self.cityItem setTitle:[TRMetaDataTool getSelectedCityName]];
      self.cityName = [TRMetaDataTool getSelectedCityName];
      [self loadNewDeals];
   }
   
   
}
- (void)settingRequestParams:(NSMutableDictionary *)params {
   if (self.cityName) {
      params[@"city"] = self.cityName;
   } else {
      params[@"city"] = @"北京";
   }
//    params[@"region"]   = @"集美区";
//    params[@"category"] = @"ktv";
    if (self.categoryName) {
        params[@"category"] = self.categoryName;
    } else {
        //默认推送美食
        params[@"category"] = @"美食";
    }
}
#pragma mark -- 和 UIscrollView Delegate 相关的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   //
   int pageValue = round(scrollView.contentOffset.x / scrollView.frame.size.width);
   self.pagecontrol.currentPage = pageValue;
}

#pragma mark -- 和 UICollecionView 相关的方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    //数据源
    TRMenuData *menuData = self.menuDataArray[indexPath.row];
    //设置cell的image和label
    cell.imageView.image = [UIImage imageNamed:menuData.image];
    cell.celllabel.text = menuData.title;
    cell.backgroundColor = nil;
    return cell;
    
}
#pragma mark -- FlowLayout Delegate 相关的方法

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 设置距离边缘 上/下/左/右的距离
    CGFloat halfLineSpaceing = kSCREEN_WIDTH * 0.125 - itemWidth * 0.5;
    
    return UIEdgeInsetsMake(topBottomInset, halfLineSpaceing, topBottomInset, halfLineSpaceing);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return  kSCREEN_WIDTH * 0.25 - itemWidth;
    
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
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
