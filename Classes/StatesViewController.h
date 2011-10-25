//
//  StatesViewController.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatesViewController : UIViewController {

	UITableView *tableView;
	NSMutableArray *data;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *data;

@end
