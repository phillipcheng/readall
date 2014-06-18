//
//  Reading.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/18/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reading.h"

const int STATE_ONLINE=0;
const int STATE_OFFLINE=1;
const int STATE_BOTH=2;

NSString* const KEY_COVER_URI=@"coverUri";
NSString* const AT=@"@";
