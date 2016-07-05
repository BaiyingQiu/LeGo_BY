//
//  TRMetaDataTool.m
//  LeGo
//
//  Created by Tarena on 16/5/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRMetaDataTool.h"
#import "TRDeal.h"
#import "TRSort.h"
#import "TRCity.h"
#import "TRRegion.h"
#import "TRCategory.h"
#import "TRBusiness.h"
#import "TRMenuData.h"
#import "TRCityGroups.h"

@implementation TRMetaDataTool

+(NSArray *)parseDealsResult:(id)result {
    //取到deals对应的数组
    NSArray *dealsArray = result[@"deals"];
    
    //把字典转成TRDeal,添加到可变数组
    NSMutableArray *deals = [[NSMutableArray alloc] initWithCapacity:20];
    for (NSDictionary *dealDic in dealsArray) {
        TRDeal *deal = [[TRDeal alloc] init];
        //
        [deal setValuesForKeysWithDictionary:dealDic];
        [deals addObject:deal];
    }
    
    return [deals copy];
}

//单例返回
+ (NSArray *)getAllShorts {
    static NSArray *_sortsArray = nil;
    if (!_sortsArray) {
        //
        //
        //
        _sortsArray = [[self alloc] getAndParseWithPlistFile:@"sorts.plist" WithClass:[TRSort class]];
        
    }
    return _sortsArray;
}

+ (NSArray *)getAllCities {
    static NSArray *_citiesArray = nil;
    if (!_citiesArray) {
        _citiesArray = [[self alloc] getAndParseWithPlistFile:@"cities.plist" WithClass:[TRCity class]];
    }
    return _citiesArray;
}

+ (NSArray *)getAllRegionByCityName:(NSString *)cityName {
    //1.取到所有城市数组
    NSArray *cityArray = [self getAllCities];
    //2.通过城市名找到对应的区域数组
    for (TRCity *city in cityArray) {
        if ([city.name isEqualToString:cityName]) {
            //city.regions数组中是字典类型
            return  [[self alloc] getArrayWithArray:city.regions WithClass:[TRRegion class]];
        }
    }
    return nil;
}

+ (NSArray *)getAllCategory {
    static NSArray *_categories = nil;
    if (!_categories) {
        _categories = [[self alloc] getAndParseWithPlistFile:@"categories.plist" WithClass:[TRCategory class]];
    }
    return _categories;
}

+ (NSArray *)getAllBusiness:(TRDeal *)deal {
//    static NSArray *_business = nil;
//    if (!_business) {
//        _business = [[self alloc] getArrayWithArray:deal.businesses WithClass:[TRBusiness class]];
//    }
    NSArray *_business = [[self alloc] getArrayWithArray:deal.businesses WithClass:[TRBusiness class]];
    return _business;
}

+ (TRCategory *)getCategoryWithDeal:(TRDeal *)deal {
    //1.订单的分类数组
    NSArray *categoryArray = deal.categories;
    //2.获取categories.plist所有数据
    NSArray *categoryArrayFromPlist = [self getAllCategory];
    //3.两层循环
    for (NSString *categoryStr in categoryArray) {
        //
        for (TRCategory *category in categoryArrayFromPlist) {
            //判断
            if ([category.name isEqualToString:categoryStr]) {
                return category;
            }
            //从子分类数组找(某个对象是否在数组中)
            if ([category.subcategories containsObject:categoryStr]) {
                return category;
            }
        }
    }
    return nil;
}

+ (NSArray *)getAllMenuData {
    static NSArray *_menuDatas = nil;
    if (!_menuDatas) {
        _menuDatas = [[self alloc] getAndParseWithPlistFile:@"menuData.plist" WithClass:[TRMenuData class]];
    }
    return _menuDatas;
}

+ (NSArray *)getAllCityGroup {
    static NSArray *_cityGtoup = nil;
    if (nil == _cityGtoup) {
        _cityGtoup = [[self alloc] getAndParseWithPlistFile:@"cityGroups.plist" WithClass:[TRCityGroups class]];
    }
    return _cityGtoup;
}

- (NSArray *)getAndParseWithPlistFile:(NSString *)plistFileName WithClass:(Class) modelClass {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    //
    return [self getArrayWithArray:plistArray WithClass:modelClass];
    
}

/** 将 装有字典 类型的 数组 转化为模型*/
- (NSArray *)getArrayWithArray:(NSArray *)array WithClass:(Class)modelClass {
    NSMutableArray *arrayM = [NSMutableArray new];
    for (NSDictionary *dic in array) {
        id model = [modelClass new];
        [model setValuesForKeysWithDictionary:dic];
        [arrayM addObject:model];
    }
    return [arrayM copy];
}

//储存城市名字的静态变量
static NSString *_cityName = nil;
+ (void)setSelectedCityName:(NSString *)cityName {
    _cityName = cityName;
}
//
+ (NSString *)getSelectedCityName {
    return _cityName;
}

@end
