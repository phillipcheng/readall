//
//  ReadingRowCell.h
//  ReadAll
//
//  Created by Cheng Yi on 7/10/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadingViewCell.h"

@interface ReadingRowCell : ReadingViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorLbl;
@property (weak, nonatomic) IBOutlet UILabel *itemNumLbl;

@end
