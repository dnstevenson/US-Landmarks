#import <Foundation/Foundation.h>
#import </usr/include/sqlite3.h>
#import "Landmark.h"
#import "FMDatabase.h"

@interface DBHelper : NSObject {
	//sqlite3 *database;
    FMDatabase *db;
}

//@property (nonatomic) sqlite3 *database;
@property (nonatomic, retain) FMDatabase *db;

+ (DBHelper *) getInstance;
- (void) copyDBToDevice;
- (NSString*) dbFilePath;

- (NSMutableArray*) getStates;
- (NSMutableArray*) getLandmarksForState:(int) stateID;
- (NSMutableArray*) getAllLandmarks;
- (Landmark*) getLandmarkByID:(int) landmarkID;

//-(NSString*) checkForNull:(char*)incoming;

// test
@end
