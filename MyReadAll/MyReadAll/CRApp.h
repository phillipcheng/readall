//
//  CRApp.h
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "CRBookWSClient.h"
#import "AttrChangedListener.h"

extern NSString* const LOGIN_FAILED;
extern NSString* const SIGN_UP_SUCCEED;
extern NSString* const USER_EXIST;

@interface CRApp:NSObject

+(CRBookWSClient*) getWSClient;

+(NSString*) getUserId;
+(void) setUserId:(NSString*) uid;

+(NSString*) getSessionId;
+(void) setSessionId:(NSString*) sid;

+(int) itemsPerPage;
+(void) setItemsPerPage:(int) ipp;

+(NSDateFormatter*) getDateFormatter;

+(void) addAttrChangedListener:(id<AttrChangedListener>) listener;

+(BOOL) isMyReading;
+(void) setMyReading:(BOOL) val;

+(Volume*) getTemplate:(NSString*) readingId;
+(void) buildTemplateCache;

@end