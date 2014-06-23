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
#import <UIKit/UIKit.h>

@interface CRBookWSClient()

@property (nonatomic) NSString* mainRequestUrl;
@property (nonatomic) int timeout;

@end


@implementation CRBookWSClient

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

-(NSArray*) getVolumesByParam:(NSString*) param offset:(int) offset limit:(int) limit error:(NSError*) err{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%d%@%d", _mainRequestUrl, @"/crbookrs/volumes/", param, @"/", offset, @"/", limit];
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
    NSString* escapedName = [pcat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"cat/", escapedName];
    return [self getVolumesByParam:param offset:offset limit:limit error:err];
}
-(NSArray*) getVolumesLike:(NSString*) likeParam offset:(int) offset limit:(int) limit error:(NSError *)err{
    NSString* escapedName = [likeParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"like/", escapedName];
    return [self getVolumesByParam:param offset:offset limit:limit error:err];
}

-(int) getCountByParam:(NSString*) param error:(NSError*) err{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@", _mainRequestUrl, @"/crbookrs/", param];
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
    NSString* escapedName = [pcat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/cat/", escapedName];
    return [self getCountByParam:param error:err];
}
-(int) getVCLike:(NSString*) likeParam error:(NSError *)err{
    NSString* escapedName = [likeParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/like/", escapedName];
    return [self getCountByParam:param error:err];
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

-(NSArray*) getBooksByParam:(NSString*) param offset:(int)offset limit:(int) limit error:(NSError*) err{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%d%@%d", _mainRequestUrl, @"/crbookrs/books/", param, @"/", offset, @"/", limit];
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
-(NSArray*) getBooksByName:(NSString*) name offset:(int)offset limit:(int) limit error:(NSError *)err{
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"name/", escapedName];
    return [self getBooksByParam:param offset:offset limit:limit error:err];
}
-(NSArray*) getBooksByCat:(NSString*) catId offset:(int)offset limit:(int) limit error:(NSError *)err{
    NSString* escapedName = [catId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"cat/", escapedName];
    return [self getBooksByParam:param offset:offset limit:limit error:err];
}
-(int) getBCByName:(NSString*) name error:(NSError *)err{
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"booksCount/name/", escapedName];
    return [self getCountByParam:param error:err];
}
-(int) getBCByCat:(NSString*) catId error:(NSError *)err{
    NSString* escapedName = [catId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"booksCount/cat/", escapedName];
    return [self getCountByParam:param error:err];
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

-(NSString*) login:(NSString*) device stime:(NSString*) stime error:(NSError *)err{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%@", _mainRequestUrl, @"/crbookrs/login/", device, @"/", stime];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* sessionId = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    return sessionId;

}
-(BOOL) logout:(NSString*) sessionId etime:(NSString*) etime error:(NSError *)err{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%@", _mainRequestUrl, @"/crbookrs/logout/", sessionId, @"/", etime];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* ret = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return [ret boolValue];
}

-(void) asyncGetReadingsByParam:(NSString*) searchTxt catId:(NSString*) catId offset:(int) offset limit:(int) limit
                  postProcessor:(id <SearchPostProcess>) postProcessor{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError* err;
        NSMutableArray* readings = [[NSMutableArray alloc]init];
        int count=0;
        if ((searchTxt) && (![@"" isEqualToString:searchTxt])){
            [readings addObjectsFromArray:[self getVolumesLike:searchTxt offset:offset limit:limit error:err]];
            [readings addObjectsFromArray:[self getBooksByName:searchTxt offset:offset limit:limit error:err]];
            
            //
            count = [self getVCLike:searchTxt error:err];
            count += [self getBCByName:searchTxt error:err];
            
        }else{
            if (catId){
                [readings addObjectsFromArray:[self getVolumesByPCat:catId offset:offset limit:limit error:err]];
                [readings addObjectsFromArray:[self getBooksByCat:catId offset:offset limit:limit error:err]];
                //
                count = [self getVCByPCat:catId error:err];
                count += [self getBCByCat:catId error:err];
            }else{
                //do nothing
            }
        }
        SearchResult* sr = [[SearchResult alloc]init];
        sr.readings = readings;
        sr.count = count;
        
        if (!err){
            NSLog(@"readings got: %@", readings);
            [postProcessor postProcess:searchTxt searchCat:catId offset:offset limit:limit result:sr];
        }else{
            NSLog(@"%@", [err description]);
        }
    });
}

-(void) asyncGetImage:(NSString*) url ppParam:(id)ppParam postProcessor:(id <DownloadPostProcess>) postProcessor{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        //call post-processor
        [postProcessor postProcess:url result:data ppParam:ppParam];
    });
}

@end

