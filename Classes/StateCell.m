//
//  ExampleCell.m
//  EGOImageLoadingDemo
//
//  Created by Shaun Harrison on 10/19/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "StateCell.h"
#import "EGOImageView.h"

@implementation StateCell

@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"transparent_icon.png"]];
		imageView.contentMode = UIViewContentModeScaleAspectFit;	
		imageView.frame = CGRectMake(4.0f, 2.0f, 56.0f, 52.0f);
		[self.contentView addSubview:imageView];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68.0f, 6.0f, 250.0f, 42.0f)];
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
	NSLog(@"statecell dealloc");
	imageView.delegate = nil;	
	[imageView release];
    [super dealloc];
}


@end
