//
//  State.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "State.h"


@implementation State

@synthesize id, name, latitude, longitude;

- (id)initWithId:(int)inId withName:(NSString*)inName withLatitude:(NSString*)inLatitude withLongitude:(NSString*)inLongitude {
	if (self = [super init]) {
		self.id = inId;
		self.name = inName;
		self.latitude = inLatitude;
		self.longitude = inLongitude;
		NSLog(@"long: %@", inLongitude);
	}			
	
	return self;
}

@end
