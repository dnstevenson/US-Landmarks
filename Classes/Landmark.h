//
//  Landmark.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Landmark : NSObject <MKAnnotation> {

	int id;
	NSString* name;
	NSString* description;
	NSURL* wikipediaURL;
	NSString *date;
	NSString *latitude;
	NSString *longitude;
	NSString *imageName;
	
}

@property (nonatomic) int id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSURL *wikipediaURL;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *imageName;

- (id)initWithId:(int)inId 
		withName:(NSString*)inName
 withDescription:(NSString*)inDescription 
withWikipediaURL:(NSURL*)inWikipediaURL
		withDate:(NSString*)inDate
	withLatitude:(NSString*)inLatitude
   withLongitude:(NSString*)inLongitude
   withImageName:(NSString*)inImageName;


@end
