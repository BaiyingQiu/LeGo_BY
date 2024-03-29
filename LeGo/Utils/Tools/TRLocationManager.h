//
//  TRLocationManager.h
//  Demo01_Encapsulate
//
//  Created by tarena on 16/5/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationManagerCompletionHandler)(CLLocation *location, NSError *error);
typedef void (^CityNameWithCompletionHandler)(NSString *cityName, NSError *error);
@interface TRLocationManager : NSObject

//返回已经存储的用户的位置(目的：只是获取用户的位置)
@property (nonatomic, readonly) CLLocation *location;

//返回单例类方法(GCD)
+ (instancetype)sharedLocationManager;
//给定block参数，获取用户位置
- (void)updateLocationWithCompletionHandler:(LocationManagerCompletionHandler)completion;
- (void)upDateCityNameWithCompletionHandler:(CityNameWithCompletionHandler)completion;








@end
