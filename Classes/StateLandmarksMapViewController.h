//
//  StateLandmarksMapViewController.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Landmark.h"
#import "State.h"


@interface StateLandmarksMapViewController : UIViewController <MKMapViewDelegate> {

	MKMapView *mapView;
	NSMutableArray *landmarks;
	State *state;
	BOOL changed;

}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *landmarks;
@property (nonatomic, retain) State *state;

@end
