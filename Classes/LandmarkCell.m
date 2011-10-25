//
//  ExampleCell.m
//  EGOImageLoadingDemo
//
//  Created by Shaun Harrison on 10/19/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "LandmarkCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LandmarkCell

@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"transparent_icon.png"] delegate:self];
		imageView.contentMode = UIViewContentModeScaleAspectFit;	
		imageView.frame = CGRectMake(4.0f, 2.0f, 54.0f, 62.0f);
		[self.contentView addSubview:imageView];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0f, 12.0f, 245.0f, 42.0f)];
		nameLabel.backgroundColor = [UIColor clearColor];		
		nameLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];				
		[self.contentView addSubview:nameLabel];
	}
	
    return self;
}

- (void)setImageLocation:(NSString*)imageLocation {
	imageView.imageURL = [NSURL URLWithString:imageLocation];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[imageView cancelImageLoad];
	}
}
- (void)dealloc {
	NSLog(@"landmarkcell dealloc");
	imageView.delegate = nil;
	[imageView release];
    [super dealloc];
}


@end
