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


@interface FirstViewController: UIViewController <SearchPostProcess, DownloadPostProcess, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AttrChangedListener, MyReadingsPostProcess>


@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UITextField *curPageTxt;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *readingCV;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *readingLayout;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBarButton;

@property (weak, nonatomic) IBOutlet UIButton *selMyReading;

@property (nonatomic) NSString* curVolId;
@property (nonatomic) int curPage;
@property (nonatomic) int totalPage;

- (IBAction)myReadingClick:(id)sender;
- (IBAction)addMyReadings:(id)sender;
- (IBAction)delMyReadings:(id)sender;
- (IBAction)setPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addMyReadingsBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *delMyReadingsBtn;

@end

