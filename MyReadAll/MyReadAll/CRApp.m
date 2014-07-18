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
static NSMutableDictionary* siteConfMap;

NSString* const LOGIN_FAILED=@"LoginFailed";
NSString* const SIGN_UP_SUCCEED=@"SignupSucceed";
NSString* const USER_EXIST=@"UserExist";

@implementation CRApp

+(Volume*) getTemplate:(NSString*) readingId{
    if (siteConfMap==nil){
        siteConfMap = [[NSMutableDictionary alloc]init];
        return nil;
    }else{
        NSString* siteId = [readingId componentsSeparatedByString:@"."][0];
        NSString* rootVolId = [NSString stringWithFormat:@"%@.%@", siteId, siteId];
        return [siteConfMap objectForKey:rootVolId];
    }
}

+(void) buildTemplateCache{
    if (siteConfMap==nil){
        siteConfMap = [[NSMutableDictionary alloc]init];
    }
    NSString* rootString = [[NSString alloc]init];
    int i=0;
    for (NSString* key in [[Volume RootVolumes] keyEnumerator]) {
        if (i>0){
            rootString= [rootString stringByAppendingString:@","];
        }
        rootString = [rootString stringByAppendingString:key];
        i++;
    }
    NSError* err;
    NSArray* volList = [[CRApp getWSClient] getVolumesByPCat:rootString offset:0 limit:20 error:err];
    for (Volume* vol in volList) {
        [siteConfMap setObject:vol forKey:[vol getId]];
    }
}

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