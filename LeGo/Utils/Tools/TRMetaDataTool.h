//
//  TRMetaDataTool.h
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRDeal;
@class TRCategory;

@interface TRMetaDataTool : NSObject

/**返回订单的所有数组, 给定服务器返回的数据（JSON）*/
+ (NSArray *)parseDealsResult:(id) result;

/** 返回所有 排序名字 的数组（TRSort）*/
+ (NSArray *)getAllShorts;

/** 返回所有城市数组（TRCity）*/
+ (NSArray *)getAllCities;

/** 通过城市名返回所有城市数组（TRRegion）*/
+ (NSArray *)getAllRegionByCityName:(NSString *) cityName;

/** 返回所有 分类 的数组（TRCategory） */
+ (NSArray *)getAllCategory;

/** 返回商家位置的信息的数组 */
+ (NSArray *)getAllBusiness:(TRDeal *)deal;

/** 给定订单对象，返回该订单所属分类 */
+ (TRCategory *)getCategoryWithDeal:(TRDeal *)deal;

/** 返回所有主页分类信息 */
+ (NSArray *)getAllMenuData;

/** 设置城市名字（用户所在城市 或用户自定义的城市）*/
+ (void)setSelectedCityName:(NSString *)cityName;
/** 获取城市名字 */
+ (NSString *)getSelectedCityName;

/** 返回所有城市的数组 */
+ (NSArray *)getAllCityGroup;

@end
