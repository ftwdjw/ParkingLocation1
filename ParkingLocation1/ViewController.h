//
//  ViewController.h
//  ParkingLocation1
//
//  Created by John Mac on 9/22/13.
//  Copyright (c) 2013 John Wetters. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;

- (IBAction)switchChanged1:(id)sender;

- (IBAction)showInfo:(id)sender;
@end
