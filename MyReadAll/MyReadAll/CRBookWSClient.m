//
//  CRBookWSClient.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRBookWSClient.h"

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

-(NSArray*) getVolumesByParam:(NSString*) param offset:(int) offset limit:(int) limit{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%d%@%d", _mainRequestUrl, @"/crbookrs/volumes/", param, @"/", offset, @"/", limit];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    //just for log
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    NSArray* array = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:&err];
    return array;
}

-(NSArray*) getVolumesByName:(NSString*) name offset:(int) offset limit:(int) limit{
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"name/", escapedName];
    return [self getVolumesByParam:param offset:offset limit:limit];
}

-(NSArray*) getVolumesByAuthor:(NSString*) author offset:(int) offset limit:(int) limit{
    NSString* escapedName = [author stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"author/", escapedName];
    return [self getVolumesByParam:param offset:offset limit:limit];
}
-(NSArray*) getVolumesByPCat:(NSString*) pcat offset:(int) offset limit:(int) limit{
    NSString* escapedName = [pcat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"cat/", escapedName];
    return [self getVolumesByParam:param offset:offset limit:limit];
}
-(NSArray*) getVolumesLike:(NSString*) likeParam offset:(int) offset limit:(int) limit{
    NSString* escapedName = [likeParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"like/", escapedName];
    return [self getVolumesByParam:param offset:offset limit:limit];
}

-(int) getCountByParam:(NSString*) param {
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@", _mainRequestUrl, @"/crbookrs/", param];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    return [rsp intValue];
}
-(int) getVCByName:(NSString*) name{
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/name/", escapedName];
    return [self getCountByParam:param];
}
-(int) getVCByAuthor:(NSString*) author{
    NSString* escapedName = [author stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/author/", escapedName];
    return [self getCountByParam:param];
}
-(int) getVCByPCat:(NSString*) pcat{
    NSString* escapedName = [pcat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/cat/", escapedName];
    return [self getCountByParam:param];
}
-(int) getVCLike:(NSString*) likeParam{
    NSString* escapedName = [likeParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"volumesCount/like/", escapedName];
    return [self getCountByParam:param];
}

-(Volume*) getVolumeById:(NSString*) volId{
    NSString* escapedId = [volId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@", _mainRequestUrl, @"/crbookrs/volumes", escapedId];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    
    Volume* volume = [[Volume alloc]init];
    [volume fromTopJSONString:rsp];
    return volume;
}

-(NSArray*) getBooksByParam:(NSString*) param offset:(int)offset limit:(int) limit{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%d%@%d", _mainRequestUrl, @"/crbookrs/books/", param, @"/", offset, @"/", limit];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    //just for debug
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    NSArray* array = [NSJSONSerialization JSONObjectWithData:nsData options:0 error:&err];
    return array;

}
-(NSArray*) getBooksByName:(NSString*) name offset:(int)offset limit:(int) limit{
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"name/", escapedName];
    return [self getBooksByName:param offset:offset limit:limit];
}
-(NSArray*) getBooksByCat:(NSString*) catId offset:(int)offset limit:(int) limit{
    NSString* escapedName = [catId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"cat/", escapedName];
    return [self getBooksByName:param offset:offset limit:limit];
}
-(int) getBCByName:(NSString*) name{
    NSString* escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"booksCount/name/", escapedName];
    return [self getCountByParam:param];
}
-(int) getBCByCat:(NSString*) catId{
    NSString* escapedName = [catId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* param = [[NSString alloc]initWithFormat:@"%@%@", @"booksCount/cat/", escapedName];
    return [self getCountByParam:param];
}
-(Book*) getBookById:(NSString*) bookId{
    NSString* escapedId = [bookId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@", _mainRequestUrl, @"/crbookrs/books", escapedId];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* rsp = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"rsp:%@", rsp);
    
    Book* book = [[Book alloc]init];
    [book fromTopJSONString:rsp];
    return book;
}

-(NSString*) login:(NSString*) device stime:(NSString*) stime{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%@", _mainRequestUrl, @"/crbookrs/login", device, @"/", stime];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* sessionId = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    return sessionId;

}
-(BOOL) logout:(NSString*) sessionId etime:(NSString*) etime{
    NSString* url = [[NSString alloc]initWithFormat:@"%@%@%@%@%@", _mainRequestUrl, @"/crbookrs/logout", sessionId, @"/", etime];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:_timeout];
    NSURLResponse* theResponse;
    NSError* err;
    NSData* nsData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&err];
    NSString* ret = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return [ret boolValue];
}

@end

