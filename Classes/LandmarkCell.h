//
//  ExampleCell.h
//  EGOImageLoadingDemo
//
//  Created by Shaun Harrison on 10/19/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface LandmarkCell : UITableViewCell <EGOImageViewDelegate> {

	IBOutlet EGOImageView* imageView;
	IBOutlet UILabel *nameLabel;
	
}

@property (nonatomic, retain) UILabel* nameLabel;
- (void)setImageLocation:(NSString*)imageLocation;

@end
