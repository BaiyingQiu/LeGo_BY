//
//  DealCell.m
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "DealCell.h"
#import "UIImageView+WebCache.h"

@interface DealCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHI;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *listPricelabel;
@property (weak, nonatomic) IBOutlet UILabel *cureentPrice;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

@end


@implementation DealCell

//-(instancetype)init {
//    if (self = [super init]) {
//        
//    }
//}
-(void)setCell:(TRDeal *)deal {
    
    self.titleLable.text = deal.title;
    self.listPricelabel.text = [NSString stringWithFormat:@"￥%@",deal.list_price];
    self.cureentPrice.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    
//    CGSize size = [[NSString stringWithFormat:@"%@", deal.current_price] sizeWithFont:self.cureentPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, self.cureentPrice.frame.size.height)];
//    CGRect frame = self.cureentPrice.frame;
//    frame.size = size;
//    self.cureentPrice.frame = frame;
    
    self.discountLabel.text = [NSString stringWithFormat:@"%.2f%%折扣", ([deal.current_price floatValue] /[deal.list_price floatValue] ) *100];
    [self.imageViewHI sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
