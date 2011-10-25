//
//  AllLandmarksMapViewController.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Landmark.h"


@interface AllLandmarksMapViewController : UIViewController <MKMapViewDelegate> {

	MKMapView *mapView;
	NSMutableArray *landmarks;
	
	BOOL firstView;
	
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *landmarks;

@end
