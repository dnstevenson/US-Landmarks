//
//  LandmarksViewController.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "LandmarksViewController.h"
#import "Landmark.h"
#import "DBHelper.h"
#import "LandmarkCell.h"
#import "LandmarkDetailViewController.h"
#import "StateLandmarksMapViewController.h"

@implementation LandmarksViewController

@synthesize tableView, data, state;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	Landmark *landmark = [data objectAtIndex:indexPath.row];
    
    LandmarkCell *cell = (LandmarkCell*)[inTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[LandmarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    cell.nameLabel.text = [landmark name];
	
	NSString *encodedImageNameString = [[NSString stringWithFormat:@"%@", [landmark imageName]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[cell setImageLocation:[NSString stringWithFormat:@"http://www.stevensonsoftware.com/us_landmarks/image_thumbnails/row_75x75_%@", encodedImageNameString]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LandmarkDetailViewController *landmarkDetailViewController = [[LandmarkDetailViewController alloc] initWithNibName:@"LandmarkDetailViewController" bundle:nil];
	landmarkDetailViewController.landmark = [data objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:landmarkDetailViewController animated:YES];
	[landmarkDetailViewController release];
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = [state name];

	data = [[DBHelper getInstance] getLandmarksForState:[state id]];	
	[self.tableView reloadData];	
	[super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *mapLandmarks = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_white.png"] 
																	  style:UIBarButtonItemStyleBordered
																	 target: self
																	 action: @selector(showOnMap:)] autorelease];
	self.navigationItem.rightBarButtonItem = mapLandmarks;	
	self.tableView.separatorColor = [UIColor whiteColor];
	
}

-(IBAction)showOnMap:(id)sender {
	StateLandmarksMapViewController *stateLandmarksMapViewController = [[StateLandmarksMapViewController alloc] initWithNibName:@"StateLandmarksMapViewController" bundle:nil];
	stateLandmarksMapViewController.landmarks = data;
	stateLandmarksMapViewController.state = state;
	[self.navigationController pushViewController:stateLandmarksMapViewController animated:YES];
	[stateLandmarksMapViewController release];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.tableView = nil;
	self.state = nil;
	self.data = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[state release];
	[data release];
	[tableView release];
    [super dealloc];
}


@end
