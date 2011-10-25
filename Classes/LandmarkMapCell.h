//
//  LandmarkMapCell.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/12/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LandmarkMapCell : UITableViewCell <MKMapViewDelegate> {

	MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
