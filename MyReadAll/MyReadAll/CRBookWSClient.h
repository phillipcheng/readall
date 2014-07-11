//
//  CRBookWSClient.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "Book.h"
#import "Volume.h"
#import "SearchPostProcess.h"
#import "DownloadPostProcess.h"
#import "LoginPostProcess.h"
#import "SignupPostProcess.h"
#import "MyReadingsPostProcess.h"

@interface CRBookWSClient : NSObject

extern NSString* const EmptyParameter;

-(id) initWithMainUrl:(NSString*) mainUrl timeout:(int) timeout;

-(Volume*) getVolumeById:(NSString*) volId error:(NSError*)err;
-(Book*) getBookById:(NSString*) bookId error:(NSError*)err;

//
-(NSArray*) getVolumesByPCat:(NSString*) pcat offset:(int) offset limit:(int) limit error:(NSError*)err;
-(NSArray*) getVolumesLike:(NSString*) param userId:(NSString*) userId type:(int) type offset:(int) offset limit:(int) limit error:(NSError*)err;
-(int) getVCByPCat:(NSString*) pcat error:(NSError*)err;
-(int) getVCLike:(NSString*) param userId:(NSString*) userId type:(int) type error:(NSError*)err;

//
-(NSArray*) getBooksByName:(NSString*) name userId:(NSString*)userId type:(int)type offset:(int)offset limit:(int) limit error:(NSError*)err;
-(NSArray*) getBooksByCat:(NSString*) catId offset:(int)offset limit:(int) limit error:(NSError*)err;
-(int) getBCByName:(NSString*) name userId:(NSString*)userId type:(int)type error:(NSError*)err;
-(int) getBCByCat:(NSString*) catId error:(NSError*)err;
//
-(NSString*) login:(NSString*) device userId:(NSString*)userId password:(NSString*)password stime:(NSString*) stime error:(NSError*)err;
-(BOOL) logout:(NSString*) sessionId etime:(NSString*) etime error:(NSError*)err;
//
-(NSString*) addUser:(NSString*) user pass:(NSString*) pass error:(NSError*)err;
//
-(int) addMyReadings:(NSString*)userId ids:(NSArray*) ids error:(NSError*)err;
-(int) deleteMyReadings:(NSString*)userId ids:(NSArray*) ids error:(NSError*)err;

//public async methods
-(void) asyncGetReadingsByParam:(NSString*) searchTxt catId:(NSString*) catId userId:(NSString*)userId type:(int)type offset:(int) offset limit:(int) limit postProcessor:(id <SearchPostProcess>) postProcessor;

-(void) asyncGetImage:(NSString*) url referer:(NSString*) referer ppParam:(id)ppParam postProcessor:(id <DownloadPostProcess>) postProcessor;

-(void) asyncLogin:(NSString*) userId pass:(NSString*) pass postProcessor:(id<LoginPostProcess>) postProcessor;

-(void) asyncLogout:(NSString*) sessionId;

-(void) asyncSignup:(NSString*) userId pass:(NSString*) pass postProcessor:(id<SignupPostProcess>) postProcessor;

-(void) asyncAddMyReading:(NSString*) userId ids:(NSArray*) ids postProcessor:(id<MyReadingsPostProcess>) postProcessor;

-(void) asyncDelMyReading:(NSString*) userId ids:(NSArray*) ids postProcessor:(id<MyReadingsPostProcess>) postProcessor;

@end