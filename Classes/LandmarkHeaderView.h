//
//  LandmarkHeaderView.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/12/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface LandmarkHeaderView : UIView <EGOImageViewDelegate> {
	
	IBOutlet EGOImageView* imageView;
	
}

@property (nonatomic, retain) EGOImageView *imageView;

- (void)setImageLocation:(NSString*)imageLocation;

@end
