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

@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (nonatomic) BOOL chkSel;
@property (nonatomic) NSString* rid;
@property (nonatomic) NSMutableArray* selReadings;

- (IBAction)btnClick:(id)sender;
- (void) myInit;

@property (nonatomic) id<Reading> reading;
@end