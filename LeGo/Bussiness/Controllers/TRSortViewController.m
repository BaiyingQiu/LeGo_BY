//
//  TRSortViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRSortViewController.h"
#import "TRBusinessHeaderView.h"
#import "TRMetaDataTool.h"
#import "TRSort.h"

@interface TRSortViewController ()
//数据源
@property (nonatomic, strong) NSArray *sortsArray;

@end

static const CGFloat buttonW = 100;
static const CGFloat buttonH = 30;
static const CGFloat inset = 20;
//static const CGFloat buttonY = 100;

@implementation TRSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.sortsArray = [TRMetaDataTool getAllShorts];
    //循环创建并添加Button
    for (int index = 0; index < self.sortsArray.count; index++) {
        UIButton *button = [UIButton new];
        //背景
        button.frame = CGRectMake(inset, index * (buttonH + inset) + inset, buttonW, buttonH);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        //文本颜色
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //字体
        button.titleLabel.font = [UIFont systemFontOfSize:12 weight:10];
        //文本
        TRSort *sort = self.sortsArray[index];
        [button setTitle:sort.label forState:UIControlStateNormal];
        //设置tag
        button.tag = 1000 + index;
        //  添加触发事件
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //
        [self.view addSubview:button];
        
    }
    //设置弹出框的宽和高
    self.preferredContentSize = CGSizeMake(2 * inset + buttonW, self.sortsArray.count * (buttonH + inset) + inset);
    
}
-(void)clickButton:(UIButton *)sender {
    //1.发送通知
    //取到点中button对应的sort对象
    TRSort *sort = self.sortsArray[sender.tag - 1000];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRSortDidChange" object:self userInfo:@{@"TRSort" : sort}];
    NSLog(@"%@",sender.titleLabel.text);
    //2.收回控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
