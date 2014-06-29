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

@implementation CRApp

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
    userId = uid;
}

+(NSString*) getSessionId{
    return sessionId;
}
+(void) setSessionId:(NSString*) sid{
    sessionId=sid;
}
@end