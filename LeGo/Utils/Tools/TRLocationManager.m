//
//  TRLocationManager.m
//  Demo01_Encapsulate
//
//  Created by tarena on 16/5/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRLocationManager.h"

@interface TRLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
//记录用户的位置的block(block属性声明和.h中的block一样)
@property (nonatomic, strong) LocationManagerCompletionHandler completionBlock;
@end

@implementation TRLocationManager

+ (instancetype)sharedLocationManager {
    static TRLocationManager *sharedLoationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoationManager = [[TRLocationManager alloc] init];
    });
    return sharedLoationManager;
}
//在init方法中初始化值(看懂)
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化location为nil
        _location = nil;
        _geocoder = [[CLGeocoder alloc] init];
        //......
    }
    return self;
}
- (void)upDateCityNameWithCompletionHandler:(CityNameWithCompletionHandler)completion {
    [self updateLocationWithCompletionHandler:^(CLLocation *location, NSError *error) {
        if (!error) {
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {                                
                    CLPlacemark *placemark = [placemarks lastObject];
//                NSLog(@"%@",placemark.locality);
//                NSLog(@"+++++%@", [NSThread currentThread]);
                NSString *cityname = [placemark.locality substringToIndex:placemark.locality.length - 1];
                NSLog(@"当前定位城市：%@",cityname);
                completion(cityname, nil);
            }];
        } else {
            completion(nil,error);
        }
            }];
}


- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        //1.初始化manager对象
        _locationManager = [CLLocationManager new];
        //2.征求用户的同意(iOS8+;Info.plist)
        [_locationManager requestWhenInUseAuthorization];
        //3.设置代理
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)updateLocationWithCompletionHandler:(LocationManagerCompletionHandler)completion {
    //判断用户是否把“定位功能”打开, 如果没有打开，给控制器返回错误
    if (![CLLocationManager locationServicesEnabled]) {
        //1.创建NSError对象，传给completion
        NSError *error = [NSError errorWithDomain:@"cn.tarena.loation" code:10 userInfo:[NSDictionary dictionaryWithObject:@"location service is disabled" forKey:NSLocalizedDescriptionKey]];
        completion(nil, error);
        //2.直接return
        return;
    }
    
    //调用开始定位
    [self.locationManager startUpdatingLocation];
    //把completion赋值给block属性(两个block对象的地址指向同一片内存)
    self.completionBlock = completion;
}
//成功返回用户的位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //停止定位
    [self.locationManager stopUpdatingLocation];
    //获取最新的用户位置
    CLLocation *userLocation = [locations lastObject];
    //把用户的位置赋值给.h的属性
    _location = userLocation;
    
    //把用户的位置传给completionBlock属性(调用)
    if (self.completionBlock) {
        self.completionBlock(userLocation, nil);
        //把当前的block对象赋值为nil
        self.completionBlock = nil;
    }
}
//失败返回用户的位置
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    //把错误error对象回传
    if (self.completionBlock) {
        self.completionBlock(nil, error);
    }
}








@end
