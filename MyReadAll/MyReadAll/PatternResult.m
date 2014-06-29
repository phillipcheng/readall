//
//  PatternResult.m
//  ReadAll
//
//  Created by Cheng Yi on 6/13/14.
//  Copyright (c) 2014 Cheng Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatternResult.h"
#import "StringUtil.h"

@implementation PatternResult

int const pt_x_s_yyy_zzz=1;
int const pt_0x_s_yyy_zzz=2;
int const pt_pxp_s_yyy_zzz=3;
int const pt_0x0y_zzz=4;
int const pt_list=5;

int const IM_INC = 1;
int const IM_DEC = 2;

int const default_patternType=pt_x_s_yyy_zzz;
int const default_digitNum=0;
int const default_startImageCount=1;
NSString* const default_patternSuffix=@"jpg";
NSString* const default_patternPrefix=@"";
NSString* const default_postFix=@"";
NSString* const default_sep=@"";
int const default_incMode=IM_INC;

NSString* const JSKEY_PATTERN_TYPE=@"pt";
NSString* const JSKEY_DIGIT_NUM=@"dn";
NSString* const JSKEY_START_IMAGE=@"sm";
NSString* const JSKEY_SUFFIX=@"suf";
NSString* const JSKEY_PREFIX=@"prf";
NSString* const JSKEY_POSTFIX=@"pf";
NSString* const JSKEY_SEP=@"sep";
NSString* const JSKEY_INCMODE=@"im";
NSString* const JSKEY_PAGELIST=@"pl";


-(id) init{
    self=[super init];
    if (self){
        _patternType=default_patternType;
        _digitNum = default_digitNum;
        _startImageCount = default_startImageCount;
        _patternSuffix = default_patternSuffix;
        _patternPrefix = default_patternPrefix;
        _postFix = default_postFix;
        _sep = default_sep;
        _incMode = default_incMode;
    }
    return self;
}

-(NSString*) description{
    NSString* desc=[NSString stringWithFormat:
                    @"patternType:%d, digitNum:%d, startImageCount:%d, suffix:%@, prefix:%@, postfix:%@, sep:%@, incMode:%d",
                    _patternType, _digitNum, _startImageCount, _patternSuffix, _patternPrefix, _postFix, _sep, _incMode];
    return desc;
}

-(NSString*) toJSON{
    NSMutableDictionary *jsonDic=[[NSMutableDictionary alloc]init];
    if(_patternType!=default_patternType){
        NSNumber *num = [NSNumber numberWithInt:_patternType];
        [jsonDic setObject:num forKey:JSKEY_PATTERN_TYPE];
    }
    if (_digitNum != default_digitNum){
        NSNumber *num = [NSNumber numberWithInt:_digitNum];
        [jsonDic setObject:num forKey:JSKEY_DIGIT_NUM];
    }
    if (_startImageCount != default_startImageCount){
        NSNumber *num = [NSNumber numberWithInt:_startImageCount];
        [jsonDic setObject:num forKey:JSKEY_START_IMAGE];
    }
    if (![default_patternSuffix isEqualToString:_patternSuffix]){
        [jsonDic setObject:_patternSuffix forKey:JSKEY_SUFFIX];
    }
    if (![default_patternPrefix isEqualToString:_patternPrefix]){
        [jsonDic setObject:_patternPrefix forKey:JSKEY_PREFIX];
    }
    if (![default_postFix isEqualToString:_postFix]){
        [jsonDic setObject:_postFix forKey:JSKEY_POSTFIX];
    }
    if (![default_sep isEqualToString:_sep]){
        [jsonDic setValue:_sep forKey: JSKEY_SEP];
    }
    if (_incMode != default_incMode){
        NSNumber *num = [NSNumber numberWithInt: _incMode];
        [jsonDic setObject:num forKey:JSKEY_INCMODE];
    }
    if (_ppUrls){
        [jsonDic setObject:_ppUrls forKey:JSKEY_PAGELIST];
    }
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&err];
    
    NSString *ret=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON=%@ error:%@", ret, [err description]);
    return ret;
}

-(void) fromJSONString:(NSString *)jsonString{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    [self fromJSONObject:dict];
}

-(void) fromJSONObject:(NSDictionary*) dict{
    NSNumber* num =[dict objectForKey:JSKEY_PATTERN_TYPE];
    if (num){
        _patternType = [num intValue];
    }
    num=[dict objectForKey:JSKEY_DIGIT_NUM];
    if (num){
        _digitNum=[num intValue];
    }
    num = [dict objectForKey:JSKEY_START_IMAGE];
    if(num){
        _startImageCount=[num intValue];
    }
    NSString* str = [dict objectForKey:JSKEY_SUFFIX];
    if(str){
        _patternSuffix = str;
    }
    str = [dict objectForKey:JSKEY_PREFIX];
    if (str){
        _patternPrefix = str;
    }
    str = [dict objectForKey:JSKEY_POSTFIX];
    if (str){
        _postFix =str;
    }
    num = [dict objectForKey:JSKEY_INCMODE];
    if(num){
        _incMode = [num intValue];
    }
    _ppUrls=[dict objectForKey:JSKEY_PAGELIST];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPR:other];
}

- (BOOL)isEqualToPR:(PatternResult *)pr {
    if (self.patternType != pr.patternType)
        return NO;
    if (self.digitNum != pr.digitNum)
        return NO;
    if (self.startImageCount!=pr.startImageCount)
        return NO;
    if (![self.patternSuffix isEqual: pr.patternSuffix]){
        return NO;
    }
    if (![self.patternPrefix isEqual:pr.patternPrefix]){
        return NO;
    }
    if (![self.postFix isEqual:pr.postFix]){
        return NO;
    }
    if (![self.sep isEqual:pr.sep]){
        return NO;
    }
    if (self.incMode!=pr.incMode){
        return NO;
    }
    if ([self.ppUrls count] != [pr.ppUrls count]){
        return NO;
    }
    for (int i=0; i<[self.ppUrls count]; i++){
        if (![[self.ppUrls objectAtIndex:i] isEqual: [pr.ppUrls objectAtIndex:i]]){
            return NO;
        }
    }
    return YES;
}

+(NSString*) guessUrl:(PatternResult*) pr atDelta:(int) delta{
    NSString* imageUrl;
    if (pr.patternType == pt_0x_s_yyy_zzz){
        NSString* pageNum = [StringUtil getStringFromNum:delta+pr.startImageCount digitCount:pr.digitNum];
        imageUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@", pr.patternPrefix, pageNum, pr.sep, pr.postFix, @".", pr.patternSuffix];
    }else if (pr.patternType == pt_x_s_yyy_zzz){
        int pageNum = delta + pr.startImageCount;
        imageUrl = [NSString stringWithFormat:@"%@%d%@%@%@%@", pr.patternPrefix, pageNum, pr.sep, pr.postFix, @".", pr.patternSuffix];
    }else if (pr.patternType == pt_pxp_s_yyy_zzz){
        NSString* pageNum = [StringUtil getStringFromNum:delta+pr.startImageCount digitCount:pr.digitNum];
        imageUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", pr.patternPrefix, @"%28", pageNum, @"%29", pr.sep, pr.postFix, @".", pr.patternSuffix];
    }else if (pr.patternType == pt_0x0y_zzz){
        NSString* pageNum1 = [StringUtil getStringFromNum:delta+pr.startImageCount digitCount:pr.digitNum];
        NSString* pageNum2 = [StringUtil getStringFromNum:delta+pr.startImageCount+1 digitCount:pr.digitNum];
        imageUrl = [NSString stringWithFormat:@"%@%@%@%@%@", pr.patternPrefix, pageNum1, pageNum2, @".", pr.patternSuffix];
    }else if (pr.patternType==pt_list){
        if (pr.ppUrls){
            if (delta>=0 && delta<[pr.ppUrls count]){
                imageUrl = [NSString stringWithFormat:@"%@%@%@", pr.patternPrefix, [pr.ppUrls objectAtIndex:delta], pr.patternSuffix];
            }
        }
    }
    return imageUrl;
}

@end