//
//  StatesViewController.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "StatesViewController.h"
#import "DBHelper.h"
#import "State.h"
#import "LandmarksViewController.h"
#import "StateCell.h"

@implementation StatesViewController

@synthesize tableView, data;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	State *state = [data objectAtIndex:indexPath.row];
    
    StateCell *cell = (StateCell*)[inTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[StateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSString *unspacedNamed = [[state name] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSLog(@"flag img: %@", [NSString stringWithFormat:@"http://www.stevensonsoftware.com/us_landmarks/flag_thumbnails/flag_75x75_%@.png", unspacedNamed]);
    cell.nameLabel.text = [state name];
	[cell setImageLocation:[NSString stringWithFormat:@"http://www.stevensonsoftware.com/us_landmarks/flag_thumbnails/flag_75x75_%@.png", unspacedNamed]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LandmarksViewController *landmarksController = [[LandmarksViewController alloc] initWithNibName:@"LandmarksViewController" bundle:nil];
	[landmarksController setState:[data objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:landmarksController animated:YES];
	[landmarksController release];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	self.title = @"States";
	self.tableView.separatorColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"viewWillAppear");
	data = [[DBHelper getInstance] getStates];	
	[self.tableView reloadData];	
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[data release];
	[tableView release];
    [super dealloc];
}


@end
