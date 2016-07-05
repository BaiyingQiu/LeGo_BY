//
//  TRCategoryViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/28.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRCategoryViewController.h"
#import "TRCategory.h"
#import "TRMetaDataTool.h"
#import "TRMetaDataView.h"
#import "TRTableViewCell.h"


@interface TRCategoryViewController () <UITableViewDataSource, UITableViewDelegate>

/** 记录 所有分类 的数据 */
@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, strong) TRMetaDataView *metaDataView;

@property (nonatomic, strong) UIImage *TempImage;
@property (nonatomic, strong) TRTableViewCell *cell;

@end

@implementation TRCategoryViewController
- (NSArray *)categories {
    if (!_categories) {
        _categories = [TRMetaDataTool getAllCategory];
    }
    return _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实例化并添加自定义视图
    [self addMetaDataView];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 和UItableView相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.metaDataView.mainTableView) {
        //左
        return self.categories.count;
    } else {
        //右边的表示图
        //获取左边用户点击的行号
        NSInteger selectedRow = [self.metaDataView.mainTableView indexPathForSelectedRow].row;
        //取出对应的子区域
        TRCategory *category = self.categories[selectedRow];
        return category.subcategories.count;
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.metaDataView.mainTableView) {
        
        TRCategory *category = self.categories[indexPath.row];
        TRTableViewCell *cell =  [TRTableViewCell cellImageViewWithTableView:self.metaDataView.mainTableView withImageName:category.icon withSeletedName:@"bg_dropdown_left_selected"];
        cell.textLabel.text = category.name;
        return cell;
        
    } else {
        
        TRTableViewCell *cell =  [TRTableViewCell cellWithView:tableView withImageName:@"bg_dropdown_leftpart" withSeletedName:@"bg_dropdown_left_selected"];
        
        NSInteger selectedRow = [self.metaDataView.mainTableView indexPathForSelectedRow].row;
        //取出对应的子区域
        TRCategory *category = self.categories[selectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.metaDataView.mainTableView) {
        [self.metaDataView.subTableView reloadData];
        //改变选中cell的图片样式
        TRCategory *category = self.categories[indexPath.row];
        self.cell.imageView.image = self.TempImage;
        TRTableViewCell *cell = [_metaDataView.mainTableView cellForRowAtIndexPath:indexPath];
        self.TempImage = cell.imageView.image;
        cell.imageView.image = [UIImage imageNamed:category.highlighted_icon];
        self.cell = cell;
        
        //情况一：没有子分类
        if (category.subcategories.count == 0) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryDidChange" object:self userInfo:@{@"TRCategory" : category}];
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
        TRCategory *category = self.categories[leftRow];
        //子区域对象
        NSString *subcategory = category.subcategories[rightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryDidChange" object:self userInfo:@{@"TRCategory" : category, @"TRSubcategory" : subcategory}];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
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
