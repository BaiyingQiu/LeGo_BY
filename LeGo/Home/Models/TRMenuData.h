//
//  TRMenuData.h
//  LeGo
//
//  Created by Tarena on 16/5/31.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMenuData : NSObject

/** 主页分类名 */
@property (nonatomic, copy) NSString *title;
/** 分类名对应的图片 */
@property (nonatomic, strong) NSString *image;

@end
