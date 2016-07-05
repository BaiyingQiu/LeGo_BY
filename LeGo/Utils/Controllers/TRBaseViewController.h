//
//  TRBaseViewController.h
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRBaseViewController : UIViewController


/** 声明tableView属性 */
@property (nonatomic, strong) UITableView *tableView;

//父类声明/调用，由子类实现（设置参数）
- (void)settingRequestParams:(NSMutableDictionary *)params;


//父类实现，子类调用
/** 发送新的请求（page = 1)*/
- (void)loadNewDeals;

@end
