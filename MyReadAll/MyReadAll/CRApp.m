//
//  CRApp.m
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRApp.h"

static CRBookWSClient* wsClient;
static NSString* userId;
static NSString* sessionId;
static int itemsPerPage = 20;
static NSString* dateFormat=@"yyyy-MM-dd'T'HH:mm:ssZ";
static NSDateFormatter* dateFormatter;
static NSMutableArray* attrChangedListeners;
static BOOL isMyReading=false;

NSString* const LOGIN_FAILED=@"LoginFailed";
NSString* const SIGN_UP_SUCCEED=@"SignupSucceed";

@implementation CRApp

+(BOOL) isMyReading{
    return isMyReading;
}
+(void) setMyReading:(BOOL) val{
    isMyReading = val;
}

+(CRBookWSClient*) getWSClient{
    if (wsClient==nil){
        wsClient = [[CRBookWSClient alloc]init];
    }
    return wsClient;
}

+(NSString*) getUserId{
    return userId;
}

+(void) setUserId:(NSString*) uid{
    NSString* old = userId;
    userId = uid;
    for (id<AttrChangedListener> lstn in attrChangedListeners) {
        [lstn attrChanged:[self class] attrName:@"userId" oldValue:old newValue:userId];
    }
}

+(NSString*) getSessionId{
    return sessionId;
}
+(void) setSessionId:(NSString*) sid{
    sessionId=sid;
}

+(int) itemsPerPage{
    return itemsPerPage;
}

+(void) setItemsPerPage:(int) ipp{
    itemsPerPage = ipp;
}

+(NSDateFormatter*) getDateFormatter{
    if (dateFormatter==nil){
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:dateFormat];
    }
    return dateFormatter;
}

+(void) addAttrChangedListener:(id<AttrChangedListener>) listener{
    if (attrChangedListeners == nil){
        attrChangedListeners = [[NSMutableArray alloc]init];
    }
    [attrChangedListeners addObject:listener];
}

@end