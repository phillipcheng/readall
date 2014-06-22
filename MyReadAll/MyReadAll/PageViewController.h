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
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic) Book* book;
@property (nonatomic) int curPage;

@end
