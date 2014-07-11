//
//  Book.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "Reading.h"
#import "PatternResult.h"

@interface Book: NSObject <Reading>

extern NSString* const BOOK_KEY;


@property (nonatomic) int state;
@property (nonatomic) NSString* bookId;
@property (nonatomic) NSString* bookName;
@property (nonatomic) int totalpage;
@property (nonatomic) int lastpage;
@property (nonatomic) int indexedPages;
@property (nonatomic) NSString* utime;
@property (nonatomic) NSString* data;
@property (nonatomic) NSString* cat;
@property (nonatomic) NSString* fullPath;
@property (nonatomic) int read;
@property (nonatomic) int cached;
@property (nonatomic) NSString* coverUri;
@property (nonatomic) NSString* stickerDir;
@property (nonatomic) NSString* bUrl;
@property (nonatomic) NSString* sUrl;
@property (nonatomic) PatternResult* pageBgUrlPattern;
@property (nonatomic) int type;
@property (nonatomic) NSString* author;

-(NSString*) getPageUrl:(int) pageNum;

@end