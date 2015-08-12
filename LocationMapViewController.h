//
//  LocationMapViewController.h
//  freego
//
//  Created by Franklin Zhang on 3/30/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationMapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
    MKMapView *mapView;
}

@end
