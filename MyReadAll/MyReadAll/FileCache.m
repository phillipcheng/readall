//
//  FileCache.m
//  MyReadAll
//
//  Created by Cheng Yi on 6/19/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCache.h"
#import "StringUtil.h"

NSString* const CACHE_ROOT=@"bookcache";
NSString* const IMAGE_SUFFIX=@"jpg";


@implementation FileCache
static NSMutableDictionary* fileKeyCache;
+(NSMutableDictionary*) fileKeyCache{
    if (fileKeyCache == nil){
        fileKeyCache = [[NSMutableDictionary alloc]init];
        return fileKeyCache;
    }else{
        return fileKeyCache;
    }
}

+(NSString*) generateKey:(bool)isCover reading:(id<Reading>)reading pageNum:(int) pageNum{
    NSString* rKey;
    if (isCover == true){
        rKey = [NSString stringWithFormat:@"%@|%@",[reading getCat], [reading getId]];
    }else{
        rKey = [NSString stringWithFormat:@"%@|%d",[reading getId], pageNum];
    }
    NSString* fileKey = [[self fileKeyCache] objectForKey:rKey];
    if (fileKey==nil){
        NSString* catPath = [reading getId];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSLog(@"rootPath:%@", documentsDirectory);
        
        if (isCover == false){
            fileKey = [NSString stringWithFormat:@"%@/%@/%@/%@.%@", documentsDirectory, CACHE_ROOT, catPath, [StringUtil getStringFromNum:pageNum digitCount:3], IMAGE_SUFFIX];
        }else{
            fileKey = [NSString stringWithFormat:@"%@/%@/%@/%@.%@", documentsDirectory, CACHE_ROOT, catPath, @"cover", IMAGE_SUFFIX];
        }
        NSLog(@"localFilePath:%@", fileKey);
        [[self fileKeyCache] setObject:fileKey forKey:rKey];
    }
    return fileKey;
}

@end

