//
//  LocationManager.h
//  Freego
//
//  Created by Franklin Zhang on 2/14/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
+ (instancetype)sharedInstance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,copy) void(^locationCallback)(double longitude,double latitude);

- (void) startLocate;
- (void) stopLocate;

@end
