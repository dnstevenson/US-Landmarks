//
//  LandmarksViewController.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "State.h"
#import "LandmarkCell.h"

@interface FavoritesViewController : UIViewController {
	UITableView *tableView;
	NSMutableArray *data;
//	State *state;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *data;
//@property (nonatomic, retain) State *state;

@end
