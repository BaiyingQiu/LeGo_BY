//
//  TRRegionViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRRegionViewController.h"
#import "TRMetaDataTool.h"
#import "TRMetaDataView.h"
#import "TRRegion.h"
#import "TRTableViewCell.h"


@interface TRRegionViewController () <UITableViewDataSource, UITableViewDelegate>
//记录某个城市的所有区域的数据
@property (nonatomic, strong) NSArray *regoins;

@property (nonatomic, strong) TRMetaDataView *metaDataView;

@end

@implementation TRRegionViewController
//-(NSArray *)regoins {
//    
//        _regoins = [TRMetaDataTool getAllRegionByCityName:@"厦门"];
//    return _regoins;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSArray *regionArray = [TRMetaDataTool getAllRegionByCityName:@"北京"];
    //实例化并添加自定义视图
    [self addMetaDataView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    NSString *cityName = [TRMetaDataTool getSelectedCityName];
    if (cityName) {
        self.regoins = [TRMetaDataTool getAllRegionByCityName:cityName];
    } else {
        self.regoins = [TRMetaDataTool getAllRegionByCityName:@"厦门"];
    }
}
#pragma mark -- 和界面相关
- (void)addMetaDataView {
    //通过XIB创建
    self.metaDataView = [[[NSBundle mainBundle] loadNibNamed:@"TRMetaDataView" owner:self options:nil] lastObject];
    _metaDataView.frame = self.view.bounds;
    //
    _metaDataView.mainTableView.dataSource = self;
    _metaDataView.mainTableView.delegate = self;
    _metaDataView.subTableView.dataSource = self;
    _metaDataView.subTableView.delegate = self;
    
    [self.view addSubview:_metaDataView];
}

#pragma mark -- 和UItableView相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.metaDataView.mainTableView) {
        //左
        return self.regoins.count;
    } else {
        //右边的表示图
        //获取左边用户点击的行号
        NSInteger selectedRow = [self.metaDataView.mainTableView indexPathForSelectedRow].row;
        //取出对应的子区域
        TRRegion *region = self.regoins[selectedRow];
        return region.subregions.count;
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.metaDataView.mainTableView) {
        TRTableViewCell *cell =  [TRTableViewCell cellWithView:tableView withImageName:@"bg_dropdown_leftpart" withSeletedName:@"bg_dropdown_left_selected"];
        TRRegion *region = self.regoins[indexPath.row];
        cell.textLabel.text = region.name;
        return cell;
        
        
    } else {
        
        TRTableViewCell *cell =  [TRTableViewCell cellWithView:tableView withImageName:@"bg_dropdown_leftpart" withSeletedName:@"bg_dropdown_left_selected"];
        
        NSInteger selectedRow = [self.metaDataView.mainTableView indexPathForSelectedRow].row;
        //取出对应的子区域
        TRRegion *region = self.regoins[selectedRow];
        cell.textLabel.text = region.subregions[indexPath.row];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.metaDataView.mainTableView) {
           [self.metaDataView.subTableView reloadData];
        //情况一：没有子区域
        TRRegion *region = self.regoins[indexPath.row];
        if (region.subregions.count == 0) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRRegion" : region}];
            //回收控制器
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        //情况二：有子区域（参数：主区域+子区域对象）
        //左边行号
        NSInteger leftRow = [_metaDataView.mainTableView indexPathForSelectedRow].row;
        //右边行号
        NSInteger rightRow = [_metaDataView.subTableView indexPathForSelectedRow].row;
        //主区域对象
        TRRegion *region = self.regoins[leftRow];
        //子区域对象
        NSString *subRegion = region.subregions[rightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRRegion" : region, @"TRSubRegion" : subRegion}];
        [self dismissViewControllerAnimated:YES completion:nil];
        
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
