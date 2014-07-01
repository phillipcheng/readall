//
//  MyReadingsPostProcess.h
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@protocol MyReadingsPostProcess <NSObject>

-(void) myReadingPostProcess:(NSString*) userName ids:(NSArray*) ids rowsAffected:(int) rowsAffected err:(NSError*) err;

@end