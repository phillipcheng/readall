//
//  SearchCondition.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "Reading.h"

@interface SearchCondition : NSObject

@property (nonatomic) NSString* searchTxt;
@property (nonatomic) NSString* volId;
@property (nonatomic) int pageNum; //page num of the search result

@property (nonatomic) NSIndexPath* indexPath; //the index path of the cell, section and row
@property (nonatomic) id<Reading> reading;
@property (nonatomic) int bookpage; //page num of the book, -1 for cover

@end