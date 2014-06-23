//
//  PageViewController.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/21/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "DownloadPostProcess.h"

@interface PageViewController : UIViewController <DownloadPostProcess>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) Book* book;
@property (nonatomic) int curPage;
@property (weak, nonatomic) IBOutlet UITextField *curPageTxt;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLbl;
- (IBAction)nextPage:(id)sender;
- (IBAction)prevPage:(id)sender;
- (IBAction)setPage:(id)sender;

@end
