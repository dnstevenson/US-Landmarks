//
//  Landmark.m
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import "Landmark.h"


@implementation Landmark

@synthesize id, name, description, wikipediaURL, date, latitude, longitude, imageName;

- (id)initWithId:(int)inId 
		withName:(NSString*)inName 
 withDescription:(NSString*)inDescription 
withWikipediaURL:(NSURL*)inWikipediaURL
		withDate:(NSString*)inDate
	withLatitude:(NSString*)inLatitude
   withLongitude:(NSString*)inLongitude
   withImageName:(NSString*)inImageName {
	
	if (self = [super init]) {
		self.id = inId;
		self.name = inName;
		self.description = inDescription;
		self.wikipediaURL = inWikipediaURL;
		self.date = inDate;
		self.latitude = inLatitude;
		self.longitude = inLongitude;
		self.imageName = inImageName;
	}			
	
	return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [latitude doubleValue];
    theCoordinate.longitude = [longitude doubleValue];
    return theCoordinate; 
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return name;
}

// optional
- (NSString *)subtitle
{
    return @"";
}


@end

