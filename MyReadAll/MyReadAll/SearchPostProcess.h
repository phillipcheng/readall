//
//  SearchPostProcess.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "SearchResult.h"

@protocol SearchPostProcess <NSObject>

-(void) postProcess:(NSString*) searchTxt searchCat:(NSString*) catId offset:(int) offset limit:(int) limit
             result:(SearchResult*) result err:(NSError*) err;

@end