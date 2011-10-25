#import "DBHelper.h"
#import "State.h"
#import "Landmark.h"

@implementation DBHelper

static DBHelper *instance;
@synthesize db; //database

- (void) copyDBToDevice {
	NSLog(@"copy user db to device");
	// Check if the database already exists and if not, copy it over
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *dbFile = [documentsDirectory stringByAppendingPathComponent:@"landmarks.sqlite"];
	NSError *error;
	
	if ([fileManager fileExistsAtPath:dbFile] == YES) { 
		if ([fileManager removeItemAtPath:dbFile error:&error] == NO) {
			NSAssert1(0, @"Failed to delete data with error message '%@'.", [error localizedDescription]);
		}
	}
	
	if ([fileManager fileExistsAtPath:dbFile] == NO) { 
		NSString *pathToDefaultDB = [[NSBundle mainBundle] pathForResource:@"landmarks" ofType:@"sqlite"];
		if ([fileManager copyItemAtPath:pathToDefaultDB toPath:dbFile error:&error] == NO) {
			NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
		}
	}
	
	//return dbFile;
}

- (NSString*) dbFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *dbFilePath = [documentsDirectory stringByAppendingPathComponent:@"landmarks.sqlite"];
	return dbFilePath;
}

- (void) initDatabase {
	
	// Try to open the database file
	// sqllite3_open and all sqlite functions require C Strings, not NSStrings
	// You have to convert NSString to UTF8String C String for these functions to work
    
    self.db = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
//	int result = sqlite3_open([[self dbFilePath] UTF8String], &database);
//	if (result != SQLITE_OK) {
//		// We could not open the database file
//		// We should do something bad here
//		NSLog (@"Could not open the user data database");
//	}
}

-(id)init
{
    if (self = [super init])
    {
		// Initialization code here
		[self copyDBToDevice];
		[self initDatabase];
    }
    return self;
}

+ (DBHelper *) getInstance {
	@synchronized(self) {
		if (!instance) {
			instance = [[DBHelper alloc] init];
		}
		
		return instance;
	}
	
	return nil;
}


//- (Landmark*) getLandmarkByID:(int) landmarkID {
//	Landmark *landmark = nil;
//	
//	char *query = "SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks where id = ?"; 
//	sqlite3_stmt *statement; 
//	int result = (sqlite3_prepare_v2(database, query, -1, &statement, nil));
//	if (result == SQLITE_OK) {
//		sqlite3_bind_int(statement, 1, landmarkID);		
//		while (sqlite3_step(statement) == SQLITE_ROW) { 
//			landmark = [[Landmark alloc] initWithId:sqlite3_column_int(statement, 0)
//													 withName:[self checkForNull:(char*)sqlite3_column_text(statement, 1)]
//											  withDescription:[self checkForNull:(char*)sqlite3_column_text(statement, 2)]
//											 withWikipediaURL:[[NSURL alloc] initWithString:[self checkForNull:(char *)sqlite3_column_text(statement,3)]]
//													 withDate:[self checkForNull:(char*)sqlite3_column_text(statement, 4)]
//												 withLatitude:[self checkForNull:(char*)sqlite3_column_text(statement, 5)]
//												withLongitude:[self checkForNull:(char*)sqlite3_column_text(statement, 6)]
//												withImageName:[self checkForNull:(char*)sqlite3_column_text(statement, 7)]];
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"Could not read the landmarks table");
//	}
//	return landmark;
//}

- (Landmark*) getLandmarkByID:(int) landmarkID {
	Landmark *landmark = nil;
	
	NSString *query = @"SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks where id = ?"; 
    FMResultSet *rs = [db executeQuery:query, [NSNumber numberWithInt:landmarkID]];
    while ([rs next]) {
        landmark = [[Landmark alloc] initWithId:[rs intForColumnIndex:0]
                                       withName:[rs stringForColumnIndex:1]
                                withDescription:[rs stringForColumnIndex:2]
                               withWikipediaURL:[[NSURL alloc] initWithString:[rs stringForColumnIndex:3]]
                                       withDate:[rs stringForColumnIndex:4]
                                   withLatitude:[rs stringForColumnIndex:5]
                                  withLongitude:[rs stringForColumnIndex:6]
                                  withImageName:[rs stringForColumnIndex:7]];
    }
    [rs close];
	return landmark;
}

//- (NSMutableArray*) getAllLandmarks {
//	NSLog(@"userdbhelper - getLandmarksForState");
//	NSMutableArray *landmarks = [[NSMutableArray alloc] init];
//	
//	char *query = "SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks"; 
//	sqlite3_stmt *statement; 
//	int result = (sqlite3_prepare_v2(database, query, -1, &statement, nil));
//	if (result == SQLITE_OK) {
//		while (sqlite3_step(statement) == SQLITE_ROW) { 
//			Landmark *landmark = [[Landmark alloc] initWithId:sqlite3_column_int(statement, 0)
//													 withName:[self checkForNull:(char*)sqlite3_column_text(statement, 1)]
//											  withDescription:[self checkForNull:(char*)sqlite3_column_text(statement, 2)]
//											 withWikipediaURL:[[NSURL alloc] initWithString:[self checkForNull:(char *)sqlite3_column_text(statement,3)]]
//													 withDate:[self checkForNull:(char*)sqlite3_column_text(statement, 4)]
//												 withLatitude:[self checkForNull:(char*)sqlite3_column_text(statement, 5)]
//												withLongitude:[self checkForNull:(char*)sqlite3_column_text(statement, 6)]
//												withImageName:[self checkForNull:(char*)sqlite3_column_text(statement, 7)]];
//			[landmarks addObject:landmark];
//			[landmark release];
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"Could not read the landmarks table");
//	}
//	return landmarks;
//	
//}

- (NSMutableArray*) getAllLandmarks {
	NSLog(@"userdbhelper - getLandmarksForState");
	NSMutableArray *landmarks = [[NSMutableArray alloc] init];
	
	NSString *query = @"SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks"; 
    FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
        Landmark *landmark = [[Landmark alloc] initWithId:[rs intForColumnIndex:0]
                                                 withName:[rs stringForColumnIndex:1]
                                          withDescription:[rs stringForColumnIndex:2]
                                         withWikipediaURL:[[NSURL alloc] initWithString:[rs stringForColumnIndex:3]]
                                                 withDate:[rs stringForColumnIndex:4]
                                             withLatitude:[rs stringForColumnIndex:5]
                                            withLongitude:[rs stringForColumnIndex:6]
                                            withImageName:[rs stringForColumnIndex:7]];
        [landmarks addObject:landmark];
        [landmark release];
	}
    [rs close];
	return landmarks;
	
}

- (NSMutableArray*) getLandmarksForState:(int) stateID {
	NSLog(@"userdbhelper - getLandmarksForState");
	NSMutableArray *landmarks = [[NSMutableArray alloc] init];
	
	NSString *query = @"SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks where state_id = ?"; 
    FMResultSet *rs = [db executeQuery:query, [NSNumber numberWithInt:stateID]];
    while ([rs next]) {
        Landmark *landmark = [[Landmark alloc] initWithId:[rs intForColumnIndex:0]
                                        withName:[rs stringForColumnIndex:1]
                                 withDescription:[rs stringForColumnIndex:2]
                                withWikipediaURL:[[NSURL alloc] initWithString:[rs stringForColumnIndex:3]]
                                        withDate:[rs stringForColumnIndex:4]
                                    withLatitude:[rs stringForColumnIndex:5]
                                   withLongitude:[rs stringForColumnIndex:6]
                                   withImageName:[rs stringForColumnIndex:7]];
        [landmarks addObject:landmark];
        [landmark release];
	}
    [rs close];
	return landmarks;
	
}

//- (NSMutableArray*) getLandmarksForState:(int) stateID {
//	NSLog(@"userdbhelper - getLandmarksForState");
//	NSMutableArray *landmarks = [[NSMutableArray alloc] init];
//	
//    //	char *query = "SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks where state_id = ?"; 
//    
//	NSString *query = @"SELECT id, name, description, wikipedia_url,date,latitude,longitude, image_name FROM landmarks where state_id = ?"; 
//    FMResultSet *rs = [db executeQuery:query, stateID];
//    
//	sqlite3_stmt *statement; 
//	int result = (sqlite3_prepare_v2(database, query, -1, &statement, nil));
//	if (result == SQLITE_OK) {
//		sqlite3_bind_int(statement, 1, stateID);
//		while (sqlite3_step(statement) == SQLITE_ROW) { 
//			Landmark *landmark = [[Landmark alloc] initWithId:sqlite3_column_int(statement, 0)
//                                                     withName:[self checkForNull:(char*)sqlite3_column_text(statement, 1)]
//                                              withDescription:[self checkForNull:(char*)sqlite3_column_text(statement, 2)]
//                                             withWikipediaURL:[[NSURL alloc] initWithString:[self checkForNull:(char *)sqlite3_column_text(statement,3)]]
//                                                     withDate:[self checkForNull:(char*)sqlite3_column_text(statement, 4)]
//                                                 withLatitude:[self checkForNull:(char*)sqlite3_column_text(statement, 5)]
//                                                withLongitude:[self checkForNull:(char*)sqlite3_column_text(statement, 6)]
//                                                withImageName:[self checkForNull:(char*)sqlite3_column_text(statement, 7)]];
//			[landmarks addObject:landmark];
//			[landmark release];
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"Could not read the landmarks table");
//	}
//	return landmarks;
//	
//}

//- (NSMutableArray*) getStates{
//	NSMutableArray *states = [[NSMutableArray alloc] init];
//	NSString *query = @"SELECT id, name, latitude, longitude FROM states"; 
//	sqlite3_stmt *statement; 
//	int result = (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
//	if (result == SQLITE_OK) {
//		while (sqlite3_step(statement) == SQLITE_ROW) { 
//			State *state = [[State alloc] initWithId:sqlite3_column_int(statement, 0)
//											 withName:[self checkForNull:(char*)sqlite3_column_text(statement, 1)]
//										withLatitude:[self checkForNull:(char*)sqlite3_column_text(statement, 2)]
//									   withLongitude:[self checkForNull:(char*)sqlite3_column_text(statement, 3)]];
//			[states addObject:state];
//			[state release];
//		}
//		sqlite3_finalize(statement);
//	}
//	return states;
//}

- (NSMutableArray*) getStates {
	NSMutableArray *states = [[NSMutableArray alloc] init];
	NSString *query = @"SELECT id, name, latitude, longitude FROM states"; 
    FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
        State *state = [[State alloc] initWithId:[rs intForColumnIndex:0]
                                        withName:[rs stringForColumnIndex:1]
                                    withLatitude:[rs stringForColumnIndex:2]
                                   withLongitude:[rs stringForColumnIndex:3]];        
        [states addObject:state];
        [state release];
    }
    [rs close];
    return states;
}

//-(NSString*) checkForNull:(char*)incoming {
//	return incoming != nil ? [NSString stringWithUTF8String: incoming] : @"";			
//}

+(id)alloc {
	@synchronized(self) {
		NSAssert(instance == nil, @"Can't manually allocate a single - use the getInstance method instead");
		instance = [super alloc];
		return instance;
	}
	
	return nil;
}

-(void) dealloc {
    [super dealloc];
}

@end
