//
//  TRBusiness.m
//  LeGo
//
//  Created by Tarena on 16/5/30.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRBusiness.h"

@implementation TRBusiness
//手动的方式把字典中 description 的Key，绑定到 desc上
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.businessID = value;
    }
}
@end
