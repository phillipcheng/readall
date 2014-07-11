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
#import "CRBookWSClient.h"
#import "PageCondition.h"

@interface PageViewController : UIViewController <DownloadPostProcess>
@property (weak, nonatomic) IBOutlet UITextField *curPageTxt;
@property (weak, nonatomic) IBOutlet UILabel *totalPageLbl;
- (IBAction)nextPage:(id)sender;
- (IBAction)prevPage:(id)sender;

@property (nonatomic) Book* book;
@property (nonatomic) int curPage;
@property(nonatomic) CRBookWSClient* wsClient;
@property(nonatomic) UIActivityIndicatorView  *av;

//implemented by sub-class
-(void) doMySearch:(NSString*)url pageCondition:(PageCondition*)pc;
-(void) doMyPostProcess:(NSData*) result;


@end
