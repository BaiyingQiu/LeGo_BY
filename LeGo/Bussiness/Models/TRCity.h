//
//  TRCity.h
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCity : NSObject

/** 城市的名字 */
@property (nonatomic, copy) NSString *name;
/** 城市拼音 */
@property (nonatomic, copy) NSString *pinYin;
/** 城市拼音缩写 */
@property (nonatomic, copy) NSString *pinYinHead;
/** 该城市所对应的所有区域(主区+子区域)数组 */
@property (nonatomic, strong) NSArray *regions;

@end
