//
//  LandmarkHeaderView.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/12/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "LandmarkHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LandmarkHeaderView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame {
	NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
		imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"transparent_icon.png"] delegate:self];
	}
	
    return self;
}

- (void)setImageLocation:(NSString*)imageLocation {
	imageView.delegate = self;
	imageView.imageURL = [NSURL URLWithString:imageLocation];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[imageView cancelImageLoad];
	}
}

- (void)imageViewLoadedImage:(EGOImageView*)inImageView {
	
	NSLog(@"width: %f", inImageView.image.size.width);
	int width = (160 - inImageView.image.size.width / 2) <= 5 ? 10 : (160 - inImageView.image.size.width / 2);
	int height = (0 + ((200-inImageView.image.size.height)/2)) > 200 ? 200 : (0 + ((200-inImageView.image.size.height)/2));
	int maxWidth = (inImageView.image.size.width > 300) ? 300 : (inImageView.image.size.width);
	imageView.frame = CGRectMake(width, height, maxWidth, inImageView.image.size.height);
	imageView.image = inImageView.image;
	imageView.layer.borderColor = [UIColor blackColor].CGColor;
	imageView.layer.borderWidth = 1.0;
	
//	imageView.layer.shadowOffset = CGSizeMake(0, 3);
//	imageView.layer.shadowRadius = 5.0;
//	imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//	imageView.layer.shadowOpacity = 0.8;
	
	imageView.layer.cornerRadius = 10;
	imageView.layer.masksToBounds = YES;	

}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error {
}


- (void)dealloc {
	NSLog(@"landmarkheader dealloc");
	imageView.delegate = nil;
	[imageView release];
    [super dealloc];
}

@end
