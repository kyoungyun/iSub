//
//  AllSongsViewController.h
//  iSub
//
//  Created by Ben Baron on 3/30/10.
//  Copyright Ben Baron 2010. All rights reserved.
//

#import "SUSLoaderDelegate.h"

@class iSubAppDelegate, SavedSettings, ViewObjectsSingleton, SearchOverlayViewController, Song, MusicSingleton, DatabaseSingleton, Album, SUSAllSongsDAO, LoadingScreen;

@interface AllSongsViewController : UITableViewController <UISearchBarDelegate, SUSLoaderDelegate> 
{
	iSubAppDelegate *appDelegate;
	ViewObjectsSingleton *viewObjects;
	MusicSingleton *musicControls;
	DatabaseSingleton *databaseControls;
	SavedSettings *settings;
	
	SUSAllSongsDAO *dataModel;
	
	UIView *headerView;
	UIButton *reloadButton;
	UILabel *reloadLabel;
	UIImageView *reloadImage;
	UILabel *countLabel;
	UILabel *reloadTimeLabel;
	IBOutlet UISearchBar *searchBar;
	
	SearchOverlayViewController *searchOverlayView;
	BOOL letUserSelectRow;
	NSURL *url;
		
	NSInteger numberOfRows;
	
	NSArray *sectionInfo;
	
	BOOL isSearching;
	
	LoadingScreen *loadingScreen;
	
	BOOL isProcessingArtists;
}

@property (nonatomic, retain) SUSAllSongsDAO *dataModel;

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) NSArray *sectionInfo;

@property (nonatomic, retain) LoadingScreen *loadingScreen;

- (void) addCount;

- (void) doneSearching_Clicked:(id)sender;

- (void)loadingFailed:(SUSLoader*)theLoader withError:(NSError *)error;
- (void)loadingFinished:(SUSLoader*)theLoader;

@end