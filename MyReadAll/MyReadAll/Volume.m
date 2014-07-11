//
//  Volume.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/15/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Volume.h"

@implementation Volume

NSString* const ROOT_VOLUME_PREFIX=@"99999";

NSString* const ROOT_VOLUME_LHH=@"999999";
NSString* const ROOT_VOLUME_MH=@"999998";
NSString* const ROOT_VOLUME_SELF=@"999997";
NSString* const ROOT_VOLUME_XS=@"999996";

NSString* const VOLUME_KEY=@"Volume";
NSString* const VOL_ID_KEY=@"id";
NSString* const VOL_NAME_KEY=@"name";
NSString* const VOL_UTIME_KEY=@"utime";
NSString* const VOL_DATA_KEY=@"data";
NSString* const VOL_CAT_KEY=@"cat";
NSString* const VOL_AUTHOR_KEY=@"au";
NSString* const VOL_BOOKNUM_KEY=@"bn";
NSString* const KEY_CONTENT_XPATH=@"content_xpath";
NSString* const KEY_REFERER=@"referer";

static NSMutableDictionary* RootVolumes;
+(NSMutableDictionary*) RootVolumes{
    if (RootVolumes == nil){
        RootVolumes=[[NSMutableDictionary alloc]init];
        Volume* v1 = [[Volume alloc]initWithId:ROOT_VOLUME_LHH];
        [RootVolumes setObject:v1 forKey:ROOT_VOLUME_LHH];
        Volume* v2 = [[Volume alloc]initWithId:ROOT_VOLUME_MH];
        [RootVolumes setObject:v2 forKey:ROOT_VOLUME_MH];
        Volume* v3 = [[Volume alloc]initWithId:ROOT_VOLUME_SELF];
        [RootVolumes setObject:v3 forKey:ROOT_VOLUME_SELF];
        Volume* v4 = [[Volume alloc]initWithId:ROOT_VOLUME_XS];
        [RootVolumes setObject:v4 forKey:ROOT_VOLUME_XS];
    }
    return RootVolumes;
}

-(id)initWithId:(NSString*) volId{
    self=[super init];
    if (self){
        _volId = volId;
    }
    return self;
}

- (NSString*) getFullPath{
    return _fullPath;
}

- (NSString*) getName{
    return _name;
}

- (void) setName:(NSString*) name{
    _name = name;
}

- (NSString*) getCoverUri{
    return _coverUri;
}

- (void) setCoverUri:(NSString*) coverUri{
    _coverUri = coverUri;
}

- (NSString*) getCat{
    return _pCat;
}
- (NSString*) getId{
    return _volId;
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

-(int)getType{
    return _type;
}
-(void)setType: (int) type{
    _type = type;
}
-(NSString*)getAuthor{
    return _author;
}

- (void) dataToJSON{
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc]init];
    if (_coverUri){
        [mDict setObject:_coverUri forKey:KEY_COVER_URI];
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
    _contentXPath = [dict objectForKey:KEY_CONTENT_XPATH];
    _referer = [dict objectForKey: KEY_REFERER];
}

- (NSDictionary*) toJSONObject{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_volId forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_ID_KEY]];
    [dict setObject:[NSNumber numberWithInt:_type] forKey:[NSString stringWithFormat:@"%@%@", AT, KEY_TYPE]];
    [dict setObject:_name forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_NAME_KEY]];
    [dict setObject:_utime forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_UTIME_KEY]];
    [dict setObject:_data forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_DATA_KEY]];
    [dict setObject:_pCat forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_CAT_KEY]];
    [dict setObject:_author forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_AUTHOR_KEY]];
    [dict setObject:[NSNumber numberWithInt:_bookNum] forKey:[NSString stringWithFormat:@"%@%@", AT, VOL_BOOKNUM_KEY]];
    return dict;
}

-(NSString*) description{
    NSString* desc=[NSString stringWithFormat:@"volId:%@, type:%d, name:%@, utime:%@, data:%@, pcat:%@, author:%@, bookNum:%d, coverUri:%@",
                    _volId, _type, _name, _utime, _data, _pCat, _author, _bookNum, _coverUri];
    return desc;
}

-(NSString*) toTopJSONString{
    NSDictionary* dict = [self toJSONObject];
    NSMutableDictionary* topDict = [[NSMutableDictionary alloc]init];
    [topDict setObject:dict forKey:VOLUME_KEY];
    NSError* err;
    NSData* data = [NSJSONSerialization dataWithJSONObject:topDict options:0 error:&err];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (void) fromTopJSONObject:(NSDictionary*) dict{
    _volId = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_ID_KEY]];
    _type = [[dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, KEY_TYPE]] intValue];
    _name = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_NAME_KEY]];
    _utime = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_UTIME_KEY]];
    _data = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_DATA_KEY]];
    
    [self dataFromJSON];
    
    _pCat = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_CAT_KEY]];
    _author = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_AUTHOR_KEY]];
    NSNumber* numBookNum = [dict objectForKey:[NSString stringWithFormat:@"%@%@", AT, VOL_BOOKNUM_KEY]];
    _bookNum = [numBookNum intValue];
}

- (void) fromTopJSONString:(NSString*) jstring{
    NSError* err;
    NSDictionary* topDict = [NSJSONSerialization JSONObjectWithData:[jstring dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    NSDictionary* dict = [topDict valueForKey:VOLUME_KEY];
    [self fromTopJSONObject:dict];
}
@end