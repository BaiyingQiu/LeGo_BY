//
//  TRSearchViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRSearchViewController.h"
#import "TRMetaDataTool.h"

@interface TRSearchViewController () <UISearchBarDelegate>
@property (nonatomic, copy) NSString *cityName;

@end

@implementation TRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityName = [TRMetaDataTool getSelectedCityName];
    
    //创建UISeachBar控件;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    //提示文本
    searchBar.placeholder = @"请输入商户名、商品名或地址";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    //添加一个占位按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = right;
    
}
- (void)settingRequestParams:(NSMutableDictionary *)params {
    if (self.cityName) {
        params[@"city"] = self.cityName;
    } else {
        params[@"city"] = @"泉州";
    }
    //
    UISearchBar *searchBar = (UISearchBar *)self.navigationItem.titleView;
    if (searchBar.text.length != 0) {
        params[@"keyword"] = searchBar.text;
    } else {
        params[@"keyword"] = @"ktv";
    }
   
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self loadNewDeals];
    
    [searchBar resignFirstResponder];
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
