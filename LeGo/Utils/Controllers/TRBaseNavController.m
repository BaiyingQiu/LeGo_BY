//
//  TRBaseNavController.m
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRBaseNavController.h"
#import "UIColor+FlatUI.h"

@interface TRBaseNavController ()

@end

@implementation TRBaseNavController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置全局导航栏样式
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexCode:@"eb5352"]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.tabBarItem.selectedImage = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                     
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexCode:@"eb5352"]} forState:UIControlStateSelected];
    
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
