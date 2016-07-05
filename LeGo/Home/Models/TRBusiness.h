//
//  TRBusiness.h
//  LeGo
//
//  Created by Tarena on 16/5/30.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRBusiness : NSObject

/** 商户名 */
@property (nonatomic, copy) NSString *name;
/** 促销信息 */
//@property (nonatomic, copy) NSString *message;
/** 店铺id */
@property (nonatomic, assign) NSNumber *businessID;
/** 所在城市 */
@property (nonatomic, copy) NSString *city;
/** 经度 */
@property (nonatomic, assign) NSNumber *latitude;
/** 纬度 */
@property (nonatomic, assign) NSNumber *longitude;
/** 店铺url */
@property (nonatomic, copy) NSString *url;
/** 店铺H5地址 */
@property (nonatomic, copy) NSString *h5_url;


@end
