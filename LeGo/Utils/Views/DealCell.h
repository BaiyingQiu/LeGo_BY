//
//  DealCell.h
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRDeal.h"


@interface DealCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *imageViewHI;
//@property (weak, nonatomic) IBOutlet UILabel *titleLable;
//@property (weak, nonatomic) IBOutlet UILabel *listPricelabel;
//@property (weak, nonatomic) IBOutlet UILabel *cureentPrice;
//@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

- (void)setCell:(TRDeal *)deal;

@end
