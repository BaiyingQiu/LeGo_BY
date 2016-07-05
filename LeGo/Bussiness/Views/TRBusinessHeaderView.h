//
//  TRBusinessHeaderView.h
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRBusinessHeaderView : UIView

/** 分类按钮 */
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
/** 区域按钮 */
@property (weak, nonatomic) IBOutlet UIButton *regionButton;
/** 排序按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sortButton;

@end
