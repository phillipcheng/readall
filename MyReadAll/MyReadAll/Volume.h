//
//  Volume.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//
#import "Reading.h"

@interface Volume:NSObject <Reading>

extern NSString* const ROOT_VOLUME_PREFIX;
extern NSString* const ROOT_VOLUME_LHH;
extern NSString* const ROOT_VOLUME_MH;
extern NSString* const ROOT_VOLUME_SELF;

extern NSString* const VOLUME_KEY;

@property (nonatomic) int state;
@property (nonatomic) NSString* volId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* utime;
@property (nonatomic) NSString* data;
@property (nonatomic) NSString* pCat;
@property (nonatomic) NSString* fullPath;
@property (nonatomic) NSString* author;
@property (nonatomic) int bookNum;
@property (nonatomic) NSString* coverUri;

+(NSMutableDictionary*) RootVolumes;
-(id)initWithId:(NSString*) volId;

@end