//
//  TRTableViewCell.h
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRTableViewCell : UITableViewCell
/** 设置 没有imageView 的cell （包含复用方法）*/
+ (instancetype) cellWithView:(UITableView *)table withImageName:(NSString *)imageName withSeletedName:(NSString *)seletedName;
/** 设置 包含imageView 的cell （包含复用方法） */
+ (instancetype) cellImageViewWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withSeletedName:(NSString *)seletedName;
@end
