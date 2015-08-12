//
//  LocationMapViewController.m
//  freego
//
//  Created by Franklin Zhang on 3/30/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import "LocationMapViewController.h"
#import "CLLocation+Sino.h"
@interface LocationMapViewController ()
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
    MKPointAnnotation *lastPointAnnotation;
    UIView *rootModalView;
    UIView *datePicker;
    NSString *targetDate;
    UIBarButtonItem *dateSelectButton;
    NSDateFormatter *dateFormatter;
    MKMapCamera *currentCamera;
    UIButton *centerButton, *dimensionButton;
}
@end

@implementation LocationMapViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildLayout];

    //dateSelectButton.tintColor = [UIColor whiteColor];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 20.0f;
    //[locationManager requestAlwaysAuthorization];

#ifdef __IPHONE_8_0
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
#endif
    [locationManager startUpdatingLocation];

    CLLocation *firstLocation = locationManager.location;//set the center of coordinate to this location
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.03;
    region.span.longitudeDelta = 0.03;
    region.center = firstLocation.coordinate;
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
}
- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) buildLayout
{
    //UIImage *navigationBarImage = [UIImage imageNamed:@"top_bar_background"];
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = NSLocalizedString(@"label.location.title", nil);
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    CGRect viewRect = self.view.frame;
    
    
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, viewRect.size.height)];
    mapView.rotateEnabled = NO;
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    
    [self.view addSubview:mapView];
    
    
    /*centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton setBackgroundImage:[UIImage imageNamed:@"center_locate_button_normal"] forState:UIControlStateNormal];
    [centerButton setBackgroundImage:[UIImage imageNamed:@"center_locate_button_pressed"] forState:UIControlStateNormal];
    centerButton.frame = CGRectMake(viewRect.size.width-40, 116,38,38);
    [centerButton addTarget:self action:@selector(moveToCenter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerButton];*/
    
    dimensionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dimensionButton.frame = CGRectMake(40, viewRect.size.height - 166, 38, 38);
    [dimensionButton setTitle:@"2D" forState:UIControlStateNormal];
    [dimensionButton setTitle:@"3D" forState:UIControlStateSelected];
    [dimensionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:dimensionButton];
    
    //date condition
    
    CGRect appBound = [[UIScreen mainScreen] applicationFrame];
    rootModalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appBound.size.width, appBound.size.height)];
    rootModalView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    
    datePicker = [[UIView alloc] initWithFrame:CGRectMake(0, appBound.size.height, viewRect.size.width, 260)];
    
    UIBarButtonItem *dateCancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerCancel:)];
    UIBarButtonItem *dateDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDone:)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIToolbar *datePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 44)];
    [datePickerToolBar setItems:[NSArray arrayWithObjects:dateCancelButton,spaceButton,dateDoneButton, nil]];
    [datePicker addSubview:datePickerToolBar];
    
    UIDatePicker *datePickerComponent = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, viewRect.size.width, 216)];
    datePickerComponent.datePickerMode = UIDatePickerModeDate;
    [datePickerComponent addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    datePickerComponent.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [datePicker addSubview:datePickerComponent];
}
- (void)viewDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        
        CGPoint offset = [sender translationInView:self.view];
        /*UIView *draggableView = distanceView;
        if(draggableView.center.x + offset.x < 40 || draggableView.center.x + offset.x > kScreenWidth - 40 || draggableView.center.y + offset.y < 150 || draggableView.center.y + offset.y > kScreenHeight - 40)
            return;
        [draggableView setCenter:CGPointMake(draggableView.center.x + offset.x, draggableView.center.y + offset.y)];
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];*/
    }
}


- (void) moveToCenter:(id) sender
{
    [mapView setCenterCoordinate:currentLocation animated:YES];
}


- (void) showDirectionsOnMap:(MKDirectionsResponse *) response
{
    /*for(MKRoute *route in response.routes)
     {
     [mainMapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
     }
     [mainMapView addAnnotation:response.source.placemark];
     [mainMapView addAnnotation:response.destination.placemark];*/
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - MKMapViewDelegate
/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
 {
 if([annotation isKindOfClass:mapView.userLocation.class])
 {
 return nil;
 }
 MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"com.runs.ios.mps"];
 if(pinView == nil)
 {
 pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"com.runs.ios.mps"];
 
 pinView.canShowCallout = YES;
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 100)];
 pinView.leftCalloutAccessoryView = view;
 UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
 pinView.rightCalloutAccessoryView = button;
 }
 
 
 return pinView;
 }*/
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {                [manager requestAlwaysAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:[NSString stringWithFormat:@"Please enable your location service for this app first"]
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
    //for(CLLocation *location in locations)
    // {
    //NSLog(@"Location :%.8f,%.10f",location.coordinate.latitude,location.coordinate.longitude);
    //}
    //[super hideProgress];
    CLLocation *location = [locations lastObject];
    
    CLLocation *GCJ02Location = [location locationMarsFromEarth];
    //[manager stopUpdatingLocation];
    currentLocation = CLLocationCoordinate2DMake(GCJ02Location.coordinate.latitude, GCJ02Location.coordinate.longitude);
    
    
    if(currentCamera == nil && mapView.pitchEnabled)
    {
       
        
        // Create a coordinate structure for the location.
        CLLocationCoordinate2D ground = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
        
        // Create a coordinate structure for the point on the ground from which to view the location.
        CLLocationCoordinate2D eye = CLLocationCoordinate2DMake(currentLocation.latitude+1.0, currentLocation.longitude+1.0);
        
        // Ask Map Kit for a camera that looks at the location from an altitude of 100 meters above the eye coordinates.
        currentCamera = [MKMapCamera cameraLookingAtCenterCoordinate:ground fromEyeCoordinate:eye eyeAltitude:600];
        currentCamera.pitch = 1.5;
        // Assign the camera to your map view.
        mapView.camera = currentCamera;
        NSLog(@"set 3D map");
    }
    //MKCoordinateRegion region = mapView.region;
    //region.center = GCJ02Location.coordinate;
    //[mapView setRegion:region animated:NO];
    
    
    //[self showLastLocation:nil];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //[super hideProgress];
    
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
#pragma mark - MAMapViewDelegate
/*-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
 {
 if(updatingLocation)
 {
 //取出当前位置的坐标
 NSLog(@"current location : latitude = %f,longitude = %f, title=%@",userLocation.coordinate.latitude,userLocation.coordinate.longitude, userLocation.heading);
 //mapView.showsUserLocation = NO;
 if(currentLocation.longitude == 0 && currentLocation.latitude == 0)
 {
 [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
 }
 currentLocation = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
 [self showLastLocation:nil];
 }
 }*/
/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MKPinAnnotationView*annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        if([annotation isEqual:lastPointAnnotation])
        {
            annotationView.image = [UIImage imageNamed:@"location"];
        }
        else
        {
                        annotationView.image = [UIImage imageNamed:@"location"];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.centerOffset = CGPointMake(100, 120);
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        //annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        //annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    else if([annotation isKindOfClass:[MKUserLocation class]])
    {
        //static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        // MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
         //if (annotationView == nil)
         //{
         //annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
         //reuseIdentifier:userLocationStyleReuseIndetifier];
         //}
         //annotationView.image = [UIImage imageNamed:@"current_location"];
         //return annotationView;
        currentLocation = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);

        return nil;
    }
    return nil;
}*/
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 8.f;
        polylineView.strokeColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8];
        //polylineView.lineJoinType = kMKLineJoinRound;//连接类型
        //polylineView.lineCapType = kMKLineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}


@end
