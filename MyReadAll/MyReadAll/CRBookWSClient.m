//
//  CRBookWSClient.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRBookWSClient.h"
#import "SearchCondition.h"
#import "SearchResult.h"
#import "FileCache.h"
#import "ImageUtil.h"
#import "CRApp.h"
#import <UIKit/UIKit.h>

@interface CRBookWSClient()

@property (nonatomic) NSString* mainRequestUrl;
@property (nonatomic) int timeout;

@end

NSString* const EmptyParameter=@"EmptyParameter";
int const ADD_OP=1;
int const DEL_OP=2;

@implementation CRBookWSClient

+(NSString*) convertToEmptyParam:(NSString*) param{
    if (param==nil || [@"" isEqualToString:param]){
        return EmptyParameter;
    }else{
        return param;
    }
}

+(NSString*) convertFromEmptyParam:(NSString*) param{
    if ([EmptyParameter isEqualToString:param]){
        return @"";
    }else{
        return param;
    }
}

-(id) init{
    self = [super init];
    if (self){
        _mainRequestUrl=@"http://ec2-54-187-167-132.us-west-2.compute.amazonaws.com:8080/crbookws/services/crbookrs";
        _timeout = 60;
    }
    return self;
}

-(id) initWithMainUrl:(NSString*) mainUrl timeout:(int) timeout{
    self=[super init];
    if (self){
        _mainRequestUrl = mainUrl;
        _timeout = timeout;
    }
    return self;
}

-(NSArray*) getVolumesByParam:(NSString*) param userId:(NSString*) userId type:(int)type offset:(int) offset limit:(int) limit error:(NSError*) err{
    userId = [CRBookWSClient convertToEmptyParam:userId];
    NSString* url = [[NSString alloc]initWithFormat:@"%@/crbookrs/volumes/%@/%d/%d/%@/%d/", _mainRequestUrl, param, offset, limit, userId, type];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    //just for log
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:&err];
    NSMutableArray* array = [dict objectForKey:VOLUME_KEY];
    NSMutableArray* retArray=[[NSMutableArray alloc]initWithCapacity:[array count]];
    for (int i=0; i<[array count]; i++){
        NSDictionary* d = [array objectAtIndex:i];
        Volume* v = [[Volume alloc]init];
        [v fromTopJSONObject:d];
        [retArray setObject:v atIndexedSubscript:i];
    }
    return retArray;
}

-(NSArray*) getVolumesByPCat:(NSString*) pcat offset:(int) offset limit:(int) limit error:(NSError *)err{
    //get by cat not linked with my reading
    NSString* escapedName = [pcat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"cat/", escapedName];
    return [self getVolumesByParam:param userId:@"" type:-1 offset:offset limit:limit error:err];
}
-(NSArray*) getVolumesLike:(NSString*) likeParam userId:(NSString*) userId type:(int)type
                    offset:(int) offset limit:(int) limit error:(NSError *)err{
    likeParam =[CRBookWSClient convertToEmptyParam:likeParam];
    NSString* escapedName = [likeParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"like/", escapedName];
    return [self getVolumesByParam:param userId:userId type:type offset:offset limit:limit error:err];
}

-(int) getCountByParam:(NSString*) param userId:(NSString*) userId type:(int)type error:(NSError*) err{
    userId = [CRBookWSClient convertToEmptyParam:userId];
    NSString* url = [[NSString alloc]initWithFormat:@"%@/crbookrs/%@/%@/%d/", _mainRequestUrl, param, userId, type];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    return [rsp intValue];
}

-(int) getVCByPCat:(NSString*) pcat error:(NSError*) err{
    //get by cat not linked with my reading
    NSString* escapedName = [pcat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/cat/", escapedName];
    return [self getCountByParam:param userId:@"" type:-1 error:err];
}
-(int) getVCLike:(NSString*) likeParam userId:(NSString*) userId type:(int) type error:(NSError *)err{
    likeParam = [CRBookWSClient convertToEmptyParam:likeParam];
    NSString* escapedName = [likeParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/like/", escapedName];
    return [self getCountByParam:param userId:userId type:type error:err];
}

-(Volume*) getVolumeById:(NSString*) volId error:(NSError *)err{
    NSString* escapedId = [volId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@", _mainRequestUrl, @"/crbookrs/volumes/", escapedId];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    
    Volume* volume = [[Volume alloc]init];
    [volume fromTopJSONString:rsp];
    return volume;
}

-(NSArray*) getBooksByParam:(NSString*) param userId:(NSString*) userId type:(int)type
                     offset:(int)offset limit:(int) limit error:(NSError*) err{
    userId = [CRBookWSClient convertToEmptyParam:userId];
    NSString* url = [[NSString alloc]initWithFormat:@"%@/crbookrs/books/%@/%d/%d/%@/%d/", _mainRequestUrl, param, offset, limit, userId, type];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    //just for debug
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:&err];
    NSArray* array = [dict objectForKey:BOOK_KEY];
    NSMutableArray* retArray=[[NSMutableArray alloc]initWithCapacity:[array count]];
    for (int i=0; i<[array count]; i++){
        NSDictionary* d = [array objectAtIndex:i];
        Book* b = [[Book alloc]init];
        [b fromTopJSONObject:d];
        [retArray setObject:b atIndexedSubscript:i];
    }
    return retArray;

}
-(NSArray*) getBooksByName:(NSString*) name userId:(NSString*) userId type:(int)type offset:(int)offset limit:(int) limit error:(NSError *)err{
    name = [CRBookWSClient convertToEmptyParam:name];
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"name/", escapedName];
    return [self getBooksByParam:param userId:userId type:type offset:offset limit:limit error:err];
}
-(NSArray*) getBooksByCat:(NSString*) catId offset:(int)offset limit:(int) limit error:(NSError *)err{
    //get by cat not linked with my reading
    NSString* escapedName = [catId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"cat/", escapedName];
    return [self getBooksByParam:param userId:@"" type:-1 offset:offset limit:limit error:err];
}
-(int) getBCByName:(NSString*) name userId:(NSString*) userId type:(int)type error:(NSError *)err{
    name = [CRBookWSClient convertToEmptyParam:name];
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"booksCount/name/", escapedName];
    return [self getCountByParam:param userId:userId type:type error:err];
}
-(int) getBCByCat:(NSString*) catId error:(NSError *)err{
    //get by cat not linked with my reading
    NSString* escapedName = [catId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"booksCount/cat/", escapedName];
    return [self getCountByParam:param userId:@"" type:-1 error:err];
}
-(Book*) getBookById:(NSString*) bookId error:(NSError *)err{
    NSString* escapedId = [bookId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@", _mainRequestUrl, @"/crbookrs/books/", escapedId];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    
    Book* book = [[Book alloc]init];
    [book fromTopJSONString:rsp];
    return book;
}

-(NSString*) login:(NSString*) device userId:(NSString*)userId password:(NSString*)password stime:(NSString*) stime error:(NSError *)err{
    userId = [CRBookWSClient convertToEmptyParam:userId];
    password = [CRBookWSClient convertToEmptyParam:password];
    NSString* url = [[NSString alloc]initWithFormat:@"%@/crbookrs/login/%@/%@/%@/%@", _mainRequestUrl, device, userId, password, stime];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* sessionId = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    return sessionId;

}
-(BOOL) logout:(NSString*) sessionId etime:(NSString*) etime error:(NSError *)err{
    NSString* url = [[NSString alloc]initWithFormat:@"%@/crbookrs/logout/%@/%@", _mainRequestUrl, sessionId, etime];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* ret = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return [ret boolValue];
}

-(NSString*) addUser:(NSString*) user pass:(NSString*) pass error:(NSError*)err {
    NSString* url = [[NSString alloc]initWithFormat:@"%@/crbookrs/signup/%@/%@", _mainRequestUrl, user, pass];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* ret = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return ret;
}

-(int) intReturnFromPut:(NSString*)url userId:(NSString*)userId ids:(NSArray*)ids error:(NSError*)err{
    NSString* idsString=@"";
    for (int i=0; i<[ids count]; i++){
        NSString* id = [ids objectAtIndex:i];
        if (i>0){
            idsString = [idsString stringByAppendingFormat:@",%@",id];
        }else{
            idsString = [idsString stringByAppendingString:id];
        }
    }
    NSLog(@"idsString:%@", idsString);
    
    NSMutableURLRequest* theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:_timeout];
    [theRequest setHTTPMethod:@"PUT"];
    NSString* body = [NSString stringWithFormat:@"userId=%@&rids=%@", userId, idsString];
    [theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* ret = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return [ret intValue];
    
}
-(int) addMyReadings:(NSString*)userId ids:(NSArray*) ids error:(NSError*)err{
    NSString* url = [NSString stringWithFormat:@"%@/crbookrs/myreadings/add/", _mainRequestUrl];
    return [self intReturnFromPut:url userId:userId ids:ids error:err];
}
-(int) deleteMyReadings:(NSString*)userId ids:(NSArray*) ids error:(NSError*)err{
    NSString* url = [NSString stringWithFormat:@"%@/crbookrs/myreadings/delete/", _mainRequestUrl];
    return [self intReturnFromPut:url userId:userId ids:ids error:err];
}

//public async methods
-(void) asyncGetReadingsByParam:(NSString*) searchTxt catId:(NSString*) catId userId:(NSString*) userId type:(int) type offset:(int) offset limit:(int) limit postProcessor:(id <SearchPostProcess>) postProcessor{
    //catId is nil means using param to search with userId
    //catId is not nil means search with catId without userId
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray* readings = [[NSMutableArray alloc]init];
        NSError* err;
        long count=0;
        if ((searchTxt!=nil && ![@"" isEqualToString:searchTxt])||//search by text
            ([CRApp isMyReading]&&(catId==nil)))//root level my reading list
        {
            //search by text, userId will be handled by server
            [readings addObjectsFromArray:[self getVolumesLike:searchTxt userId:userId type:type offset:offset limit:limit error:err]];
            if ([readings count]<limit){
                count = [readings count];
            }else{
                count = [self getVCLike:searchTxt userId:userId type:type error:err];
            }
            NSMutableArray* books = [[NSMutableArray alloc]init];
            [books addObjectsFromArray:[self getBooksByName:searchTxt userId:userId type:type offset:offset limit:limit error:err]];
            if ([books count]<limit){
                count+=[books count];
            }else{
                count+=[self getBCByName:searchTxt userId:userId type:type error:err];
            }
            
            [readings addObjectsFromArray:books];
            
        }else{
            //search by cat, no userId needed, root level my reading list will be handled by previous block
            [readings addObjectsFromArray:[self getVolumesByPCat:catId offset:offset limit:limit error:err]];
            if ([readings count]<limit){
                count = [readings count];
            }else{
                count = [self getVCByPCat:catId error:err];
            }
            NSMutableArray* books = [[NSMutableArray alloc]init];
            [books addObjectsFromArray:[self getBooksByCat:catId offset:offset limit:limit error:err]];
            if ([books count]<limit){
                count+=[books count];
            }else{
                count += [self getBCByCat:catId error:err];
            }
            [readings addObjectsFromArray:books];
            
        }
        SearchResult* sr = [[SearchResult alloc]init];
        sr.readings = readings;
        sr.count = (int)count;

        [postProcessor postProcess:searchTxt searchCat:catId offset:offset limit:limit result:sr err:err];

    });
}

-(void) asyncGetImage:(NSString*) strUrl referer:(NSString*)referer ppParam:(id)ppParam postProcessor:(id <DownloadPostProcess>) postProcessor {
    if (strUrl){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSError* err;
            NSURL *url = [NSURL URLWithString:strUrl];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            [urlRequest setHTTPMethod:@"Get"];
            [urlRequest setValue:referer forHTTPHeaderField:@"Referer"];
            NSURLResponse *response;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&err];
            //call post-processor
            [postProcessor postProcess:strUrl result:data ppParam:ppParam err:err];
        });
    }
}

-(void) asyncLogin:(NSString*) userId pass:(NSString*) pass postProcessor:(id<LoginPostProcess>) postProcessor {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError* err;
        NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
        NSString *deviceId = [identifierForVendor UUIDString];
        NSString *utime = [[CRApp getDateFormatter] stringFromDate:[NSDate date]];
        NSLog(@"deviceid:%@, utime:%@", deviceId, utime);
        NSString* sid = [self login:deviceId userId:userId password:pass stime:utime error:err];
        [postProcessor loginPostProcess:userId password:pass result:sid err:err];
    });
}

-(void) asyncLogout:(NSString*) sessionId{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError* err;
        NSString *utime = [[CRApp getDateFormatter] stringFromDate:[NSDate date]];
        [self logout:sessionId etime:utime error:err];
    });
}

-(void) asyncSignup:(NSString*) userId pass:(NSString*) pass postProcessor:(id<SignupPostProcess>) postProcessor {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError* err;
        NSString* ret = [self addUser:userId pass:pass error:err];
        [postProcessor signupPostProcess:userId password:pass result:ret err:err];
    });
}

-(void) asyncAddMyReading:(NSString*) userId ids:(NSMutableArray*) ids postProcessor:(id<MyReadingsPostProcess>) postProcessor {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int ret=0;
        NSError* err;
        ret = [self addMyReadings:userId ids:ids error:err];
        [postProcessor myReadingPostProcess:userId ids:ids rowsAffected:ret err:err];
    });
}

-(void) asyncDelMyReading:(NSString*) userId ids:(NSMutableArray*) ids postProcessor:(id<MyReadingsPostProcess>) postProcessor {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        int ret=0;
        NSError* err;
        ret = [self deleteMyReadings:userId ids:ids error:err];
        [postProcessor myReadingPostProcess:userId ids:ids rowsAffected:ret err:err];
    });
}

@end

