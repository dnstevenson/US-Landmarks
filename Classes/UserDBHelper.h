#import </usr/include/sqlite3.h>
#import "DBHelper.h"
#import "FMDatabase.h"

@interface UserDBHelper : NSObject {
//	sqlite3 *database;
    FMDatabase *db;
}

//@property (nonatomic) sqlite3 *database;
@property (nonatomic, retain) FMDatabase *db;

+ (UserDBHelper *) getInstance;
- (NSString *) dbFilePath;
- (BOOL) databaseExists;
- (void) initDatabase;

- (void) addFavorite:(int) objectID;
- (void) removeFavorite:(int) objectID;
- (BOOL) favoriteExists:(int) objectID;
- (NSMutableArray*) getFavorites;

//-(NSString*) checkForNull:(char*)incoming;

@end
