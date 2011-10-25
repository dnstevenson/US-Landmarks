//
//  LandmarkMapCell.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/12/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "LandmarkMapCell.h"


@implementation LandmarkMapCell

@synthesize mapView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSLog(@"initWithStyle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	//[mapView release];
    [super dealloc];
}


@end
