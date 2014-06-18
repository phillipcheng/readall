//
//  IJSON.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

@protocol IJSON <NSObject>

- (void) dataToJSON;
- (NSDictionary*) toJSONObject;
- (NSString*) toTopJSONString;
- (void) fromTopJSONObject:(NSDictionary*) dict;
- (void) fromTopJSONString:(NSString*) jstring;

@end