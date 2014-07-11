//
//  Reading.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//
#import "IJSON.h"

@protocol Reading <IJSON>


extern NSString* const KEY_COVER_URI;
extern NSString* const KEY_TYPE;
extern NSString* const AT;

- (NSString*) getFullPath;

- (NSString*) getName;
- (void) setName:(NSString*) name;

- (NSString*) getCoverUri;
- (void) setCoverUri:(NSString*) coverUri;

- (NSString*) getCat;
- (NSString*) getId;
- (NSString*) getUtime;
- (NSString*) getData;

extern const int STATE_ONLINE;
extern const int STATE_OFFLINE;
extern const int STATE_BOTH;
- (int) getState;
- (void) setState: (int) state;
-(NSString*) getAuthor;

extern const int TYPE_PIC;
extern const int TYPE_NOVEL;
- (int) getType;

@end