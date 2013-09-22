//
//  MyAnnotation.h
//  ParkingLocation1
//
//  Created by John Mac on 9/22/13.
//  Copyright (c) 2013 John Wetters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                     title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle;


@end
