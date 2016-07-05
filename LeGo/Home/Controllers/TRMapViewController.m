//
//  TRMapViewController.m
//  LeGo
//
//  Created by Tarena on 16/5/30.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "TRMetaDataTool.h"
#import "TRBusiness.h"
#import "TRDeal.h"
#import "TRAnnotation.h"
#import "TRCategory.h"


@interface TRMapViewController () <MKMapViewDelegate, DPRequestDelegate>
//
@property (nonatomic, strong) CLLocationManager *locationMgr;
@property (nonatomic, strong) MKMapView *mapView;
//地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *cityName;

@end

@implementation TRMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.geocoder = [CLGeocoder new];
    self.locationMgr = [CLLocationManager new];
    //iOS8+; Info.plist
    [self.locationMgr requestWhenInUseAuthorization];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

#pragma mark --MKMapViewDelegate
//获取位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //用户所在位置 - 反向地理编码 -> 获取地理位置的城市名字
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            //
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *cityName = placemark.locality;
            
            self.cityName = [cityName substringToIndex:cityName.length - 1];
            NSLog(@"@------------定位城市：%@",self.cityName);
            //发送请求
            [self mapView:self.mapView regionDidChangeAnimated:YES];
            
        } else {
            NSLog(@"获取反向地图失败:%@",error);
        }
        
    }];

}
//挪动地图时调用该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //必须返回用户位置
    if (!self.cityName) {
        return;
    }
    
    /*  city
        latitude
        longitude
        radius:500
     */
    DPAPI *api = [DPAPI new];
    //设置参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:100];
    params[@"city"] = self.cityName;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @500;//默认1000米；可不给定
    
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];

}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //清除地图上所有的大头针对象（内存）
    NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:annotations];
    
    //1解析JSON数据
//    NSLog(@"result:%@",result);
    NSArray *deals = [TRMetaDataTool parseDealsResult:result];
    
//    NSMutableArray *businesses = [[NSMutableArray alloc] initWithCapacity:100];
    
    for (TRDeal *deal in deals) {
        TRCategory *category = [TRMetaDataTool getCategoryWithDeal:deal];
        NSString *imageName = nil;
        if (category) {
            imageName = category.map_icon;
        } else {
            imageName = @"ic_category_default";
        }
        
        NSArray *businessArray = [TRMetaDataTool getAllBusiness:deal];
        for (TRBusiness *business in businessArray) {
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([business.latitude floatValue], [business.longitude floatValue]);
            [self addAnnorationsWithTitle:business.name subTitle:deal.desc imageName:imageName andCoordinate:coordinate];
            
//            [businesses addObject:business];
        }
    }
    //添加大头针对象
    
    
    
}
- (void)addAnnorationsWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageName:(NSString *)imageName andCoordinate:(CLLocationCoordinate2D)coordinate {
    TRAnnotation *annotation = [TRAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = title;
    annotation.subtitle = subTitle;
    annotation.image = [UIImage imageNamed:imageName];
    [self.mapView addAnnotation:annotation];
    

}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //1.给定静态标识
    static NSString *indetifier = @"annotation";
    //2.从缓存池取可复用的对象（MKAnnotationView）
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:indetifier];
    //3.如果 没有 可复用对象，就创建；  如果有就复用
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:indetifier];        
        annotationView.canShowCallout = YES;
        TRAnnotation *TRannotation = (TRAnnotation *)annotation;
        annotationView.image  = TRannotation.image;
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}
-(void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"地图 发送请求失败%@:",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
