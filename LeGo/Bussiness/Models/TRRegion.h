//
//  TRRegion.h
//  LeGo
//
//  Created by Tarena on 16/5/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRRegion : NSObject

/** 主区域的名字 */
@property (nonatomic, copy) NSString *name;
/** 子区域名字数组 */
@property (nonatomic, copy) NSArray *subregions;

@end
