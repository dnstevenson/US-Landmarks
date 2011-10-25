//
//  AllLandmarksMapViewController.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "AllLandmarksMapViewController.h"
#import "DBHelper.h"
#import "LandmarkDetailViewController.h"
#import "EGOImageView.h"

@implementation AllLandmarksMapViewController

@synthesize mapView, landmarks;

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//CLLocationCoordinate2D currentLocation; // = mapView.userLocation.location.coordinate; //= [location coordinate];
	//currentLocation.latitude = 37.250556; //[[[landmarks objectAtIndex:0] latitude] doubleValue]; //37.250556;
	//currentLocation.longitude = -96.358333; //[[[landmarks objectAtIndex:0] longitude] doubleValue]; //-96.358333;	
	
	
	// how far in we're zoomed by default
//	MKCoordinateSpan span;
//	span.latitudeDelta = 0.75; //*(126.766667 - 66.95) ;
//	span.longitudeDelta = 0.75; //*(49.384472 - 24.520833) ;	
//	
//	MKCoordinateRegion region;
//	region.span = span;
//	//region.center = currentLocation;	
//
//	[mapView setRegion:region animated:NO];
//	[mapView regionThatFits:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	// try to dequeue an existing pin view first
	
	MKPinAnnotationView* pinView = nil;
	
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		
		if (firstView == YES) {
			MKCoordinateRegion region;
			
			region.center.latitude = self.mapView.userLocation.coordinate.latitude;
			region.center.longitude = self.mapView.userLocation.coordinate.longitude;
			MKCoordinateSpan span;
			span.latitudeDelta = 0.75; //*(126.766667 - 66.95) ;
			span.longitudeDelta = 0.75; //*(49.384472 - 24.520833) ;	
				
			region.span = span;
			
	//		region.span.latitudeDelta = 0.1;
	//		region.span.longitudeDelta = 0.1;
			
			[self.mapView setRegion:region animated:YES];
			firstView = NO;
		}
		
		return nil;
	}
	if (annotation != mapView.userLocation) {	
		static NSString* AnnotationIdentifier = @"annotationIdentifier";
		pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
		if (pinView == nil)
		{
			MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
			customPinView.animatesDrop = NO;
			customPinView.canShowCallout = YES;
			
			EGOImageView *leftIconImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"transparent_icon_small.png"]];
			NSString *encodedImageNameString = [NSString stringWithFormat:@"%@", [[(Landmark*)annotation imageName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			leftIconImageView.imageURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.stevensonsoftware.com/us_landmarks/image_thumbnails/row_75x75_%@", encodedImageNameString]];
			customPinView.leftCalloutAccessoryView = leftIconImageView;			
			
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"All Landmarks";
	
	firstView = YES;

	landmarks = [[DBHelper getInstance] getAllLandmarks];
	
	MKCoordinateRegion region;	
	CLLocationCoordinate2D location; // = mapView.userLocation.location.coordinate; //= [location coordinate];
	location.latitude = 37.250556; //[[[landmarks objectAtIndex:0] latitude] doubleValue]; //37.250556;
	location.longitude = -96.358333; //[[[landmarks objectAtIndex:0] longitude] doubleValue]; //-96.358333;	
	region.center = location;	
	
	[self.mapView setRegion:region animated:YES];
    [mapView removeAnnotations:mapView.annotations];  // remove any annotations that exist
	[mapView addAnnotations:landmarks];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView release];
	[landmarks release];
	
    [super dealloc];
}


@end
