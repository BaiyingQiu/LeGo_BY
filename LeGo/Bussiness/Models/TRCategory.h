//
//  TRCategory.h
//  LeGo
//
//  Created by Tarena on 16/5/28.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCategory : NSObject

/** 分类名 */
@property (nonatomic, strong) NSString *name;
/** 地图图标 */
@property (nonatomic, copy) NSString *map_icon;
/** 选中的图标 */
@property (nonatomic, copy) NSString *highlighted_icon;
/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 选中图标（小） */
@property (nonatomic, copy) NSString *small_highlighted_icon;
/** 图标（小） */
@property (nonatomic, copy) NSString *small_icon;
/** 子分类 */
@property (nonatomic, strong) NSArray *subcategories;

@end