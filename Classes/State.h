//
//  State.h
//  Landmarks-iPhone
//
//  Created by David Stevenson on 1/10/11.
//  Copyright 2011 Stevenson Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface State : NSObject {
	
	int id;
	NSString* name;
	NSString* latitude;
	NSString* longitude;

}

@property (nonatomic) int id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

- (id)initWithId:(int)inId withName:(NSString*)inName withLatitude:(NSString*)inLatitude withLongitude:(NSString*)inLongitude;

@end
