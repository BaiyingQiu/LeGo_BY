//
//  TRTableViewCell.m
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRTableViewCell.h"

@implementation TRTableViewCell

+(instancetype)cellWithView:(UITableView *)table withImageName:(NSString *)imageName withSeletedName:(NSString *)seletedName {
    static NSString *indentifier = @"cell";
    TRTableViewCell *cell = [table dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:seletedName]];
    
    return cell;
}

+ (instancetype)cellImageViewWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withSeletedName:(NSString *)seletedName {
    static NSString *indentifier = @"cell";
    TRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
//    UIView *view = [[UIView alloc] initWithFrame:cell.imageView.frame];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:seletedName]];
    
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
