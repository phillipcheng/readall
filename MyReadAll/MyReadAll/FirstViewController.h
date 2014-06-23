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


@interface FirstViewController: UIViewController <SearchPostProcess, DownloadPostProcess, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property (weak, nonatomic) IBOutlet UITextField *curPageTxt;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLbl;

@property (weak, nonatomic) IBOutlet UICollectionView *readingCV;

@property (nonatomic) NSString* rootCatId;
@property (nonatomic) Volume* curVol;
@property (nonatomic) int curPage;
@property (nonatomic) int totalPage;

- (IBAction)setPage:(id)sender;

+(int) itemsPerPage;
+(void) setItemsPerPage:(int) ipp;

@end

