//
//  SUSAllSongsLoader.h
//  iSub
//
//  Created by Ben Baron on 9/23/11.
//  Copyright 2011 Ben Baron. All rights reserved.
//

#import "SUSLoader.h"

#define NOTIF_LOADING_ARTISTS @"SUSAllSongsLoader loading artists"
#define NOTIF_LOADING_ALBUMS @"SUSAllSongsLoader loading albums"
#define NOTIF_ARTIST_NAME @"SUSAllSongsLoader loading artist name"
#define NOTIF_ALBUM_NAME @"SUSAllSongsLoader loading album name"
#define NOTIF_SONG_NAME @"SUSAllSongsLoader loading song name"
#define NOTIF_NAME @"name"

#define READ_BUFFER_AMOUNT 400
#define WRITE_BUFFER_AMOUNT 400

@class ViewObjectsSingleton, DatabaseSingleton, SavedSettings, Artist, Album, SUSRootFoldersDAO;

@interface SUSAllSongsLoader : SUSLoader
{
	ViewObjectsSingleton *viewObjects;
	DatabaseSingleton *databaseControls;
	SavedSettings *settings;
	
	NSInteger iteration;
	NSUInteger albumCount;
	NSUInteger artistCount;
	NSUInteger currentRow;
	
	Artist *currentArtist;
	Album *currentAlbum;
	
	NSUInteger tempAlbumsCount;
	NSUInteger tempSongsCount;
	NSUInteger tempGenresCount;
	NSUInteger tempGenresLayoutCount;
	
	NSUInteger totalAlbumsProcessed;
	NSUInteger totalSongsProcessed;
	
	SUSRootFoldersDAO *rootFolders;
	
	NSDate *notificationTimeArtistAlbum;
	NSDate *notificationTimeSong;
}

@property (nonatomic, retain) Artist *currentArtist;
@property (nonatomic, retain) Album *currentAlbum;
@property (nonatomic, retain) SUSRootFoldersDAO *rootFolders;
@property (nonatomic, retain) NSDate *notificationTimeArtist;
@property (nonatomic, retain) NSDate *notificationTimeAlbum;
@property (nonatomic, retain) NSDate *notificationTimeSong;

@end
