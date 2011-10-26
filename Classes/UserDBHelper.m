#import "UserDBHelper.h"

@implementation UserDBHelper

static UserDBHelper *instance;
@synthesize db;

- (NSString *) dbFilePath {
	// Check if the database already exists and if not, copy it over
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *dbFile = [documentsDirectory stringByAppendingPathComponent:@"user_data.sql3"];
	NSError *error;
	
	if ([fileManager fileExistsAtPath:dbFile] == NO) { 
		NSString *pathToDefaultDB = [[NSBundle mainBundle] pathForResource:@"user_data" ofType:@"sql3"];
		if ([fileManager copyItemAtPath:pathToDefaultDB toPath:dbFile error:&error] == NO) {
			NSAssert1(0, @"Failed to copy data with error message '%@'.", [error localizedDescription]);
		}
	}
	
	return dbFile;
}

//- (BOOL) databaseExists {
//	BOOL exists = YES;
//	NSString *query = @"SELECT count(*) FROM favorites"; 
//	sqlite3_stmt *statement; 
//	int result = (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
//	if (result == SQLITE_OK) {
//		while (sqlite3_step(statement) == SQLITE_ROW) { 
//			int countResult = sqlite3_column_int(statement, 0);
//			if (countResult > 0) {
//				exists = YES;
//			}
//		} 
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"Table does not exist");
//	}
//	return exists;
//}

- (BOOL) databaseExists {
	BOOL exists = YES;
	NSString *query = @"SELECT count(*) FROM favorites"; 
    
    FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
        int countResult = [rs intForColumnIndex:0];
        if (countResult > 0) {
            exists = YES;
            break;
        }
	}
	return exists;
}

//- (void) initDatabase {
//	int result = sqlite3_open([[self dbFilePath] UTF8String], &database);
//	if (result != SQLITE_OK) {
//		NSLog (@"Could not open the user_data database");
//	} else {
//		if ([self databaseExists] == NO) {
//			// Create the schema
//			NSLog (@"schema does not exist!");
//			//[self createSchema];
//		} else {
//			NSLog (@"Schema Exists");
//		}
//	}
//}

- (void) initDatabase {
    self.db = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
}


+ (UserDBHelper *) getInstance {
	@synchronized(self) {
		if (!instance) {
			instance = [[UserDBHelper alloc] init];
		}
		
		return instance;
	}
	
	return nil;
}

//- (void) addFavorite:(int) objectID {
//	
//	char *errorMsg;
//	char *update = "INSERT OR REPLACE INTO favorites (object_id) VALUES (?);";
//	
//	sqlite3_stmt *stmt;
//	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
//		sqlite3_bind_int(stmt, 1, objectID);
//	} 
//	if (sqlite3_step(stmt) != SQLITE_DONE) {
//		NSAssert1(0, @"Error updating table: %s", &errorMsg); 
//	}
//	sqlite3_finalize(stmt);	
//}

- (void) addFavorite:(int) objectID {
	
	NSString *update = @"INSERT OR REPLACE INTO favorites (object_id) VALUES (?);";

    BOOL success = [db executeUpdate:update, [NSNumber numberWithInt:objectID]];
    if (!success) {
        NSAssert(0, @"Error adding favorite");
    }

}

//- (void) removeFavorite:(int) plantID {
//	char *errorMsg;
//	char *delete = "DELETE FROM favorites WHERE object_id = ?;";
//	
//	sqlite3_stmt *stmt;
//	if (sqlite3_prepare_v2(database, delete, -1, &stmt, nil) == SQLITE_OK) {
//		sqlite3_bind_int(stmt, 1, plantID);
//	} 
//	if (sqlite3_step(stmt) != SQLITE_DONE) {
//		NSAssert1(0, @"Error updating table: %s", &errorMsg); 
//	}
//	sqlite3_finalize(stmt);	
//}

- (void) removeFavorite:(int) objectID {
	NSString *delete = @"DELETE FROM favorites WHERE object_id = ?;";
    BOOL success = [db executeUpdate:delete, [NSNumber numberWithInt:objectID]];
    if (!success) {
        NSAssert(0, @"Error adding favorite");
    }
	
}

//- (BOOL) favoriteExists:(int)plantID {
//	BOOL exists = NO;
//	char *query = "SELECT count(*) FROM favorites WHERE object_id = ?;"; 
//	sqlite3_stmt *stmt; 
//	int result = (sqlite3_prepare_v2(database, query, -1, &stmt, nil));
//	if (result == SQLITE_OK) {
//		sqlite3_bind_int(stmt, 1, plantID);
//		while (sqlite3_step(stmt) == SQLITE_ROW) { 
//			int countResult = sqlite3_column_int(stmt, 0);
//			if (countResult > 0) {
//				exists = YES;
//			}
//		}
//		sqlite3_finalize(stmt);
//	} else {
//		NSLog(@"Could not read the plant_favorites table");
//	}
//	return exists;
//}

- (BOOL) favoriteExists:(int)plantID {
	BOOL exists = NO;
	NSString *query = @"SELECT count(*) FROM favorites WHERE object_id = ?;"; 
    FMResultSet *rs = [db executeQuery:query, [NSNumber numberWithInt:plantID]];
    while ([rs next]) {
        int countResult = [rs intForColumnIndex:0];
        if (countResult > 0) {
            exists = YES;
            break;
        }
	}
    [rs close];
	return exists;
}

//- (NSMutableArray*) getFavorites {
//	NSLog(@"userdbhelper - getFavorites");
//	DBHelper *dbHelper = [DBHelper getInstance];
//	NSMutableArray *favorites = [[NSMutableArray alloc] init];
//
//	NSString *query = @"SELECT * FROM favorites"; 
//	sqlite3_stmt *statement; 
//	int result = (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
//	if (result == SQLITE_OK) {
//		while (sqlite3_step(statement) == SQLITE_ROW) { 
//			int objectID = sqlite3_column_int(statement, 1);
//			Landmark *landmark = [dbHelper getLandmarkByID:objectID];
//			if (landmark != nil)
//			{
//				[favorites addObject:landmark];
//			} else {
//				//[self removeFavorite:plantID];
//			}
//
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"Could not read the plant_favorites table");
//	}
//		
//	NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(compare:)] autorelease];
//	[favorites sortUsingDescriptors:[NSArray arrayWithObjects:nameSortDescriptor, nil]];	
//	return favorites;
//
//}

- (NSMutableArray*) getFavorites {
	NSLog(@"userdbhelper - getFavorites");
	DBHelper *dbHelper = [DBHelper getInstance];
	NSMutableArray *favorites = [[[NSMutableArray alloc] init] autorelease];
    
	NSString *query = @"SELECT * FROM favorites"; 
    FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
        int objectID = [rs intForColumnIndex:1];
        Landmark *landmark = [dbHelper getLandmarkByID:objectID];
        if (landmark != nil)
        {
            [favorites addObject:landmark];
        } else {
            //[self removeFavorite:plantID];
        }
	}
    [rs close];
    
	NSSortDescriptor *nameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(compare:)] autorelease];
	[favorites sortUsingDescriptors:[NSArray arrayWithObjects:nameSortDescriptor, nil]];	
	return favorites;
    
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
    [db close];
	[instance release];
    [super dealloc];
}

-(id)init {
    if (self = [super init]) {
		[self initDatabase];
    }
	
    return self;
}

@end
