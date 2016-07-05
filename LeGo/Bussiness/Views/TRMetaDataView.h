//
//  TRMetaDataView.h
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMetaDataView : UIView
/** 主区域表示图 */
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/** 子区域表示图 */
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@end
