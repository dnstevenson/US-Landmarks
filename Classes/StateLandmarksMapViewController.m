//
//  StateLandmarksMapViewController.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "StateLandmarksMapViewController.h"
#import "LandmarkDetailViewController.h"
#import "EGOImageView.h"

@implementation StateLandmarksMapViewController

@synthesize mapView, landmarks, state;

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = [state name];
	
	if (changed) {
		[mapView removeAnnotations:mapView.annotations]; 
		
		[mapView addAnnotations:landmarks];
		
		CLLocationCoordinate2D location;
		location.latitude = [[state latitude] doubleValue]; 
		location.longitude = [[state longitude] doubleValue]; 	
		
		// how far in we're zoomed by default
		MKCoordinateSpan span;
		span.latitudeDelta = 5.0; 
		span.longitudeDelta = 5.0;	
		
		MKCoordinateRegion region;
		region.span = span;
		region.center = location;	
		
		[mapView setRegion:region animated:NO];
		[mapView regionThatFits:region];
	}
	
	changed = NO;
}

- (void) setState:(State *) inState {
	state = [inState retain];
	changed = YES;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	// try to dequeue an existing pin view first
	
	MKPinAnnotationView* pinView = nil;
	
	if (annotation != mapView.userLocation) {	
		static NSString* AnnotationIdentifier = @"annotationIdentifier";
		pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
		if (pinView == nil)
		{
			MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
			customPinView.animatesDrop = YES;
			customPinView.canShowCallout = YES;

			EGOImageView *leftIconImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"transparent_icon_small.png"]];
			
			NSString *encodedImageNameString = [NSString stringWithFormat:@"%@", [[(Landmark*)annotation imageName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			leftIconImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.stevensonsoftware.com/us_landmarks/image_thumbnails/row_75x75_%@", encodedImageNameString]];
			
			customPinView.leftCalloutAccessoryView = leftIconImageView;			
            [leftIconImageView release];
			
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			customPinView.rightCalloutAccessoryView = rightButton;			
			
			return customPinView;
		}
		else
		{
			pinView.annotation = annotation;
		}
	}
	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{
	NSLog(@"calloutAccessoryControlTapped");
	
	Landmark *landmark = (Landmark*)annotationView.annotation;
	LandmarkDetailViewController *landmarkDetailViewController = [[LandmarkDetailViewController alloc] initWithNibName:@"LandmarkDetailViewController" bundle:nil];
	landmarkDetailViewController.landmark = landmark;
	[self.navigationController pushViewController:landmarkDetailViewController animated:YES];	
	[landmarkDetailViewController release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[mapView release];
	[landmarks release];
	[state release];
	
    [super dealloc];
}


@end
