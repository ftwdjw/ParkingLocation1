//
//  MyAnnotation.m
//  ParkingLocation1
//
//  Created by John Mac on 9/22/13.
//  Copyright (c) 2013 John Wetters. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle{
    self = [super init];
    if (self != nil){
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubTitle;
    }
    return(self);
}


@end
