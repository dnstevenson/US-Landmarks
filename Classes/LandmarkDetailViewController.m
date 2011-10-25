//
//  LandmarkDetailViewController.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "LandmarkDetailViewController.h"
#import "WebViewController.h"
#import "LandmarkHeaderView.h"
#import "LandmarkMapCell.h"
#import "UserDBHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation LandmarkDetailViewController

@synthesize tableView, landmark, inModal, headerView, mapCell;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int count = 5;
	return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: {
			return @"Name";
			break;
		}
		case 1: {
			return @"Description";
			break;
		}
		case 2: {
			return @"Date Commissioned";
			break;
		}
		case 3: {
			return @"Wikipedia Entry";
			break;
		}
		case 4: {
			return @"Map";
			break;
		}
		default:
			return @"";
			break;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
//	Landmark *landmark = [data objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [inTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone; //UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];			
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

	switch (indexPath.section) {
		case 0:
		{
			cell.textLabel.text = [landmark name];
			break;
		}
		case 1:
		{
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.textLabel.numberOfLines = 0;
			if ([[landmark description] length] > 0 && [landmark description] != nil && ![[landmark description] isKindOfClass:[NSNull class]]) {			
				cell.textLabel.text = [landmark description];
			} else {
				cell.textLabel.text = @"Unavailable";
			}
			break;
		}
		case 2:
		{
			if ([[landmark date] length] > 0 && [landmark date] != nil && ![[landmark date] isKindOfClass:[NSNull class]]) {			
				cell.textLabel.text = [landmark date];
			} else {
				cell.textLabel.text = @"Unavailable";
			}
			break;
		}
		case 3:
		{
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = [[landmark wikipediaURL] absoluteString];
			break;
		}
		case 4:
		{
			if ([[landmark latitude] length] > 0 && [landmark latitude] != nil && ![[landmark latitude] isKindOfClass:[NSNull class]]) {	

				static NSString *MyIdentifier = @"MapCell";
				
				LandmarkMapCell *cell2 = (LandmarkMapCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
				if (cell2 == nil) {
					[[NSBundle mainBundle] loadNibNamed:@"LandmarkMapCell" owner:self options:nil];
					cell2 = mapCell;
					self.mapCell = nil;
				}				
				[cell2.mapView addAnnotation:landmark];
				
				CLLocationCoordinate2D location;
				location.latitude = [landmark.latitude doubleValue]; //37.250556;
				location.longitude = [landmark.longitude doubleValue]; //-96.358333;	
				
				// how far in we're zoomed by default
				MKCoordinateSpan span;
				span.latitudeDelta = 0.05; //1.04*(126.766667 - 66.95) ;
				span.longitudeDelta = 0.05; //1.04*(49.384472 - 24.520833) ;	
				
				MKCoordinateRegion region;
				region.span = span;
				region.center = location;	
				
				[cell2.mapView setRegion:region animated:NO];
				[cell2.mapView regionThatFits:region];
				
				cell2.mapView.layer.cornerRadius = 10;
				return cell2;
				
			} else {
				cell.textLabel.text = @"Unavailable";
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
		}
		default:
			break;
	}
    
    return cell;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKPinAnnotationView* pinView = nil;
	
	if (annotation != mapView.userLocation) {	
		static NSString* AnnotationIdentifier = @"annotationIdentifier";
		pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
		if (pinView == nil)
		{
			MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
			customPinView.animatesDrop = YES;
			customPinView.canShowCallout = NO;
			
			return customPinView;
		}
		else
		{
			pinView.annotation = annotation;
		}
	}
	return pinView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellText = @""; 
	switch (indexPath.section) {
		case 1: {
			if ([[landmark description] length] > 0 && [landmark description] != nil && ![[landmark description] isKindOfClass:[NSNull class]]) {			
				cellText = [landmark description];
			} else {
				cellText = @"Unavailable";
			}

			UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:18];
			CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
			CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
			
			return labelSize.height + 10;
			break;
		}
		case 4: {
			
			if ([[landmark latitude] length] > 0 && [landmark latitude] != nil && ![[landmark latitude] isKindOfClass:[NSNull class]]) {			
				return 155;
			}
		}
	}

	return 44;
	
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	if (section == 3) {
		WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
		webViewController.url = [landmark wikipediaURL];
		webViewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:webViewController animated:YES];
		[webViewController release];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	}
}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = [landmark name];
	tableView.tableHeaderView = nil;
	
	if ([[landmark imageName] length] > 0 && [landmark imageName] != nil && ![[landmark imageName] isKindOfClass:[NSNull class]]) {
		
		NSString *encodedImageNameString = [[NSString stringWithFormat:@"%@", [landmark imageName]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		[headerView setImageLocation:[NSString stringWithFormat:@"http://www.stevensonsoftware.com/us_landmarks/image_thumbnails/header_320x175_%@", encodedImageNameString]];
		
		tableView.tableHeaderView = headerView;
	}	
}

- (void) viewDidLoad {
	
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LandmarkHeaderView" owner:nil options:nil];
	for (id currentObject in nibObjects) {
		if ([currentObject isKindOfClass:[LandmarkHeaderView class]]) {
			self.headerView = (LandmarkHeaderView*) currentObject; 
		}
	}		
	
	tableView.backgroundColor = [UIColor clearColor];
	
	[self setRightNavigationItem];
	
}

- (void) setRightNavigationItem {
	UserDBHelper *userDBHelper = [UserDBHelper getInstance];	
	if (![userDBHelper favoriteExists:landmark.id]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"rate_small_white.png"]
																				   style: UIBarButtonItemStyleBordered
																				  target: self
																				  action: @selector(addFavorite:)] autorelease];
	} else {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"remove_small_white.png"]
																				   style: UIBarButtonItemStyleBordered
																				  target: self
																				  action: @selector(removeFavorite:)] autorelease];
	}
}

- (void)addFavorite:(id)sender {
	UserDBHelper *userDBHelper = [UserDBHelper getInstance];	
	if (![userDBHelper favoriteExists:landmark.id]) {
		[userDBHelper addFavorite:landmark.id];
	}	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"remove_small_white.png"]
																			   style: UIBarButtonItemStyleBordered
																			  target: self
																			  action: @selector(removeFavorite:)] autorelease];
}
- (void)removeFavorite:(id)sender {
	UserDBHelper *userDBHelper = [UserDBHelper getInstance];	
	if ([userDBHelper favoriteExists:landmark.id]) {
		[userDBHelper removeFavorite:landmark.id];
	}	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"rate_small_white.png"]
																			   style: UIBarButtonItemStyleBordered
																			  target: self
																			  action: @selector(addFavorite:)] autorelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.mapCell = nil;
	self.tableView = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[tableView release];
	[landmark release];
	[headerView release];
	[super dealloc];
}


@end
