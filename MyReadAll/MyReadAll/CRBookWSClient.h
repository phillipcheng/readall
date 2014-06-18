//
//  CRBookWSClient.h
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import "Book.h"
#import "Volume.h"

@interface CRBookWSClient : NSObject

-(id) initWithMainUrl:(NSString*) mainUrl timeout:(int) timeout;

-(NSArray*) getVolumesByName:(NSString*) name offset:(int) offset limit:(int) limit;
-(NSArray*) getVolumesByAuthor:(NSString*) author offset:(int) offset limit:(int) limit;
-(NSArray*) getVolumesByPCat:(NSString*) pcat offset:(int) offset limit:(int) limit;
-(NSArray*) getVolumesLike:(NSString*) param offset:(int) offset limit:(int) limit;
-(int) getVCByName:(NSString*) name;
-(int) getVCByAuthor:(NSString*) author;
-(int) getVCByPCat:(NSString*) pcat;
-(int) getVCLike:(NSString*) param;
-(Volume*) getVolumeById:(NSString*) volId;

-(NSArray*) getBooksByName:(NSString*) name offset:(int)offset limit:(int) limit;
-(NSArray*) getBooksByCat:(NSString*) catId offset:(int)offset limit:(int) limit;
-(int) getBCByName:(NSString*) name;
-(int) getBCByCat:(NSString*) catId;
-(Book*) getBookById:(NSString*) bookId;

-(NSString*) login:(NSString*) device stime:(NSString*) stime;
-(BOOL) logout:(NSString*) sessionId etime:(NSString*) etime;


@end