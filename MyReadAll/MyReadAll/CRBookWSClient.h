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

@interface CRBookWSClient : NSObject

-(id) initWithMainUrl:(NSString*) mainUrl timeout:(int) timeout;

-(NSArray*) getVolumesByPCat:(NSString*) pcat offset:(int) offset limit:(int) limit error:(NSError*)err;
-(NSArray*) getVolumesLike:(NSString*) param offset:(int) offset limit:(int) limit error:(NSError*)err;
-(int) getVCByPCat:(NSString*) pcat error:(NSError*)err;
-(int) getVCLike:(NSString*) param error:(NSError*)err;
-(Volume*) getVolumeById:(NSString*) volId error:(NSError*)err;

-(NSArray*) getBooksByName:(NSString*) name offset:(int)offset limit:(int) limit error:(NSError*)err;
-(NSArray*) getBooksByCat:(NSString*) catId offset:(int)offset limit:(int) limit error:(NSError*)err;
-(int) getBCByName:(NSString*) name error:(NSError*)err;
-(int) getBCByCat:(NSString*) catId error:(NSError*)err;
-(Book*) getBookById:(NSString*) bookId error:(NSError*)err;

-(NSString*) login:(NSString*) device stime:(NSString*) stime error:(NSError*)err;
-(BOOL) logout:(NSString*) sessionId etime:(NSString*) etime error:(NSError*)err;

//return the reading count
-(void) asyncGetReadingsByParam:(NSString*) searchTxt catId:(NSString*) catId offset:(int) offset limit:(int) limit
                  postProcessor:(id <SearchPostProcess>) postProcessor;

-(void) asyncGetImage:(NSString*) url ppParam:(id)ppParam postProcessor:(id <DownloadPostProcess>) postProcessor;

@end