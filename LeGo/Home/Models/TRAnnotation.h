//
//  TRAnnotation.h
//  LeGo
//
//  Created by Tarena on 16/5/30.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TRAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic,  copy) NSString *title;
@property (nonatomic,  copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;




@end
