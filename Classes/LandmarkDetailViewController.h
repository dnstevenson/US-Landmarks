//
//  LandmarkDetailViewController.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Landmark.h"
#import "LandmarkHeaderView.h"
#import "LandmarkMapCell.h"

@interface LandmarkDetailViewController : UIViewController {

	Landmark *landmark;
	UITableView *tableView;
	BOOL inModal;
	LandmarkHeaderView *headerView;
	
	LandmarkMapCell *mapCell;
	
}

@property (nonatomic, retain) Landmark *landmark;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL inModal;
@property (nonatomic, retain) LandmarkHeaderView *headerView;
@property (nonatomic, retain) IBOutlet LandmarkMapCell *mapCell;

- (void) setRightNavigationItem;

@end
