//
//  ViewController.m
//  ParkingLocation1
//
//  Created by John Mac on 9/22/13.
//  Copyright (c) 2013 John Wetters. All rights reserved.
//

#import "ViewController.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "MyAnnotation.h"

@interface ViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathView *crumbView;

@end

@implementation ViewController
float MyLatitude,MyLongitude;
int i=0;
BOOL startNow=0;
BOOL gotAnnotation=0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    
    // Note: we are using Core Location directly to get the user location updates.
    // We could normally use MKMapView's user location update delegation but this does not work in
    // the background.  Plus we want "kCLLocationAccuracyBestForNavigation" which gives us a better accuracy.
    //
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; // Tells the location manager to send updates to this object
    
    // By default use the best accuracy setting (kCLLocationAccuracyBest)
	//
	// You mau instead want to use kCLLocationAccuracyBestForNavigation, which is the highest possible
	// accuracy and combine it with additional sensor data.  Note that level of accuracy is intended
	// for use in navigation applications that require precise position information at all times and
	// are intended to be used only while the device is plugged in.
    //
    
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    /*
     // hide the prefs UI for user tracking mode - if MKMapView is not capable of it
     if (![self.map respondsToSelector:@selector(setUserTrackingMode:animated:)])
     {
     self.trackUserButton.hidden = self.trackUserLabel.hidden = YES;
     }
     */
    
    [self.locationManager startUpdatingLocation];
    
    //track heading
    [self.map setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:NO];
    
    self.map.delegate = self;
    
    self.map.mapType = MKMapTypeHybrid;
    
    /* This is just a sample location */
    self.map.showsUserLocation=YES;
    
    
    
    NSLog(@"end viewDidLoad ");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapKit

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //diaplay coordinates in console output
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          newLocation.coordinate.latitude,
          newLocation.coordinate.longitude);
    
    //store latest coordinates for starting pin location
    MyLatitude=newLocation.coordinate.latitude;
    MyLongitude=newLocation.coordinate.longitude;
    NSLog(@"i is equal to=%i",i);
    
    if (newLocation)
        i=i+1;
    {
        if(startNow==1 && gotAnnotation==0)
        {
            /* Create the annotation using the location */
            MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinates: newLocation.coordinate title:@"My Parking Location" subTitle:@"My Sub Title"];
            
            /* And eventually add it to the map */
            [self.map addAnnotation:annotation];
            gotAnnotation=1;
            NSLog(@"got annotation");
        }
        
        
		
		// make sure the old and new coordinates are different
        if ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
            (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if (startNow==0 && i==1)
            {
                //from IOS recipe
                self.view.backgroundColor = [UIColor whiteColor];
                
                // Create a map as big as our view
                //self.map = [[MKMapView alloc] initWithFrame:self.view.bounds];
                //make map hybrid view
                self.map.mapType = MKMapTypeHybrid;
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 50, 50);
                //make view 50m square
                //put annotation in here
                self.map.delegate = self;
                
                [self.map setRegion:region animated:YES];
                
                
                //Add it to our view
                [self.view addSubview:self.map];
                
                
                self.map.showsUserLocation=YES;
                
                
                NSLog(@"initialize startNow=0 i=1");
                NSLog(@"startNow is equal to=%i",startNow);
                NSLog(@"i is equal to=%i",i);
                
            }
            if (startNow==1 )
            {
                
                
                
                
                if(!self.crumbs)
                {
                    
                    NSLog(@"first cooordinate");
                    NSLog(@"i is equal to=%i",i);
                    
                    // This is the first time we're getting a location update, so create
                    // the CrumbPath and add it to the map.
                    //
                    _crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
                    
                    [self.map addOverlay:self.crumbs];
                    
                    
                    /*
                     
                     // Create the annotation using the location
                     MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinates: newLocation.coordinate title:@"My Parking Location" subTitle:@"My Sub Title"];
                     
                     // And eventually add it to the map
                     [self.map addAnnotation:annotation];
                     gotAnnotation=1;
                     NSLog(@"got annotation");
                     */
                    
                    
                }
                
                
                else
                {
                    // This is a subsequent location update.
                    // If the crumbs MKOverlay model object determines that the current location has moved
                    // far enough from the previous location, use the returned updateRect to redraw just
                    // the changed area.
                    //
                    // note: iPhone 3G will locate you using the triangulation of the cell towers.
                    // so you may experience spikes in location data (in small time intervals)
                    // due to 3G tower triangulation.
                    //
                    MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate];
                    
                    NSLog(@"update Counter subsequent location");
                    
                    if (!MKMapRectIsNull(updateRect))
                    {
                        
                        NSLog(@"i is equal to=%i",i);
                        NSLog(@"update crumb rectangle ");
                        
                        // There is a non null update rect.
                        // Compute the currently visible map zoom scale
                        MKZoomScale currentZoomScale = (CGFloat)(self.map.bounds.size.width / self.map.visibleMapRect.size.width);
                        // Find out the line width at this zoom scale and outset the updateRect by that amount
                        CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                        updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                        // Ask the overlay view to update just the changed area.
                        [self.crumbView setNeedsDisplayInMapRect:updateRect];
                    }
                    
                }
            }
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if (!self.crumbView)
    {
        
        _crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
        
        NSLog(@"crumb init");
        
    }
    return self.crumbView;
}




- (IBAction)switchChanged:(id)sender {
    
    
    UISwitch *theSwitch = sender;
    if(theSwitch.isOn){
        NSLog(@"Switch is on.");
        // Start updating location
        startNow=1;
        
        NSLog(@"start button pressed");
        NSLog(@"startNow=%i",startNow);
        
        
    }else {
        NSLog(@"Switch is off.");
        NSLog(@"stop button pressed");
                startNow=0;
        
        MyAnnotation *annotation = [ _map.annotations mutableCopy ] ;
        //[ MyAnnotation removeObject:_map.userLocation ] ;
        //[self.map selectAnnotation:_map.*annotation animated:YES];
        [ self.map removeAnnotations: (NSArray*) annotation ] ;
        // Erase polyline and polyline view if not nil.
        gotAnnotation=0;
        [ self.map removeOverlay:self.crumbs] ;
        
        
        if (self.crumbs != nil) {
            //[_routeLineView release];
            self.crumbs = nil;
        }
        
        if (self.crumbView != nil) {
            //[_routeLineView release];
            self.crumbView = nil;
        }
        
    }

}

- (IBAction)switchChanged1:(id)sender {
    UISwitch *theSwitch = sender;
    if(theSwitch.isOn){
        NSLog(@"Switch is on.");
        // Start updating location
        startNow=1;
        
        NSLog(@"start button pressed");
        NSLog(@"startNow=%i",startNow);}
}

- (IBAction)showInfo:(id)sender {
    NSLog(@"Info button is pressed.");
}
@end
