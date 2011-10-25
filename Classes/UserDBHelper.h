#import </usr/include/sqlite3.h>
#import "DBHelper.h"

@interface UserDBHelper : NSObject {
	sqlite3 *database;
}

@property (nonatomic) sqlite3 *database;
+ (UserDBHelper *) getInstance;
- (NSString *) dbFilePath;
- (BOOL) databaseExists;
- (void) initDatabase;

- (void) addFavorite:(int) objectID;
- (void) removeFavorite:(int) objectID;
- (BOOL) favoriteExists:(int) objectID;
- (NSMutableArray*) getFavorites;

//- (void) saveNote:(Note*) note;
//- (int) addNote:(Note*) note;
//- (void) removeNote:(int) noteID;
//- (Note*) getNote:(int) noteID;
//- (NSMutableArray*) getNotes:(int) plantID;

-(NSString*) checkForNull:(char*)incoming;

@end
