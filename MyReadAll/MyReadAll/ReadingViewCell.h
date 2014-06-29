//
//  ReadingViewCell.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reading.h"

@interface ReadingViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *readingTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (nonatomic) BOOL chkSel;

- (IBAction)btnClick:(id)sender;

@property (nonatomic) id<Reading> reading;
@end
