//
//  TRDeal.h
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDeal : NSObject
//声明10个属性

/** 订单标题 */
@property (nonatomic, strong) NSString *title;

/** 促销信息 */
//@property (nonatomic, strong) NSString *description;//已被父类使用,需要更换名字，并实现KVC中 setValue:forUndefinedKey: 的方法
@property (nonatomic, strong) NSString *desc;

/** 订单的原价格 */
@property (nonatomic, strong) NSNumber *list_price;
/** 订单团购价 */
@property (nonatomic, strong) NSNumber *current_price;
/** 订单已售数量 */
@property (nonatomic, strong) NSNumber *purchase_count;
/** 订单所属的订单数组 */
@property (nonatomic, strong) NSArray *categories;
/** 订单大图 */
@property (nonatomic, strong) NSString *image_url;
/** 订单小图 */
@property (nonatomic, strong) NSString *s_image_url;
/** 订单H5页面 */
@property (nonatomic, copy) NSString *deal_h5_url;
/** 订单可使用的商家数 */
@property (nonatomic, strong) NSArray *businesses;


@end
