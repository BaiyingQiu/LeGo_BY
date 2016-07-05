//
//  TRBusinessViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRBusinessViewController.h"
#import "TRBusinessHeaderView.h"
#import "TRSearchViewController.h"
#import "UIView+Extension.h"
#import "TRSortViewController.h"
#import "TRRegionViewController.h"
#import "TRCategoryViewController.h"
#import "TRSort.h"
#import "TRCategory.h"
#import "TRRegion.h"

@interface TRBusinessViewController () <UIPopoverPresentationControllerDelegate>
//头部视图
@property (nonatomic, strong) TRBusinessHeaderView *headerView;
/** 排序控制器 */
@property(nonatomic, strong)TRSortViewController *sortViewController;
/** 区域控制器 */
@property(nonatomic, strong)TRRegionViewController *regionViewController;
/** 分类控制器 */
@property(nonatomic, strong)TRCategoryViewController *categoryViewController;
//记录排序的值
@property (nonatomic, strong)NSNumber *selectedSort;
//记录主区域的名字
@property (nonatomic, strong) NSString *selectedRegion;
//子区域的名字
@property (nonatomic, strong) NSString *selectedSubRegion;
//主分类的名字
@property (nonatomic, strong) NSString *selectedCatetory;
//子分类的名字
@property (nonatomic, strong) NSString *selectedSubCategory;

@property (nonatomic, strong) NSString *cityName;


@end

@implementation TRBusinessViewController

//使用懒加载:商家控制器持有排序控制器对象，在整个程序声明周期内只有一个排序控制器对象
-(TRSortViewController *)sortViewController {
    if (!_sortViewController) {
        _sortViewController = [TRSortViewController new];
    }
    return _sortViewController;
}
-(TRRegionViewController *)regionViewController {
    if (!_regionViewController) {
        _regionViewController = [TRRegionViewController new];
    }
    return _regionViewController;
}
- (TRCategoryViewController *)categoryViewController {
    if (!_categoryViewController) {
        _categoryViewController = [TRCategoryViewController new];
    }
    return _categoryViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加搜索控件
    [self setUpTowItems];
    //创建并添加头部视图
    [self setUpHeaderView];
    //添加按键
    [self addTargetsForButton];
    //监听通知
    [self listenNotifications];
    self.cityName = [[NSUserDefaults standardUserDefaults] valueForKey:@"cityName"];
}
#pragma mark -- 和监听相关方法
- (void)listenNotifications {
    //排序
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortDidChange:) name:@"TRSortDidChange" object:nil];
    //区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidChange:) name:@"TRRegionDidChange" object:nil];
    //分类
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryDidChange:) name:@"TRCategoryDidChange" object:nil];
    //城市
    
    
}
- (void)shortDidChange:(NSNotification *)notification {
    //取出排序对象
    TRSort *sort = notification.userInfo[@"TRSort"];
    //重设参数,重发请求
    self.selectedSort = sort.value;
    
    [self loadNewDeals];
}
- (void)regionDidChange:(NSNotification *)notification {
    TRRegion *region = notification.userInfo[@"TRRegion"];
    self.selectedRegion = region.name;
    NSString *subRegion = notification.userInfo[@"TRSubRegion"];
    //排除“全部”的干扰
    if ([region.name isEqualToString:@"全部"]) {
        self.selectedRegion = nil;
    } else {
        self.selectedRegion = region.name;
        
        if ([subRegion isEqualToString:@"全部"]) {
            self.selectedRegion = region.name;
            self.selectedSubRegion = nil;
        } else {
            self.selectedSubRegion = subRegion;
        }
        
    }
    
    [self loadNewDeals];
}
- (void)CategoryDidChange:(NSNotification *)notification {
    TRCategory *category = notification.userInfo[@"TRCategory"];
    self.selectedCatetory = category.name;
    NSString *subCatetory = notification.userInfo[@"TRSubcategory"];
    //排除“第一行全部分类”的干扰
    if ([category.name isEqualToString:@"全部分类"]) {
        self.selectedCatetory = nil;
    } else {
        self.selectedCatetory = category.name;
        
        if ([subCatetory isEqualToString:@"全部"]) {
            self.selectedCatetory = category.name;
            self.selectedSubCategory = nil;
        } else {
            self.selectedSubCategory = subCatetory;
        }
    }
    
    [self loadNewDeals];
}
#pragma mark -- 和界面相关方法
- (void)setUpTowItems {
    //左上角的item
    UIBarButtonItem *seachItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStyleDone target:self action:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItem = seachItem;
}
- (void) clickSearchItem {
    //1.跳转搜索控制器对象
    TRSearchViewController *searchViewC = [TRSearchViewController new];
    
    //2.跳转push
    [self.navigationController pushViewController:searchViewC animated:YES];
    //
}
- (void)setUpHeaderView {
    //实例化xib 文件的视图对象
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"TRBusinessHeaderView" owner:self options:nil] lastObject];
    self.headerView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 50);
    [self.view addSubview:self.headerView];
    //修改父类的tableView的y值
    self.tableView.y = 50;
}

- (void)addTargetsForButton {
    [self.headerView.sortButton addTarget:self action:@selector(cilckSortButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.regionButton addTarget:self action:@selector(cilckRegionButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.categoryButton addTarget:self action:@selector(cilckCategoryButton) forControlEvents:UIControlEventTouchUpInside];
    
//    NSLog(@"@---");
    
}
#pragma mark -- 按钮触发方法
- (void)cilckSortButton {
    //1.获取弹出控制器
    //2.设置属性（指定那个控件，指定具体显示在哪，箭头的方向）
    self.sortViewController.modalPresentationStyle = UIModalPresentationPopover;//带锚点的样式
    //指向相对的显示区域
    self.sortViewController.popoverPresentationController.sourceView = self.headerView.sortButton;
    //指定相对于排序Button的具体位置
    self.sortViewController.popoverPresentationController.sourceRect = self.headerView.sortButton.bounds;
    //箭头指向  默认指定 Any 系统给定最优方向
    self.sortViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //设置代理（iPhone需要，iPad不需要）
    self.sortViewController.popoverPresentationController.delegate = self;
    
    //3.显示弹出的控制器
    [self presentViewController:self.sortViewController animated:YES completion:nil];
}
- (void)cilckRegionButton {
    
    self.regionViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.regionViewController.popoverPresentationController.sourceView = self.headerView.regionButton;
    self.regionViewController.popoverPresentationController.sourceRect = self.headerView.regionButton.bounds;
    self.regionViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.regionViewController.popoverPresentationController.delegate = self;
    
    [self presentViewController:self.regionViewController animated:YES completion:nil];
    
}
- (void)cilckCategoryButton {
    
    self.categoryViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.categoryViewController.popoverPresentationController.sourceView = self.headerView.categoryButton;
    self.categoryViewController.popoverPresentationController.sourceRect = self.headerView.categoryButton.bounds;
    self.categoryViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.categoryViewController.popoverPresentationController.delegate = self;
    
    [self presentViewController:self.categoryViewController animated:YES completion:nil];
    
}
#pragma mark --popoverPresentationController 的代理方法
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    //让底层重写方法无效
    return UIModalPresentationNone;
}
//重写父类的参数方法
- (void)settingRequestParams:(NSMutableDictionary *)params {
//#warning TODO:硬编码
    if (self.cityName) {
        params[@"city"] = self.cityName;
    } else {
        params[@"city"] = @"厦门";
    }
    
    if (self.selectedCatetory) {
        if (self.selectedSubCategory) {
            params[@"category"] = self.selectedSubCategory;
        } else {
            params[@"category"] = self.selectedCatetory;
        }
    }    
    //判断选择了区域
    if(self.selectedRegion) {
        //有子区域
        if (self.selectedSubRegion) {
            params[@"region"] = self.selectedSubRegion;
//            self.selectedSubRegion = nil;
        } else {
            //没有子区域
            params[@"region"] = self.selectedRegion;
        }
    }
    //排序
    if (self.selectedSort) {
        params[@"sort"] = self.selectedSort;
    }
    
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
