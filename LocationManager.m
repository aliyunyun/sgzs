//
//  LocationManager.m
//  Freego
//
//  Created by Franklin Zhang on 2/14/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import "CLLocation+Sino.h"

static LocationManager *sharedInstance;
@implementation LocationManager
{
    NSString *longitude;
    NSString *latitude;
    
}
@synthesize locationManager;
@synthesize locationCallback;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (void) startLocate
{
    if(locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    //[locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 200.0f;
    [locationManager startUpdatingLocation];
    
}

- (void) stopLocate
{
    if(locationManager != nil)
       [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:NSLocalizedString(@"label.main.enable_location_information", nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case kCLAuthorizationStatusAuthorized:
            [manager startUpdatingLocation];
            break;
        default:
            
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for(CLLocation *location in locations)
    {
        NSLog(@"Location :%.8f,%.10f",location.coordinate.latitude,location.coordinate.longitude);
    }
    CLLocation *location = [locations lastObject];
    CLLocation *GCJ02Location = [location locationMarsFromEarth];
    
    if (locationCallback != nil && locationCallback != NULL) {
        locationCallback(GCJ02Location.coordinate.longitude,GCJ02Location.coordinate.latitude);
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Fail to location :%@",error.description);
    /*UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Common.Failure",nil)
     message:NSLocalizedString(@"label.main.location_error_information", nil)
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
     otherButtonTitles:nil];
     [alert show];*/
}
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    //[super hideProgress];
    
    NSLog(@"Fail to location :%@",error.description);
    /*UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Common.Failure",nil)
     message:error.description
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
     otherButtonTitles:nil];
     [alert show];*/
}
@end
