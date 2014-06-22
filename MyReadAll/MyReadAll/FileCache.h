//
//  FileCache.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "Reading.h"

@interface FileCache : NSObject

+(NSMutableDictionary*) fileKeyCache;

+(NSString*) generateKey:(bool)isCover reading:(id<Reading>)reading pageNum:(int) pageNum;

@end