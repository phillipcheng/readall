//
//  PageCondition.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/22/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "Book.h"

@interface PageCondition : NSObject

@property (nonatomic) Book* book;
@property (nonatomic) int pageNum;

@end