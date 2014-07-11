//
//  ReadingImageCell.h
//  ReadAll
//
//  Created by Cheng Yi on 7/10/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "ReadingViewCell.h"

@interface ReadingImageCell : ReadingViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *readingTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@end
