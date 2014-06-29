//
//  CRApp.h
//  ReadAll
//
//  Created by Cheng Yi on 6/29/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "CRBookWSClient.h"

@interface CRApp:NSObject

+(CRBookWSClient*) getWSClient;

+(NSString*) getUserId;
+(void) setUserId:(NSString*) uid;

+(NSString*) getSessionId;
+(void) setSessionId:(NSString*) sid;

@end