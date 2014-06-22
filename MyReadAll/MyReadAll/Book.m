//
//  Book.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@implementation Book

NSString* const NAME_NONAME = @"noname";
NSString* const BOOK_KEY = @"Book";
NSString* const ID_KEY = @"id";
NSString* const NAME_KEY = @"name";
NSString* const TotalPage_KEY = @"tp";
NSString* const LastReadPage_KEY = @"lp";
NSString* const IndexedPage_KEY = @"ip";
NSString* const UTIME_KEY = @"utime";
NSString* const DATA_KEY = @"data";
NSString* const CAT_KEY = @"cat";
NSString* const FULL_PATH_KEY = @"fp";
NSString* const READ_KEY = @"read";
NSString* const CACHED_KEY = @"cached";

NSString* const KEY_STICKER_DIR = @"stickerDir";
NSString* const KEY_BASE_URL = @"bUrl";
NSString* const KEY_SUFFIX_URL = @"sUrl";
NSString* const KEY_PAGE_BGURL_PATTERN = @"pbgPtn";
NSString* const KEY_EACH_PAGE_URL = @"p";

- (NSString*) getFullPath{
    return _fullPath;
}

- (NSString*) getName{
    return _bookName;
}

- (void) setName:(NSString*) name{
    _bookName = name;
}

- (NSString*) getCoverUri{
    return _coverUri;
}

- (void) setCoverUri:(NSString*) coverUri{
    _coverUri = coverUri;
}

- (NSString*) getCat{
    return _cat;
}
- (NSString*) getId{
    return _bookId;
}
- (NSString*) getUtime{
    return _utime;
}
- (NSString*) getData{
    return _data;
}

- (int) getState{
    return _state;
}
- (void) setState: (int) state{
    _state = state;
}

- (void) dataToJSON{
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc]init];
    if (_coverUri){
        [mDict setObject:_coverUri forKey:KEY_COVER_URI];
    }
    if (_stickerDir){
        [mDict setObject:_stickerDir forKey:KEY_STICKER_DIR];
    }
    if (_bUrl){
        [mDict setObject:_bUrl forKey:KEY_BASE_URL];
    }
    if (_sUrl){
        [mDict setObject:_sUrl forKey:KEY_SUFFIX_URL];
    }
    if (_pageBgUrlPattern){
        NSString* strBgUrlPattern = [_pageBgUrlPattern toJSON];
        [mDict setObject:strBgUrlPattern forKey:KEY_PAGE_BGURL_PATTERN];
    }
    NSError* err;
    NSData* nsData = [NSJSONSerialization dataWithJSONObject:mDict options:0 error:&err];
    if (nsData){
        _data = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    }
}

- (void) dataFromJSON{
    NSData* d = [_data dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:&err];
    _coverUri = [dict objectForKey:KEY_COVER_URI];
    _stickerDir = [dict objectForKey:KEY_STICKER_DIR];
    _bUrl = [dict objectForKey:KEY_BASE_URL];
    _sUrl = [dict objectForKey:KEY_SUFFIX_URL];
    NSString* bgUrlDict = [dict objectForKey:KEY_PAGE_BGURL_PATTERN];
    _pageBgUrlPattern = [[PatternResult alloc]init];
    [_pageBgUrlPattern fromJSONString:bgUrlDict];
}

- (NSDictionary*) toJSONObject{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_bookId forKey:[NSString stringWithFormat:@"%@%@", AT, ID_KEY]];
    [dict setObject:_bookName forKey:[NSString stringWithFormat:@"%@%@", AT, NAME_KEY]];
    [dict setObject:[NSNumber numberWithInt:_totalpage] forKey:[NSString stringWithFormat:@"%@%@", AT, TotalPage_KEY]];
    [dict setObject:[NSNumber numberWithInt:_lastpage] forKey:[NSString stringWithFormat:@"%@%@", AT, LastReadPage_KEY]];
    [dict setObject:_utime forKey:[NSString stringWithFormat:@"%@%@", AT, UTIME_KEY]];
    [dict setObject:_data forKey:[NSString stringWithFormat:@"%@%@", AT, DATA_KEY]];
    [dict setObject:_cat forKey:[NSString stringWithFormat:@"%@%@", AT, CAT_KEY]];
    [dict setObject:[NSNumber numberWithInt:_read] forKey:[NSString stringWithFormat:@"%@%@", AT, READ_KEY]];
    [dict setObject:[NSNumber numberWithInt:_cached] forKey:[NSString stringWithFormat:@"%@%@", AT, CACHED_KEY]];
    [dict setObject:[NSNumber numberWithInt:_indexedPages] forKey:[NSString stringWithFormat:@"%@%@", AT, IndexedPage_KEY]];
    return dict;
}

-(NSString*) description{
    NSString* desc=[NSString stringWithFormat:@"bookId:%@, bookName:%@, totalpage:%d, lastpage:%d, utime:%@, data:%@, \
                    cat:%@, read:%d, cached:%d, indexedPages:%d, coverUri:%@, stickerDir:%@, bUrl:%@, sUrl:%@, bgUrlPattern:%@",
                    _bookId, _bookName, _totalpage, _lastpage, _utime, _data, _cat, _read, _cached, _indexedPages,
                    _coverUri, _stickerDir, _bUrl, _sUrl, [_pageBgUrlPattern description]];
    return desc;
}

-(NSString*) toTopJSONString{
    NSDictionary* dict = [self toJSONObject];
    NSMutableDictionary* topDict = [[NSMutableDictionary alloc]init];
    [topDict setObject:dict forKey:BOOK_KEY];
    NSError* err;
    NSData* data = [NSJSONSerialization dataWithJSONObject:topDict options:0 error:&err];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (void) fromTopJSONObject:(NSDictionary*) dict{
    _bookId = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, ID_KEY]];
    _bookName = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, NAME_KEY]];
    _utime = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, UTIME_KEY]];
    _data = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, DATA_KEY]];
    
    [self dataFromJSON];
    
    _cat = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, CAT_KEY]];
    _totalpage = [[dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, TotalPage_KEY]] intValue];
    _lastpage = [[dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, LastReadPage_KEY]] intValue];
    _read = [[dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, READ_KEY]] intValue];
    _cached = [[dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, CACHED_KEY]] intValue];
    _indexedPages = [[dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, IndexedPage_KEY]] intValue];
}

- (void) fromTopJSONString:(NSString*) jstring{
    NSError* err;
    NSDictionary* topDict = [NSJSONSerialization JSONObjectWithData:[jstring dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    NSDictionary* dict = [topDict objectForKey:BOOK_KEY];
    [self fromTopJSONObject:dict];
}

-(NSString*) getPageUrl:(int) pageNum{
    if (_pageBgUrlPattern){
        return [PatternResult guessUrl:_pageBgUrlPattern
                               atDelta:(pageNum-1)];
    }else{
        return nil;
    }
}

@end