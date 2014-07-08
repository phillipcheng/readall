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


@interface FirstViewController: UIViewController <SearchPostProcess, DownloadPostProcess, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectableCollection, UINavigationControllerDelegate>


@property (nonatomic) NSMutableArray* selReadings; //selected readings
@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UITextField *curPageTxt;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *readingCV;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *readingLayout;

@property (nonatomic) NSString* curVolId;
@property (nonatomic) int curPage;
@property (nonatomic) int totalPage;

@end

