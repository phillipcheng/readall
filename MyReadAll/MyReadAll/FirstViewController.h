//
//  FirstViewController.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/14/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPostProcess.h"
#import "DownloadPostProcess.h"
#import "Volume.h"
#import "AttrChangedListener.h"
#import "MyReadingsPostProcess.h"
#import "SelectableCollection.h"
#import "CRBookWSClient.h"
#import "AppToolBar.h"
#import "CRApp.h"
#import "SearchCondition.h"


@interface FirstViewController: UIViewController <SearchPostProcess, DownloadPostProcess, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectableCollection, UINavigationControllerDelegate>


@property (nonatomic) NSMutableArray* selReadings; //selected readings
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UITextField *curPageTxt;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *readingCV;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *readingLayout;

- (void) postLoad;

- (IBAction)doSearch:(id)sender;
- (IBAction)doPrev:(id)sender;
- (IBAction)doNext:(id)sender;
- (IBAction)setPage:(id)sender;

@property (nonatomic) NSString* curVolId;
@property (nonatomic) int curPage;
@property (nonatomic) int totalPage;
@property (nonatomic) CRBookWSClient* wsClient;
@property (nonatomic) AppToolBar* appToolBar;
@property (nonatomic) NSMutableArray* readings; //id<Reading>

//set by sub-class
@property (nonatomic) int columnNum;
@property (nonatomic) int type;
@property (nonatomic) int height;

-(NSString*) getRootCatList;

@end

